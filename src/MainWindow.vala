/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2020-2021 Patrick Csikos (https://zelikos.github.io)
 *                          2025 Stella & Charlie (teamcons.carrd.co)
 *                          2025 Contributions from the ellie_Commons community (github.com/elly-code/)
 */

public class Rollit.MainWindow : Gtk.Window {

    private Rollit.Menu menu_menu;
    private Gtk.MenuButton menu_button;
    private Rollit.NumDisplay number_display;
    private Rollit.RollHistory roll_history;
    private Gtk.HeaderBar header;
    private Gtk.Button roll_button;
    private Gtk.ToggleButton history_button;
    private Gtk.Box action_buttons;
    private Gtk.Box main_view;
    private Gtk.CenterBox hp;

    public SimpleActionGroup actions { get; construct; }

    public const string ACTION_PREFIX = "app.";
    public const string ACTION_ROLL = "roll";
    public const string ACTION_CLEAR_HISTORY = "clear_hist";
    public const string ACTION_MENU = "menu";

    public const string ACTION_FOURSIDED = "foursided";
    public const string ACTION_SIXSIDED = "sixsided";
    public const string ACTION_EIGHTSIDED = "eightsided";
    public const string ACTION_TENSIDED = "tensided";
    public const string ACTION_TWELVESIDED = "twelvesided";
    public const string ACTION_TWENTYSIDED = "twentysided";
    public const string ACTION_HUNDREDSIDED = "hundredsided";
    public const string ACTION_CUSTOMSIDED = "customsided";


    public static Gee.MultiMap<string, string> action_accelerators = new Gee.HashMultiMap<string, string> ();

    private const GLib.ActionEntry[] ACTION_ENTRIES = {
        { ACTION_ROLL, on_roll },
        { ACTION_CLEAR_HISTORY, on_clear_history},
        { ACTION_MENU, on_menu},
        { ACTION_FOURSIDED, select_d4},
        { ACTION_SIXSIDED, select_d6},
        { ACTION_EIGHTSIDED, select_d8},
        { ACTION_TENSIDED, select_d10},
        { ACTION_TWELVESIDED, select_d12},
        { ACTION_TWENTYSIDED, select_d20},
        { ACTION_HUNDREDSIDED, select_d100},
        { ACTION_CUSTOMSIDED, select_custom}
    };

    public MainWindow (Rollit.Application app) {
        Object (
            application: app,
            title: _("Roll-It")
        );
    }

    construct {
        Intl.setlocale ();

        var actions = new SimpleActionGroup ();
        actions.add_action_entries (ACTION_ENTRIES, this);
        insert_action_group ("app", actions);

        restore_state ();

        header = new Gtk.HeaderBar ();

        var label = new Gtk.Label ( _("Roll-It"));
        label.add_css_class (Granite.STYLE_CLASS_TITLE_LABEL);

        header.title_widget = label;
        header.add_css_class (Granite.STYLE_CLASS_FLAT);

        var icon = new Gtk.Image.from_icon_name ("document-open-recent");

        history_button = new Gtk.ToggleButton () {
            child = icon,
            tooltip_markup = Granite.markup_accel_tooltip ({"<Ctrl>H", "H"}, _("Roll history"))
        };
        history_button.add_css_class (Granite.STYLE_CLASS_FLAT);
        header.pack_end (history_button);

        titlebar = header;

        number_display = new Rollit.NumDisplay ();

        roll_button = new Gtk.Button.with_label (_("Roll")) {
            width_request = 96,
            tooltip_markup = Granite.markup_accel_tooltip ({"<Ctrl>R", "R"}, _("Roll"))
        };
        roll_button.add_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);

        menu_menu = new Rollit.Menu ();
        menu_button = new Gtk.MenuButton () {
            popover = menu_menu,
            label = menu_menu.current_choice,
            tooltip_markup = Granite.markup_accel_tooltip ({"<Ctrl>M", "M"}, _("Change dice")),
            width_request = 96
        };
        menu_button.set_primary (true);
        menu_button.set_direction (Gtk.ArrowType.NONE);

        menu_menu.label_changed.connect (( new_label) => {
            menu_button.label = new_label;
        });

        action_buttons = new Gtk.Box (Gtk.Orientation.HORIZONTAL,6) {
            halign = Gtk.Align.CENTER,
            valign = Gtk.Align.END
        };

        action_buttons.append (roll_button);
        action_buttons.append (menu_button);

        main_view = new Gtk.Box (Gtk.Orientation.VERTICAL, 12) {
            margin_top = 12,
            margin_bottom = 12,
            margin_start = 12,
            margin_end = 12,
        };
        main_view.append (number_display);
        main_view.append (action_buttons);

        roll_history = new Rollit.RollHistory ();

        hp = new Gtk.CenterBox ();
        hp.start_widget = main_view;

        var revealhist = new Gtk.Revealer () {
            child = roll_history
        };
        revealhist.transition_type = Gtk.RevealerTransitionType.SLIDE_LEFT;
        revealhist.halign = Gtk.Align.END;
        revealhist.hexpand = false;

        hp.end_widget = revealhist;


        var handle = new Gtk.WindowHandle () {
            child = hp
        };

        child = handle;

        roll_button.clicked.connect (on_roll);

        Application.settings.bind (
            "show-history",
            history_button, "active",
            SettingsBindFlags.DEFAULT
        );

        Application.settings.bind (
            "show-history",
            revealhist, "reveal_child",
            SettingsBindFlags.DEFAULT
        );


    }

    private void restore_state () {
        var rect = Gdk.Rectangle ();
        Application.settings.get ("window-size", "(ii)", out rect.width, out rect.height);

        default_width = rect.width;
        default_height = rect.height;
    }

    private void on_roll () {
        roll_history.add_roll (
            number_display.num_gen (menu_menu.max_roll),
            menu_menu.max_roll
        );
    }

    private void on_clear_history () {
        roll_history.clear_rolls ();
    }

    private void on_menu () {
        if (menu_menu.is_focus ()) {
            menu_menu.popdown ();
        } else {
            menu_menu.popup ();
        }
    }

    private void select_d4 () { menu_menu.four_sided.clicked (); }
    private void select_d6 () { menu_menu.six_sided.clicked (); }
    private void select_d8 () { menu_menu.eight_sided.clicked (); }
    private void select_d10 () { menu_menu.ten_sided.clicked (); }
    private void select_d12 () { menu_menu.twelve_sided.clicked (); }
    private void select_d20 () { menu_menu.twenty_sided.clicked (); }
    private void select_d100 () { menu_menu.hundred_sided.clicked (); }
    private void select_custom () { menu_menu.custom_sided.activate (); }
}
