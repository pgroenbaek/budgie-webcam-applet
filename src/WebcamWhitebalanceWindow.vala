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

public class WebcamWhitebalanceWindow : Budgie.Popover {

    private uint default_temperature = 4500;
    private uint automode_refresh_interval_ms = 15 * 60 * 1000; // 15 minutes in milliseconds

    private Gtk.Switch? enabled_switch = null;
    private Gtk.Switch? mode_switch = null;
    private Gtk.Label? mode_label = null;
    private Gtk.SpinButton? absolute_temperature_spinbutton = null;
    private Gtk.Label? absolute_temperature_label = null;
    private Gtk.SpinButton? relative_temperature_spinbutton = null;
    private Gtk.Label? relative_temperature_label = null;
    private ulong enabled_id;
    private ulong mode_id;
    private ulong absolute_temperature_id;
    private ulong relative_temperature_id;

    private uint last_autodetect_temperature = 4500;

    private unowned Settings? settings;

    public WebcamWhitebalanceWindow(Gtk.Widget? c_parent, Settings? c_settings) {
        Object(relative_to: c_parent);
        settings = c_settings;
        get_style_context().add_class("webcamwhitebalance-popover");

        var container = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
        container.get_style_context().add_class("container");

        Gtk.Grid grid = new Gtk.Grid();
        grid.set_row_spacing(6);
        grid.set_column_spacing(12);

        Gtk.Label enabled_label = new Gtk.Label(_("Enable Control"));
        enabled_label.set_halign(Gtk.Align.START);
        mode_label = new Gtk.Label(_("Auto White Balance"));
        mode_label.set_halign(Gtk.Align.START);
        absolute_temperature_label = new Gtk.Label(_("Temperature (K)"));
        absolute_temperature_label.set_halign(Gtk.Align.START);
        relative_temperature_label = new Gtk.Label(_("Temperature +/- (K)"));
        relative_temperature_label.set_halign(Gtk.Align.START);

        enabled_switch = new Gtk.Switch();
        enabled_switch.set_halign(Gtk.Align.END);
        mode_switch = new Gtk.Switch();
        mode_switch.set_halign(Gtk.Align.END);
        var absolute_adjustment = new Gtk.Adjustment(default_temperature, 1000, 10000, 100, 500, 0);
        absolute_temperature_spinbutton = new Gtk.SpinButton(absolute_adjustment, 0, 0);
        absolute_temperature_spinbutton.set_halign(Gtk.Align.END);
        var relative_adjustment = new Gtk.Adjustment(0, -2000, 2000, 100, 500, 0);
        relative_temperature_spinbutton = new Gtk.SpinButton(relative_adjustment, 0, 0);
        relative_temperature_spinbutton.set_halign(Gtk.Align.END);

        grid.attach(enabled_label, 0, 0);
        grid.attach(enabled_switch, 1, 0);
        grid.attach(mode_label, 0, 1);
        grid.attach(mode_switch, 1, 1);
        grid.attach(absolute_temperature_label, 0, 2);
        grid.attach(absolute_temperature_spinbutton, 1, 2);
        grid.attach(relative_temperature_label, 0, 3);
        grid.attach(relative_temperature_spinbutton, 1, 3);

        container.add(grid);
        add(container);

        this.show.connect(() => {
            update_ux_state();
        });

        update_ux_state();

        settings.changed["whitebalance-enabled"].connect(() => {
            update_ux_state();
        });

        settings.changed["whitebalance-auto"].connect(() => {
            update_ux_state();
        });

        enabled_id = enabled_switch.notify["active"].connect(() => {
            SignalHandler.block(enabled_switch, enabled_id);
            settings.set_boolean("whitebalance-enabled", enabled_switch.active);
            update_ux_state();
            SignalHandler.unblock(enabled_switch, enabled_id);
        });

        mode_id = mode_switch.notify["active"].connect(() => {
            SignalHandler.block(mode_switch, mode_id);
            settings.set_boolean("whitebalance-auto", mode_switch.active);
            update_ux_state();
            SignalHandler.unblock(mode_switch, mode_id);
        });

        settings.changed["whitebalance-temperature"].connect(() => {
            SignalHandler.block(absolute_temperature_spinbutton, absolute_temperature_id);
            update_ux_state();
            SignalHandler.unblock(absolute_temperature_spinbutton, absolute_temperature_id);
        });

        settings.changed["whitebalance-relative"].connect(() => {
            SignalHandler.block(relative_temperature_spinbutton, relative_temperature_id);
            update_ux_state();
            SignalHandler.unblock(relative_temperature_spinbutton, relative_temperature_id);
        });

        absolute_temperature_id = absolute_temperature_spinbutton.value_changed.connect(update_absolute_temperature_value);
        relative_temperature_id = relative_temperature_spinbutton.value_changed.connect(update_relative_temperature_value);

        GLib.Timeout.add(automode_refresh_interval_ms, () => {
            update_automode_temperature();
            return true;
        });

        update_automode_temperature();
    }

    public void update_ux_state() {
        enabled_switch.active = settings.get_boolean("whitebalance-enabled");
        mode_switch.active = settings.get_boolean("whitebalance-auto");
        absolute_temperature_spinbutton.value = settings.get_int("whitebalance-temperature");
        relative_temperature_spinbutton.value = settings.get_int("whitebalance-relative");

        bool enabled = enabled_switch.active;
        bool auto_mode = mode_switch.active;

        if (!enabled) {
            mode_switch.set_sensitive(false);
            mode_label.set_sensitive(false);
            absolute_temperature_spinbutton.set_sensitive(false);
            absolute_temperature_label.set_sensitive(false);
            relative_temperature_spinbutton.set_sensitive(false);
            relative_temperature_label.set_sensitive(false);
            toggle_webcam_automatic(true);
        } else {
            mode_switch.set_sensitive(true);
            mode_label.set_sensitive(true);
            absolute_temperature_spinbutton.set_sensitive(true);
            absolute_temperature_label.set_sensitive(true);
            relative_temperature_spinbutton.set_sensitive(true);
            relative_temperature_label.set_sensitive(true);
            toggle_webcam_automatic(false);
        }

        if (auto_mode) {
            absolute_temperature_spinbutton.set_visible(false);
            absolute_temperature_label.set_visible(false);
            relative_temperature_spinbutton.set_visible(true);
            relative_temperature_label.set_visible(true);
        } else {
            absolute_temperature_spinbutton.set_visible(true);
            absolute_temperature_label.set_visible(true);
            relative_temperature_spinbutton.set_visible(false);
            relative_temperature_label.set_visible(false);
        }
    }

    public void update_absolute_temperature_value() {
        var absolute_temperature = absolute_temperature_spinbutton.get_value_as_int();
        settings.set_int("whitebalance-temperature", absolute_temperature);

        bool enabled = enabled_switch.active;

        if (enabled) {
            apply_temperature(absolute_temperature);
        }
    }

    public void update_relative_temperature_value() {
        var relative_temperature = relative_temperature_spinbutton.get_value_as_int();
        settings.set_int("whitebalance-relative", relative_temperature);

        bool enabled = enabled_switch.active;
        bool auto_mode = mode_switch.active;

        if (enabled && auto_mode) {
            apply_temperature(last_autodetect_temperature + relative_temperature);
        }
    }

    private void update_automode_temperature() {
        bool enabled = enabled_switch.active;
        bool auto_mode = mode_switch.active;

        if (enabled && auto_mode) {
            toggle_webcam_automatic(true);
            GLib.Timeout.add(600, () => {
                last_autodetect_temperature = get_current_temperature();
                toggle_webcam_automatic(false);
                return false;
            });
        }
    }

    private void toggle_webcam_automatic(bool webcam_automatic) {
        string command = "v4l2-ctl --set-ctrl=white_balance_temperature=" + (webcam_automatic ? "1" : "0");
        try {
            Process.spawn_command_line_async(command);
        } catch (Error e) {
            stderr.printf("Error setting webcam mode: %s\n", e.message);
        }
    }

    private void apply_temperature(uint new_temperature) {
        string command = "v4l2-ctl --set-ctrl=white_balance_temperature=" + new_temperature.to_string();
        try {
            Process.spawn_command_line_async(command);
        } catch (Error e) {
            stderr.printf("Error setting webcam temperature: %s\n", e.message);
        }
    }

    private uint get_current_temperature() {
        try {
            string output;
            Process.spawn_command_line_sync("v4l2-ctl --get-ctrl=white_balance_temperature", out output, null, null);
            
            var regex = new GLib.Regex("white_balance_temperature: (\\d+)", 0);

            MatchInfo match_info = null;
            var match = regex.match(output.strip(), 0, out match_info);

            if (match) {
                return uint.parse(match_info.fetch(1));
            } else {
                return default_temperature;
            }
        } catch (Error e) {
            stderr.printf("Error getting webcam temperature: %s\n", e.message);
            return default_temperature;
        }
    }
}
