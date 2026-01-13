/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2020-2021 Patrick Csikos (https://zelikos.github.io)
 *                          2025 Stella & Charlie (teamcons.carrd.co)
 *                          2025 Contributions from the ellie_Commons community (github.com/elly-code/)
 */

public class Rollit.RollHistory : Gtk.Box {

    private GLib.List<PreviousRoll> previous_rolls_list;
    private Gtk.ScrolledWindow scroll_box;
    private Gtk.ListBox previous_rolls_box;
    private Gtk.Button clear_button;
    private Gtk.Stack stack;

    construct {
        orientation = Gtk.Orientation.VERTICAL;
        spacing = 0;
        vexpand = true;
        width_request = 50;

        add_css_class ("sep");

        previous_rolls_box = new Gtk.ListBox () {
            activate_on_single_click = true,
            visible = true
        };

        stack = new Gtk.Stack ();
        stack.transition_type = Gtk.StackTransitionType.CROSSFADE;
/*  
        var placeholder = new Granite.Placeholder (_("Nothing to show yet!")) {
            icon = new ThemedIcon ("folder-recent-symbolic"),
            description = "Roll a dice, it will appear here",
            hexpand = false
        };  */

        var placeholder = new Gtk.Label (_("Empty!")) {
            hexpand = false,
            halign = Gtk.Align.CENTER
        };
        placeholder.add_css_class (Granite.STYLE_CLASS_H2_LABEL);
        placeholder.sensitive = false;

        scroll_box = new Gtk.ScrolledWindow () {
            hscrollbar_policy = NEVER,
            propagate_natural_height = true,
            hexpand = true,
            vexpand = true
        };
        scroll_box.child = previous_rolls_box;

        var clear_button_label = new Gtk.Label (_("Clear"));
        var clear_button_box = new Gtk.Box (HORIZONTAL, 0);
        clear_button_box.append (new Gtk.Image.from_icon_name ("edit-clear-all-symbolic"));
        clear_button_box.append (clear_button_label);

        clear_button = new Gtk.Button () {
            child = clear_button_box,
            tooltip_markup = Granite.markup_accel_tooltip ({"<Ctrl>L", "L"}, _("Clear history")),
            sensitive = false
        };
        clear_button.add_css_class (Granite.STYLE_CLASS_FLAT);
        clear_button_label.mnemonic_widget = clear_button;

        var bottom_row = new Gtk.ActionBar ();
        bottom_row.pack_start (clear_button);
        bottom_row.add_css_class (Granite.STYLE_CLASS_FLAT);


        stack.add_named (scroll_box, "history");
        stack.add_named (placeholder, "placeholder");
        stack.visible_child_name = "placeholder";

        append (stack);
        append (bottom_row);

        clear_button.clicked.connect (clear_rolls);

        show ();
    }

    public void clear_rolls () {
        stack.visible_child_name = "placeholder";

        previous_rolls_box.remove_all ();
        foreach (PreviousRoll item in previous_rolls_list) {
            previous_rolls_list.remove (item);
            item.destroy ();
        }

        clear_button.sensitive = false;
    }

    public void add_roll (int roll, int maxroll) {
        var new_roll = new Rollit.PreviousRoll (roll, maxroll);
        stack.visible_child_name = "history";

        previous_rolls_list.append (new_roll);
        previous_rolls_box.prepend (new_roll);
        previous_rolls_box.show ();
        new_roll.swoop ();

        if (clear_button.sensitive == false) {
            clear_button.sensitive = true;
        }
    }
}
