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

[CCode(cheader_filename = "linux/videodev2.h", cname = "V4L2_CTRL_FLAG_DISABLED")]
public static extern uint V4L2_CTRL_FLAG_READ_ONLY;

[CCode(cheader_filename = "linux/videodev2.h", cname = "V4L2_CTRL_TYPE_BOOLEAN")]
public static extern uint V4L2_CTRL_TYPE_BOOLEAN;

[CCode(cheader_filename = "linux/videodev2.h", cname = "V4L2_CTRL_TYPE_INTEGER")]
public static extern uint V4L2_CTRL_TYPE_INTEGER;

[CCode(cheader_filename = "linux/videodev2.h", cname = "V4L2_CTRL_TYPE_MENU")]
public static extern uint V4L2_CTRL_TYPE_MENU;

[CCode(cheader_filename = "linux/videodev2.h", cname = "V4L2_CTRL_TYPE_BUTTON")]
public static extern uint V4L2_CTRL_TYPE_BUTTON;

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

[CCode(cheader_filename = "ioctl_wrapper.h", free_function = "free")]
public extern string? ioctl_wrapper_queryctrl_name(int fd, uint control_id);

[CCode (cheader_filename = "ioctl_wrapper.h", free_function = "free")]
public extern string? ioctl_wrapper_querymenu_name(int fd, uint control_id, uint index);

[CCode(cheader_filename = "ioctl_wrapper.h", free_function = "free")]
public extern string? ioctl_wrapper_querycap_card(int fd);

public const uint V4L2_CID_BASE = 0x00980900;
public const uint V4L2_CID_CAMERA_CLASS_BASE = 0x009A0900;

public const uint V4L2_CID_BRIGHTNESS = V4L2_CID_BASE + 0;
public const uint V4L2_CID_CONTRAST = V4L2_CID_BASE + 1;
public const uint V4L2_CID_SATURATION = V4L2_CID_BASE + 2;
public const uint V4L2_CID_HUE = V4L2_CID_BASE + 3;
public const uint V4L2_CID_AUTO_WHITE_BALANCE = V4L2_CID_BASE + 12;
public const uint V4L2_CID_DO_WHITE_BALANCE = V4L2_CID_BASE + 13;
public const uint V4L2_CID_RED_BALANCE = V4L2_CID_BASE + 14;
public const uint V4L2_CID_BLUE_BALANCE = V4L2_CID_BASE + 15;
public const uint V4L2_CID_GAMMA = V4L2_CID_BASE + 16;
public const uint V4L2_CID_EXPOSURE = V4L2_CID_BASE + 17;
public const uint V4L2_CID_AUTOGAIN = V4L2_CID_BASE + 18;
public const uint V4L2_CID_GAIN = V4L2_CID_BASE + 19;
public const uint V4L2_CID_HFLIP = V4L2_CID_BASE + 20;
public const uint V4L2_CID_VFLIP = V4L2_CID_BASE + 21;
public const uint V4L2_CID_POWER_LINE_FREQUENCY = V4L2_CID_BASE + 24;
public const uint V4L2_CID_HUE_AUTO = V4L2_CID_BASE + 25;
public const uint V4L2_CID_WHITE_BALANCE_TEMPERATURE = V4L2_CID_BASE + 26;
public const uint V4L2_CID_SHARPNESS = V4L2_CID_BASE + 27;
public const uint V4L2_CID_BACKLIGHT_COMPENSATION = V4L2_CID_BASE + 28;
public const uint V4L2_CID_COLORFX = V4L2_CID_BASE + 31;

public const uint V4L2_CID_EXPOSURE_AUTO = V4L2_CID_CAMERA_CLASS_BASE + 1;
public const uint V4L2_CID_EXPOSURE_ABSOLUTE = V4L2_CID_CAMERA_CLASS_BASE + 2;
public const uint V4L2_CID_EXPOSURE_AUTO_PRIORITY = V4L2_CID_CAMERA_CLASS_BASE + 3;
public const uint V4L2_CID_FOCUS_ABSOLUTE = V4L2_CID_CAMERA_CLASS_BASE + 10;
public const uint V4L2_CID_FOCUS_AUTO = V4L2_CID_CAMERA_CLASS_BASE + 12;
public const uint V4L2_CID_ZOOM_ABSOLUTE = V4L2_CID_CAMERA_CLASS_BASE + 13;
public const uint V4L2_CID_PRIVACY = V4L2_CID_CAMERA_CLASS_BASE + 16;

public const uint[] CONTROLLABLE_CIDS = {
    V4L2_CID_BRIGHTNESS,
    V4L2_CID_CONTRAST,
    V4L2_CID_SATURATION,
    V4L2_CID_HUE,
    V4L2_CID_SHARPNESS,
    V4L2_CID_GAIN,
    V4L2_CID_EXPOSURE_ABSOLUTE,
    //V4L2_CID_EXPOSURE_AUTO,
    //V4L2_CID_AUTO_WHITE_BALANCE,
    V4L2_CID_WHITE_BALANCE_TEMPERATURE,
    V4L2_CID_BACKLIGHT_COMPENSATION,
    V4L2_CID_HFLIP,
    V4L2_CID_VFLIP,
    V4L2_CID_FOCUS_ABSOLUTE,
    //V4L2_CID_FOCUS_AUTO,
    V4L2_CID_ZOOM_ABSOLUTE,
    //V4L2_CID_POWER_LINE_FREQUENCY,
    //V4L2_CID_PRIVACY
};


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

    private string active_device = "/dev/video1";

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

        var top_seperator = new Gtk.Separator(Orientation.HORIZONTAL);
        top_seperator.set_margin_top(2);
        top_seperator.set_margin_bottom(2);

        top_box.set_size_request(-1, 30);
        container.pack_start(top_box, true, true, 0);
        container.pack_start(top_seperator, false, false, 0);

        Gtk.Grid top_grid = new Gtk.Grid();
        top_grid.set_row_spacing(6);
        top_grid.set_column_spacing(12);

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

        top_grid.attach(device_label, 0, 0);
        top_grid.attach(device_combobox, 1, 0);
        top_grid.attach(mode_label, 0, 2);
        top_grid.attach(mode_switch, 1, 2);
        //top_grid.attach(absolute_temperature_label, 0, 3);
        //top_grid.attach(absolute_temperature_spinbutton, 1, 3);
        //top_grid.attach(relative_temperature_label, 0, 4);
        //top_grid.attach(relative_temperature_spinbutton, 1, 4);

        var controls_seperator = new Gtk.Separator(Orientation.HORIZONTAL);
        controls_seperator.set_margin_top(2);
        controls_seperator.set_margin_bottom(2);

        Gtk.Grid controls_grid = new Gtk.Grid();
        controls_grid.set_row_spacing(6);
        controls_grid.set_column_spacing(12);

        set_default_device();
        build_controls_grid(active_device, controls_grid);

        container.pack_start(top_grid, true, true, 0);
        container.pack_start(controls_seperator, false, false, 0);
        container.pack_start(controls_grid, true, true, 0);
        add(container);

        this.show.connect(() => {
            update_ux_state();
        });

        update_ux_state();

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

        string? current = active_device;

        device_store.clear();

        string[] devices = get_video_devices();

        foreach (string device in devices) {
            int fd = open_device(device);

            string? name = ioctl_wrapper_querycap_card(fd);

            string display_name;
            if (name != null) {
                display_name = "%s (%s)".printf(device, name);
            } else {
                display_name = "%s".printf(device);
            }

            Posix.close(fd);

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

    private void build_controls_grid(string device, Gtk.Grid grid) {
        int fd = open_device(device);
        if (fd < 0) {
            GLib.stderr.printf("Could not open device %s\n", device);
            return;
        }

        uint last_id = 0;
        V4L2ControlInfo info;
        int value;
        int row = 0;

        while (ioctl_wrapper_get_next_control(fd, out info, last_id) == 0) {
            last_id = info.id;

            if (ioctl_wrapper_get_control(fd, info.id, out value) != 0) {
                continue;
            }

            if ((info.flags & V4L2_CTRL_FLAG_DISABLED) != 0) {
                continue;
            }

            if ((info.flags & V4L2_CTRL_FLAG_READ_ONLY) != 0) {
                continue;
            }

            bool controllable = false;
            foreach (uint cid in CONTROLLABLE_CIDS) {
                if (info.id == cid) {
                    controllable = true;
                    break;
                }
            }
            if (!controllable) {
                continue;
            }

            var name = ioctl_wrapper_queryctrl_name(fd, info.id);
            var label = new Gtk.Label(name ?? "Unnamed");
            label.halign = Gtk.Align.START;
            grid.attach(label, 0, row, 1, 1);

            Gtk.Widget control_widget;

            if (info.type == V4L2_CTRL_TYPE_BOOLEAN) {
                var sw = new Gtk.Switch();
                sw.active = value != 0;
                control_widget = sw;

                sw.notify["active"].connect(() => {
                    int new_value = sw.active ? 1 : 0;
                    set_control(device, info.id, new_value);
                });

            } else if (info.type == V4L2_CTRL_TYPE_INTEGER) {
                var adjustment = new Gtk.Adjustment(value, info.minimum, info.maximum, info.step, 0, 0);
                var spinner = new Gtk.SpinButton(adjustment, info.step, 0);
                control_widget = spinner;

                spinner.value_changed.connect(() => {
                    int new_value = (int) spinner.value;
                    set_control(device, info.id, new_value);
                });

            } else if (info.type == V4L2_CTRL_TYPE_MENU) {
                var combo = build_combo_box(fd, info.id, value);
                control_widget = combo;

                combo.changed.connect(() => {
                    int new_value = combo.get_active();
                    set_control(device, info.id, new_value);
                });

            } else if (info.type == V4L2_CTRL_TYPE_BUTTON) {
                var btn = new Gtk.Button.with_label("Press");
                control_widget = btn;

                btn.clicked.connect(() => {
                    set_control(device, info.id, 1);
                });

            } else {
                control_widget = new Gtk.Label("Unsupported");
            }

            control_widget.set_halign(Gtk.Align.END);
            grid.attach(control_widget, 1, row, 1, 1);

            row++;
        }

        Posix.close(fd);
    }

    private Gtk.ComboBoxText build_combo_box(int fd, uint control_id, int current_value) {
        var combo = new Gtk.ComboBoxText();
        int index = 0;

        while (true) {
            string? name = ioctl_wrapper_querymenu_name(fd, control_id, index);
            if (name == null) break;
            combo.append_text(name);
            index++;
        }

        combo.active = current_value;
        return combo;
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
