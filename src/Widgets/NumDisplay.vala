/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2020-2021 Patrick Csikos (https://zelikos.github.io)
 *                          2025 Stella & Charlie (teamcons.carrd.co)
 *                          2025 Contributions from the ellie_Commons community (github.com/elly-code/)
 */

public class Rollit.NumDisplay : Gtk.Box {

    private Gtk.Label roll_result;
    private Gtk.Stack stack;

    construct {
        orientation = Gtk.Orientation.VERTICAL;
        spacing = 0;
        hexpand = true;
        halign = Gtk.Align.FILL;
        vexpand = true;
        valign = Gtk.Align.FILL;

        stack = new Gtk.Stack () {
            transition_type = Gtk.StackTransitionType.SLIDE_UP,
            transition_duration = 200,
        };

        roll_result = new Gtk.Label (null);
        roll_result.add_css_class ("result-label");

        var welcome = new Gtk.Label (_("Ready to Roll"));
        welcome.add_css_class (Granite.STYLE_CLASS_H2_LABEL);

        var blank = new Gtk.Label (null);

        stack.add_named (welcome, "welcome");
        stack.add_named (roll_result, "roll-result");
        stack.add_named (blank, "blank");
        stack.visible_child_name = "welcome";

        stack.halign = Gtk.Align.FILL;
        stack.valign = Gtk.Align.FILL;
        stack.vexpand = true;

        append (stack);
    }

    public int num_gen (int max_num) {
        const int MIN_NUM = 1;
        int rnd_num;

        stack.visible_child_name = "blank";

        // max_num + 1 so that max num is included in roll
        rnd_num = Random.int_range (MIN_NUM, (max_num + 1));
        roll_result.label = rnd_num.to_string ();

        stack.visible_child_name = "roll-result";

        return rnd_num;
    }
}
