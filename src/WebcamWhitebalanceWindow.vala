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

    private Gtk.Switch? mode = null;
    private Gtk.SpinButton? timer = null;
    private ulong mode_id;
    private ulong timer_id;

    private unowned Settings? settings;

    public WebcamWhitebalanceWindow(Gtk.Widget? c_parent, Settings? c_settings) {
        Object(relative_to: c_parent);
        settings = c_settings;
        get_style_context().add_class("caffeine-popover");

        var container = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
        container.get_style_context().add_class("container");

        Gtk.Grid grid = new Gtk.Grid();
        grid.set_row_spacing(6);
        grid.set_column_spacing(12);

        Gtk.Label caffeine_mode_label = new Gtk.Label(_("Auto White Balance"));
        caffeine_mode_label.set_halign(Gtk.Align.START);
        Gtk.Label timer_label = new Gtk.Label(_("Temperature (K)"));
        timer_label.set_halign(Gtk.Align.START);

        mode = new Gtk.Switch();
        mode.set_halign(Gtk.Align.END);
        var absolute_adjustment = new Gtk.Adjustment(6500, 2800, 10000, 100, 500, 0);
        var relative_adjustment = new Gtk.Adjustment(0, -2000, 2000, 100, 500, 0);
        timer = new Gtk.SpinButton(relative_adjustment, 0, 0);
        timer.set_halign(Gtk.Align.END);

        grid.attach(caffeine_mode_label, 0, 0);
        grid.attach(timer_label, 0, 1);
        grid.attach(mode, 1, 0);
        grid.attach(timer, 1, 1);

        container.add(grid);
        add(container);

        update_ux_state();

        settings.changed["caffeine-mode"].connect(() => {
            update_ux_state();
        });

        settings.changed["caffeine-mode-timer"].connect(() => {
            SignalHandler.block(timer, timer_id);
            update_ux_state();
            SignalHandler.unblock(timer, timer_id);
        });

        mode_id = mode.notify["active"].connect(() => {
            SignalHandler.block(mode, mode_id);
            timer.sensitive = !mode.active;
            settings.set_boolean("caffeine-mode", mode.active);
            SignalHandler.unblock(mode, mode_id);
        });

        timer_id = timer.value_changed.connect(update_timer_value);
    }

    public void update_ux_state() {
        mode.active = settings.get_boolean("caffeine-mode");
        timer.sensitive = !mode.active;
        timer.value = settings.get_int("caffeine-mode-timer");
    }

    public void toggle_applet() {
        mode.active = !mode.active;
    }

    public void update_timer_value() {
        var time = timer.get_value_as_int();
        settings.set_int("caffeine-mode-timer", time);
    }

    /*private void toggle_auto_adjust() {
        if (auto_adjust.get_active()) {
            Process.spawn_command_line_async("v4l2-ctl --set-ctrl=white_balance_automatic=1");
            temp_slider.set_sensitive(false);
        } else {
            Process.spawn_command_line_async("v4l2-ctl --set-ctrl=white_balance_automatic=0");
            temp_slider.set_sensitive(true);
        }
    }

    private void apply_temperature() {
        if (!auto_adjust.get_active()) {
            int temp_value = (int) temp_slider.get_value();
            string command = "v4l2-ctl --set-ctrl=white_balance_temperature=" + temp_value.to_string();
            try {
                Process.spawn_command_line_async(command);
            } catch (Error e) {
                stderr.printf("Error setting webcam temperature: %s\n", e.message);
            }
        } else {
            int current_temp = get_current_temperature();
            int adjusted_temp = current_temp + (int) temp_slider.get_value();
            string command = "v4l2-ctl --set-ctrl=white_balance_temperature=" + adjusted_temp.to_string();
            try {
                Process.spawn_command_line_async(command);
            } catch (Error e) {
                stderr.printf("Error adjusting webcam temperature: %s\n", e.message);
            }
        }
    }

    private int get_current_temperature() {
        try {
            string output;
            Process.spawn_command_line_sync("v4l2-ctl --get-ctrl=white_balance_temperature", out output, null, null);
            
            var regex = new GLib.Regex("white_balance_temperature: (\\d+)", 0);

            MatchInfo match_info = null;
            var match = regex.match_all(output, 0, out match_info);

            if (match) {
                return int.parse(match_info.fetch(0));
            } else {
                return 4500;
            }
        } catch (Error e) {
            stderr.printf("Error getting webcam temperature: %s\n", e.message);
            return 4500;
        }
    }*/
}