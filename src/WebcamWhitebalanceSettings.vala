/*
 * This file is part of the Budgie Desktop Webcam Whitebalance Applet.
 *
 * Copyright (C) 2025 Peter Grønbæk Andersen <peter@grnbk.io>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <https://www.gnu.org/licenses/>.
 */

public class WebcamWhitebalanceSettings : Gtk.Grid {
    private GLib.Settings settings;

    public WebcamWhitebalanceSettings(GLib.Settings settings) {
        Object();

        this.settings = settings;

        var mode_switch = new Gtk.Switch();
        this.attach(new Gtk.Label("Auto White Balance"), 0, 0, 1, 1);
        this.attach(mode_switch, 1, 0, 1, 1);

        settings.bind("whitebalance-auto", mode_switch, "active", SettingsBindFlags.DEFAULT);
    }
}
