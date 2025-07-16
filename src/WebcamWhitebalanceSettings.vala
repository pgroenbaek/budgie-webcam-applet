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
    private GLib.Settings? settings = null;
    private GLib.Settings? wm_settings = null;

    /*[GtkChild]
    private unowned Gtk.Switch? notify_switch;

    [GtkChild]
    private unowned Gtk.Switch? brightness_switch;

    [GtkChild]
    private unowned Gtk.SpinButton? brightness_level;*/

    public WebcamWhitebalanceSettings(GLib.Settings? settings) {
        Object();
        this.settings = settings;
        this.wm_settings = new Settings("com.solus-project.budgie-wm");

        //wm_settings.bind("caffeine-mode-notification", notify_switch, "active", SettingsBindFlags.DEFAULT);
        //wm_settings.bind("caffeine-mode-toggle-brightness", brightness_switch, "active", SettingsBindFlags.DEFAULT);
        //wm_settings.bind("caffeine-mode-screen-brightness", brightness_level, "value", SettingsBindFlags.DEFAULT);
    }
}