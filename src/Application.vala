/*
 * Copyright (C) 2020-2021 Patrick Csikos (https://zelikos.github.io)
 * Copyright (c) 2025 Stella, Charlie, (teamcons on GitHub) and the Ellie_Commons community
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public
 * License as published by the Free Software Foundation; either
 * version 3 of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public
 * License along with this program; if not, write to the
 * Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
 * Boston, MA 02110-1301 USA
 */

public class Rollit.Application : Gtk.Application {

    public static GLib.Settings settings;
    public static Rollit.MainWindow window;

    public Application () {
        Object (
            application_id: "io.github.elly_code.rollit",
            flags: ApplicationFlags.DEFAULT_FLAGS
        );
    }

    static construct {
        settings = new GLib.Settings ("io.github.elly_code.rollit");
    }

    construct {
        Intl.setlocale (LocaleCategory.ALL, "");
        Intl.bindtextdomain (GETTEXT_PACKAGE, LOCALEDIR);
        Intl.bind_textdomain_codeset (GETTEXT_PACKAGE, "UTF-8");
        Intl.textdomain (GETTEXT_PACKAGE);
    }

    protected override void startup () {
        base.startup ();
        Granite.init ();

        var gtk_settings = Gtk.Settings.get_default ();
        var granite_settings = Granite.Settings.get_default ();

        gtk_settings.gtk_application_prefer_dark_theme = (
	            granite_settings.prefers_color_scheme == DARK
            );
	
        granite_settings.notify["prefers-color-scheme"].connect (() => {
            gtk_settings.gtk_application_prefer_dark_theme = (
                    granite_settings.prefers_color_scheme == DARK
                );
        });

        var quit_action = new SimpleAction ("quit", null);
        add_action (quit_action);
        set_accels_for_action ("app.quit", {"<Control>q"});
        quit_action.activate.connect (quit);

        var toggle_history = new SimpleAction ("toggle_history", null);
        add_action (toggle_history);
        set_accels_for_action ("app.toggle_history", { "<Control>h", "h" });
        toggle_history.activate.connect (() => {
            var if_hist_visible = Application.settings.get_boolean ("show-history");
            Application.settings.set_boolean ("show-history", (! if_hist_visible));
        });

        var roll_action = new SimpleAction ("roll", null);
        add_action (roll_action);
        set_accels_for_action ("app.roll", {"<Control>r", "r"});

        var clearhist_action = new SimpleAction ("clear_hist", null);
        add_action (clearhist_action);
        set_accels_for_action ("app.clear_hist", {"<Control>l", "l"});

        var menu_action = new SimpleAction ("menu", null);
        add_action (clearhist_action);
        set_accels_for_action ("app.menu", {"<Control>m", "m"});

        var foursided = new SimpleAction ("foursided", null);
        add_action (foursided);
        set_accels_for_action ("app.foursided", {"1"});

        var sixsided = new SimpleAction ("sixsided", null);
        add_action (sixsided);
        set_accels_for_action ("app.sixsided", {"2"});

        var eightsided = new SimpleAction ("eightsided", null);
        add_action (eightsided);
        set_accels_for_action ("app.eightsided", {"3"});

        var tensided = new SimpleAction ("tensided", null);
        add_action (tensided);
        set_accels_for_action ("app.tensided", {"4"});

        var twelvesided = new SimpleAction ("twelvesided", null);
        add_action (twelvesided);
        set_accels_for_action ("app.twelvesided", {"5"});

        var twentysided = new SimpleAction ("twentysided", null);
        add_action (twentysided);
        set_accels_for_action ("app.twentysided", {"6"});

        var hundredsided = new SimpleAction ("hundredsided", null);
        add_action (hundredsided);
        set_accels_for_action ("app.hundredsided", {"7"});

        var customsided = new SimpleAction ("customsided", null);
        add_action (customsided);
        set_accels_for_action ("app.customsided", {"0"});
    }

    protected override void activate () {

        var provider = new Gtk.CssProvider ();
        provider.load_from_resource ("/io/github/elly_code/rollit/Application.css");
        Gtk.StyleContext.add_provider_for_display (
            Gdk.Display.get_default (),
            provider,
            Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
        );

        if (window == null) {
            window = new Rollit.MainWindow (this);
            add_window (window);
            window.show ();

        } else {
            window.present ();
        }
    }

    public static int main (string[] args) {
        return new Application ().run (args);
    }
}
