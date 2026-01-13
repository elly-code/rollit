/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2020-2021 Patrick Csikos (https://zelikos.github.io)
 *                          2025 Stella & Charlie (teamcons.carrd.co)
 *                          2025 Contributions from the ellie_Commons community (github.com/elly-code/)
 */

public class Rollit.Menu : Gtk.Popover {

    public signal void close_menu ();
    public string current_choice;
    public signal void label_changed (string new_label);

    public Rollit.MenuItem four_sided;
    public Rollit.MenuItem six_sided;
    public Rollit.MenuItem eight_sided;
    public Rollit.MenuItem ten_sided;
    public Rollit.MenuItem twelve_sided;
    public Rollit.MenuItem twenty_sided;
    public Rollit.MenuItem hundred_sided;

    public Gtk.CheckButton custom_sided;
    private Gtk.SpinButton max_entry;

    public int max_roll { get; private set; }

    construct {

        four_sided = new Rollit.MenuItem (_("d4"), "1");
        six_sided = new Rollit.MenuItem (_("d6"), "2");
        eight_sided = new Rollit.MenuItem (_("d8"), "3");
        ten_sided = new Rollit.MenuItem (_("d10"), "4");
        twelve_sided = new Rollit.MenuItem (_("d12"), "5");
        twenty_sided = new Rollit.MenuItem (_("d20"), "6");
        hundred_sided = new Rollit.MenuItem (_("d100"), "7");

        var presets = new Gtk.Box (VERTICAL, 6) {
            margin_top = 6,
            margin_start = margin_end = 6,
            margin_bottom = 0
        };

        presets.append (four_sided);
        presets.append (six_sided);
        presets.append (eight_sided);
        presets.append (ten_sided);
        presets.append (twelve_sided);
        presets.append (twenty_sided);
        presets.append (hundred_sided);

        max_entry = new Gtk.SpinButton.with_range (1, 1000, 1) {
            sensitive = false
        };

        custom_sided = new Gtk.CheckButton ();
        four_sided.dice_radio.set_group (custom_sided);
        six_sided.dice_radio.set_group (custom_sided);
        eight_sided.dice_radio.set_group (custom_sided);
        ten_sided.dice_radio.set_group (custom_sided);
        twelve_sided.dice_radio.set_group (custom_sided);
        twenty_sided.dice_radio.set_group (custom_sided);
        hundred_sided.dice_radio.set_group (custom_sided);

        var custom_setting = new Gtk.Box (HORIZONTAL, 6) {
            margin_bottom = 12,
            margin_start = margin_end = 12,
            margin_top = 6,
            tooltip_text = _("Press 0 to immediately choose the custom dice")
        };

        custom_setting.append (custom_sided);
        custom_setting.append (max_entry);

        var separator = new Gtk.Separator (HORIZONTAL);

        var menu_box = new Gtk.Box (VERTICAL, 6);

        menu_box.append (presets);
        menu_box.append (separator);
        menu_box.append (custom_setting);

        load_max ();

        child = menu_box;

        // TRANSLATORS: %i represents a number: ex. d10 for a dice with 10 faces
        // This will be displayed in a button with a menu to let people choose
        current_choice = _("d%i").printf (max_roll);
        label_changed (current_choice);

        tooltip_text = _("Dice settings");
        tooltip_markup = Granite.markup_accel_tooltip ({"<Ctrl>D"}, tooltip_text);

        four_sided.clicked.connect ( () => {
            change_max (4, "d4");
        });

        six_sided.clicked.connect ( () => {
            change_max (6, "d6");
        });

        eight_sided.clicked.connect ( () => {
            change_max (8, "d8");
        });

        ten_sided.clicked.connect ( () => {
            change_max (10, "d10");
        });

        twelve_sided.clicked.connect ( () => {
            change_max (12, "d12");
        });

        twenty_sided.clicked.connect ( () => {
            change_max (20, "d20");
        });

        hundred_sided.clicked.connect ( () => {
            change_max (100, "d100");
        });

        custom_sided.toggled.connect ( () => {
            change_max (max_entry.get_value_as_int ());
        });

        max_entry.value_changed.connect ( () => {
            change_max (max_entry.get_value_as_int ());
        });

        close_menu.connect ( () => {
            popdown ();
        });
    }

    private void load_max () {
        var custom_roll = Application.settings.get_int ("custom-roll");
        var selection = Application.settings.get_string ("last-selected");

        switch (selection) {
            case "d4":
                six_sided.dice_radio.active = true;
                max_roll = 4;
                break;
            case "d6":
                six_sided.dice_radio.active = true;
                max_roll = 6;
                break;
            case "d8":
                eight_sided.dice_radio.active = true;
                max_roll = 8;
                break;
            case "d10":
                ten_sided.dice_radio.active = true;
                max_roll = 10;
                break;
            case "d12":
                twelve_sided.dice_radio.active = true;
                max_roll = 12;
                break;
            case "d20":
                twenty_sided.dice_radio.active = true;
                max_roll = 20;
                break;
            case "d100":
                hundred_sided.dice_radio.active = true;
                max_roll = 100;
                break;
            default:
                custom_sided.active = true;
                max_roll = custom_roll;
                max_entry.sensitive = true;
                break;
        }
        max_entry.value = custom_roll;
    }

    private void change_max (int roll, string selection = "custom") {
        max_roll = roll;
        Application.settings.set_string ("last-selected", selection);
        if (selection != "custom") {
            max_entry.sensitive = false;
        } else if (selection == "custom") {
            Application.settings.set_int ("custom-roll", roll);
            max_entry.sensitive = true;
        }

        current_choice = _("d%i").printf (max_roll);
        label_changed (current_choice);

    }
}
