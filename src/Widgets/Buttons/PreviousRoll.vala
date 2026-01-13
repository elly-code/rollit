/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2020-2021 Patrick Csikos (https://zelikos.github.io)
 *                          2025 Stella & Charlie (teamcons.carrd.co)
 *                          2025 Contributions from the ellie_Commons community (github.com/elly-code/)
 */

public class Rollit.PreviousRoll : Gtk.ListBoxRow {

    private Gtk.Image copy_icon;
    private uint timeout_id;

    public string dicetype_label { get; construct set; }
    public string roll_label { get; construct set; }

    public Gtk.Label roll_amount { get; set; }
    private Gtk.Label dicetype { get; set; }
    private Gtk.Revealer revealer;

    public signal void copied ();

    public PreviousRoll (int roll, int maxroll) {
        Object (
            roll_label: roll.to_string (),
            dicetype_label: maxroll.to_string ()
        );
    }

    construct {
        ///TRANSLATORS: %s is replace by a dice number. Ex: d100.
        dicetype = new Gtk.Label (_("d%s: ").printf (dicetype_label)) {
            sensitive = false
        };

        roll_amount = new Gtk.Label (roll_label);
        copy_icon = new Gtk.Image.from_icon_name ("edit-copy-symbolic") {
            sensitive = false
        };

        var button_layout = new Gtk.CenterBox () {
            halign = Gtk.Align.FILL,
            hexpand = true,
            start_widget = dicetype,
            center_widget = roll_amount,
            end_widget = copy_icon
        };

        var copied_label = new Gtk.Label (_("Copied")) {
            halign = Gtk.Align.CENTER,
            hexpand = true
        };

        var stack = new Gtk.Stack () {
            transition_duration = Granite.TRANSITION_DURATION_OPEN,
            transition_type = Gtk.StackTransitionType.CROSSFADE
        };

        stack.add_named (button_layout, "button-box");
        stack.add_named (copied_label, "copied");
        stack.visible_child_name = "button-box";

        var button = new Gtk.Button () {
            margin_top = margin_bottom = 6,
            margin_start = margin_end = 6,
            tooltip_text = _("Copy result to clipboard")
        };

        button.child = stack;

        revealer = new Gtk.Revealer () {
            child = button
        };
        revealer.reveal_child = false;
        revealer.transition_type = Gtk.RevealerTransitionType.SLIDE_DOWN;

        child = revealer;

        button.clicked.connect ( () => {
            uint duration = 1000;
            copy_to_clipboard (roll_label);

            stack.visible_child_name = "copied";
            timeout_id = GLib.Timeout.add (duration, () => {
                stack.visible_child_name = "button-box";
                timeout_id = 0;
                return false;
            });
        });

        activate.connect ( () => {
            button.clicked ();
        });
    }

    private void copy_to_clipboard (string roll) {
        var clipboard = Gdk.Display.get_default ().get_clipboard ();
        clipboard.set_text (roll);
        copied ();
    }

    public void swoop () {
        revealer.reveal_child = true;
    }
 }
