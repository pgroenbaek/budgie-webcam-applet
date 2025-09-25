/*
 * This file is part of the Budgie Desktop Webcam Applet.
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

using Budgie;
using Gtk;
using GLib;
using Posix;

[CCode(cheader_filename = "linux/videodev2.h", cname = "V4L2_CTRL_FLAG_DISABLED")]
public static extern uint V4L2_CTRL_FLAG_DISABLED;

[CCode(cheader_filename = "linux/videodev2.h", cname = "V4L2_CTRL_TYPE_MENU")]
public static extern uint V4L2_CTRL_TYPE_MENU;

[CCode(cheader_filename = "ioctl_wrapper.h", cname = "struct v4l2_queryctrl")]
public extern struct V4L2ControlInfo {
    public uint id;
    public uint type;
    public int minimum;
    public int maximum;
    public int step;
    public int default_value;
    public uint flags;
}

[CCode(cheader_filename = "ioctl_wrapper.h")]
public extern int ioctl_wrapper_get_control(int fd, uint control_id, out int out_value);

[CCode(cheader_filename = "ioctl_wrapper.h")]
public extern int ioctl_wrapper_set_control(int fd, uint control_id, int value);

[CCode (cheader_filename = "ioctl_wrapper.h")]
public extern int ioctl_wrapper_get_next_control(int fd, out V4L2ControlInfo out_info, uint last_id);

[CCode(cheader_filename = "ioctl_wrapper.h")]
public extern int ioctl_wrapper_queryctrl(int fd, out V4L2ControlInfo out_info, uint id);

[CCode (cheader_filename = "ioctl_wrapper.h", free_function = "free")]
public extern string? ioctl_wrapper_querymenu_name(int fd, uint control_id, uint index);


public class WebcamAppletWindow : Budgie.Popover {

    private uint default_temperature = 4500;
    private uint automode_refresh_interval_ms = 15 * 60 * 1000; // 15 minutes in milliseconds

    private Gtk.ComboBox? device_combobox = null;
    private Gtk.ListStore? device_store = null;
    private Gtk.Label? device_label = null;
    private Gtk.Switch? enabled_switch = null;
    private Gtk.Label? enabled_label = null;
    private Gtk.Switch? mode_switch = null;
    private Gtk.Label? mode_label = null;
    private Gtk.SpinButton? absolute_temperature_spinbutton = null;
    private Gtk.Label? absolute_temperature_label = null;
    private Gtk.SpinButton? relative_temperature_spinbutton = null;
    private Gtk.Label? relative_temperature_label = null;

    private string active_device = "";

    private ulong enabled_id;
    private ulong mode_id;
    private ulong absolute_temperature_id;
    private ulong relative_temperature_id;

    private uint last_autodetect_temperature = 4500;

    private unowned GLib.Settings? settings;

    public WebcamAppletWindow(Gtk.Widget? c_parent, GLib.Settings? c_settings) {
        Object(relative_to: c_parent);
        settings = c_settings;
        get_style_context().add_class("webcamapplet-popover");

        var container = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
        container.get_style_context().add_class("container");

        var top_box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
        top_box.set_hexpand(true);

        var css = new Gtk.CssProvider();
        css.load_from_data("label.bold-grey { font-weight: bold; color: #8d939e; }");

        Gtk.StyleContext.add_provider_for_screen(
            Gdk.Screen.get_default(),
            css,
            Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
        );

        var title_label = new Gtk.Label("Webcam Control");
        title_label.get_style_context().add_class("bold-grey");
        title_label.set_halign(Gtk.Align.START);
        title_label.set_hexpand(true);
        top_box.pack_start(title_label, true, true, 0);

        enabled_switch = new Gtk.Switch();
        enabled_switch.set_halign(Gtk.Align.END);
        top_box.set_margin_start(3);
        top_box.set_margin_end(3);
        top_box.pack_start(enabled_switch, false, false, 0);

        var sep = new Gtk.Separator(Orientation.HORIZONTAL);
        sep.set_margin_top(2);
        sep.set_margin_bottom(2);

        top_box.set_size_request(-1, 30);
        container.pack_start(top_box, true, true, 0);
        container.pack_start(sep, false, false, 0);

        Gtk.Grid grid = new Gtk.Grid();
        grid.set_row_spacing(6);
        grid.set_column_spacing(12);

        device_label = new Gtk.Label(_("Video Device"));
        device_label.set_halign(Gtk.Align.START);
        mode_label = new Gtk.Label(_("Auto White Balance"));
        mode_label.set_halign(Gtk.Align.START);
        absolute_temperature_label = new Gtk.Label(_("Temperature (K)"));
        absolute_temperature_label.set_halign(Gtk.Align.START);
        relative_temperature_label = new Gtk.Label(_("Temperature +/- (K)"));
        relative_temperature_label.set_halign(Gtk.Align.START);

        device_store = new Gtk.ListStore(2, typeof(string), typeof(string));
        device_combobox = new Gtk.ComboBox();
        device_combobox.set_model(device_store);
        var renderer = new Gtk.CellRendererText();
        device_combobox.pack_start(renderer, true);
        device_combobox.add_attribute(renderer, "text", 1);
        device_combobox.set_halign(Gtk.Align.END);
        mode_switch = new Gtk.Switch();
        mode_switch.set_halign(Gtk.Align.END);

        var absolute_adjustment = new Gtk.Adjustment(default_temperature, 1000, 10000, 100, 500, 0);
        absolute_temperature_spinbutton = new Gtk.SpinButton(absolute_adjustment, 0, 0);
        absolute_temperature_spinbutton.set_halign(Gtk.Align.END);
        var relative_adjustment = new Gtk.Adjustment(0, -2000, 2000, 100, 500, 0);
        relative_temperature_spinbutton = new Gtk.SpinButton(relative_adjustment, 0, 0);
        relative_temperature_spinbutton.set_halign(Gtk.Align.END);

        grid.attach(device_label, 0, 0);
        grid.attach(device_combobox, 1, 0);
        grid.attach(mode_label, 0, 2);
        grid.attach(mode_switch, 1, 2);
        grid.attach(absolute_temperature_label, 0, 3);
        grid.attach(absolute_temperature_spinbutton, 1, 3);
        grid.attach(relative_temperature_label, 0, 4);
        grid.attach(relative_temperature_spinbutton, 1, 4);

        container.pack_start(grid, true, true, 0);
        add(container);

        this.show.connect(() => {
            update_ux_state();
        });

        update_ux_state();
        set_default_device();

        settings.changed["applet-enabled"].connect(() => {
            update_ux_state();
        });

        settings.changed["whitebalance-auto"].connect(() => {
            update_ux_state();
        });

        device_combobox.changed.connect(() => {
            var device_store = (Gtk.ListStore) device_combobox.get_model();

            TreeIter iter;
            if (device_combobox.get_active_iter(out iter)) {
                GLib.Value val;
                device_store.get_value(iter, 0, out val);
                active_device = (string) val;
                print("Switched to device: %s\n", active_device);
            }
        });

        enabled_id = enabled_switch.notify["active"].connect(() => {
            SignalHandler.block(enabled_switch, enabled_id);
            settings.set_boolean("applet-enabled", enabled_switch.active);
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
        refresh_devices();

        enabled_switch.active = settings.get_boolean("applet-enabled");
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

    private string[] get_video_devices() {
        var devices = new string[0];
        try {
            var dir = GLib.Dir.open("/dev", 0);
            while (true) {
                string? entry = dir.read_name();
                if (entry == null)
                    break;
                if (entry.has_prefix("video")) {
                    devices += "/dev/" + entry;
                }
            }
        } catch (Error e) {
            GLib.stderr.printf("Error enumerating /dev: %s\n", e.message);
        }
        return devices;
    }
    
    public void refresh_devices() {
        var device_store = (Gtk.ListStore) device_combobox.get_model();

        enumerate_controls(active_device);

        string? current = active_device;

        device_store.clear();

        string[] devices = get_video_devices();

        foreach (string device in devices) {
            string display_name = device;
            try {
                string output;
                Process.spawn_command_line_sync("v4l2-ctl -d " + device + " --all",
                                            out output, null, null);
                var regex = new GLib.Regex("Driver name\\s*:\\s*(\\S+)", 0);
                MatchInfo? match_info = null;
                if (regex.match(output, 0, out match_info)) {
                    string driver = match_info.fetch(1);
                    display_name = "%s (%s)".printf(device, driver);
                }
            } catch (Error e) {
            }

            TreeIter iter;
            device_store.append(out iter);
            device_store.set(iter, 0, device, 1, display_name);
        }

        if (current != null) {
            set_active_device(current);
        } else {
            set_default_device();
        }
    }

    public void set_default_device() {
        var device_store = (Gtk.ListStore) device_combobox.get_model();
        TreeIter iter;

        if (device_store.get_iter_first(out iter)) {
            device_combobox.set_active_iter(iter);

            GLib.Value val;
            device_store.get_value(iter, 0, out val);
            active_device = (string) val;
        }
    }

    public void set_active_device(string device_path) {
        var device_store = (Gtk.ListStore) device_combobox.get_model();
        TreeIter iter;

        if (device_store.get_iter_first(out iter)) {
            do {
                GLib.Value val;
                device_store.get_value(iter, 0, out val);
                string value = (string) val;

                if (value == device_path) {
                    device_combobox.set_active_iter(iter);
                    active_device = value;
                    return;
                }
            } while (device_store.iter_next(ref iter));
        }

        set_default_device();
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
        /*if (!set_control(V4L2_CID_AUTO_WHITE_BALANCE, webcam_automatic ? 1 : 0)) {
            GLib.stderr.printf("Failed to set auto white balance\n");
        }*/
    }

    private void apply_temperature(uint new_temperature) {
        /*if (!set_control(V4L2_CID_WHITE_BALANCE_TEMPERATURE, (int)new_temperature)) {
            GLib.stderr.printf("Failed to set temperature\n");
        }*/
    }

    private uint get_current_temperature() {
        return (uint) 2800;//get_control(V4L2_CID_WHITE_BALANCE_TEMPERATURE);
    }

    private int open_device(string device) {
        return Posix.open(device, Posix.O_RDWR);
    }

    public void enumerate_controls(string device) {
        int fd = open_device(device);
        if (fd < 0) {
            GLib.stderr.printf("Could not open device %s\n", device);
            return;
        }

        uint last_id = 0;
        V4L2ControlInfo info;
        int value;

        while (ioctl_wrapper_get_next_control(fd, out info, last_id) == 0) {
            last_id = info.id;

            if (ioctl_wrapper_get_control(fd, info.id, out value) == 0) {
                GLib.stdout.printf(
                    "Control %u type=%u min=%d max=%d step=%d default=%d value=%d flags=%u\n",
                    info.id, info.type, info.minimum, info.maximum,
                    info.step, info.default_value, value, info.flags
                );

                if (info.type == V4L2_CTRL_TYPE_MENU) {
                    int index = 0;
                    while (true) {
                        string? item_name = ioctl_wrapper_querymenu_name(fd, info.id, index);
                        if (item_name == null) {
                            break;
                        }
                        GLib.stdout.printf("  %d: %s\n", index, item_name);
                        index++;
                    }
                }
            }
        }

        Posix.close (fd);
    }

    public bool set_control(string device, uint control_id, int value) {
        int fd = open_device(device);
        if (fd < 0) {
            return false;
        }

        int ret = ioctl_wrapper_set_control(fd, control_id, value);

        Posix.close(fd);

        return ret == 0;
    }

    public int get_control(string device, uint control_id) {
        int fd = open_device(device);
        if (fd < 0) {
            GLib.stderr.printf("Could not open device %s\n", device);
            return -1;
        }

        int value = -1;
        int ret = ioctl_wrapper_get_control(fd, control_id, out value);

        Posix.close(fd);

        if (ret != 0) {
            return -1;
        }
        return value;
    }
}
