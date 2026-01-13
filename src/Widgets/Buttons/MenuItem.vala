/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2020-2021 Patrick Csikos (https://zelikos.github.io)
 *                          2025 Stella & Charlie (teamcons.carrd.co)
 *                          2025 Contributions from the ellie_Commons community (github.com/elly-code/)
 */

public class Rollit.MenuItem : Gtk.Button {

    public Gtk.CheckButton dice_radio { get; private set; }
    public string dice_label { get; construct set; }
    public string dice_accel { get; construct set; }

    public MenuItem (string label, string accel) {
        Object (
            dice_label: label,
            dice_accel: accel
        );
    }

    construct {
        add_css_class (Granite.STYLE_CLASS_FLAT);

        dice_radio = new Gtk.CheckButton ();
        var accel_label = new Granite.AccelLabel (dice_label, dice_accel);

        ///TRANSLATORS: %s is here replaced with a number
        tooltip_text = _("Press %s to immediately select this dice").printf (dice_accel);

        var box = new Gtk.Box (HORIZONTAL, 6);
        box.append (dice_radio);
        box.append (accel_label);

        child = box;

        clicked.connect ( () => {
           dice_radio.active = true;
        });
    }
}
