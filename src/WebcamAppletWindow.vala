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
public extern string? ioctl_wrapper_querycap_card(int fd);

[CCode(cheader_filename = "ioctl_wrapper.h", free_function = "free")]
public extern string? ioctl_wrapper_querycap_businfo(int fd);

[CCode(cheader_filename = "ioctl_wrapper.h", free_function = "free")]
public extern string? ioctl_wrapper_queryctrl_name(int fd, uint control_id);

[CCode (cheader_filename = "ioctl_wrapper.h", free_function = "free")]
public extern string? ioctl_wrapper_querymenu_name(int fd, uint control_id, uint index);

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

public const uint[] EXPOSURE_CIDS = {
    V4L2_CID_BRIGHTNESS,
    V4L2_CID_CONTRAST,
    V4L2_CID_GAIN,
    V4L2_CID_EXPOSURE_AUTO,
    V4L2_CID_EXPOSURE_ABSOLUTE,
    V4L2_CID_BACKLIGHT_COMPENSATION
};

public const uint[] COLORBALANCE_CIDS = {
    V4L2_CID_SATURATION,
    V4L2_CID_HUE,
    V4L2_CID_AUTO_WHITE_BALANCE,
    V4L2_CID_WHITE_BALANCE_TEMPERATURE
};

public const uint[] ZOOMFOCUS_CIDS = {
    V4L2_CID_SHARPNESS,
    V4L2_CID_FOCUS_AUTO,
    V4L2_CID_FOCUS_ABSOLUTE,
    V4L2_CID_ZOOM_ABSOLUTE
};

public const uint[] ORIENTATION_CIDS = {
    V4L2_CID_HFLIP,
    V4L2_CID_VFLIP
};

public const uint[] MISCSETTINGS_CIDS = {
    V4L2_CID_POWER_LINE_FREQUENCY,
    V4L2_CID_PRIVACY
};


public class WebcamAppletWindow : Budgie.Popover {

    private Gtk.Switch? enabled_switch = null;
    private Gtk.ComboBox? device_combobox = null;
    private Gtk.ListStore? device_store = null;
    private Gtk.Label? device_label = null;

    private Gtk.FlowBox? exposure_flowbox = null;
    private Gtk.Label? exposure_empty_label = null;
    private Gtk.FlowBox? colorbalance_flowbox = null;
    private Gtk.Label? colorbalance_empty_label = null;
    private Gtk.FlowBox? focuszoom_flowbox = null;
    private Gtk.Label? focuszoom_empty_label = null;
    private Gtk.FlowBox? orientation_flowbox = null;
    private Gtk.Label? orientation_empty_label = null;
    private Gtk.FlowBox? miscsettings_flowbox = null;
    private Gtk.Label? miscsettings_empty_label = null;

    private string active_device = "/dev/video1";

    private ulong enabled_id;

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
        enabled_switch.set_margin_start(6);
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

        var device_renderer = new Gtk.CellRendererText();
        device_store = new Gtk.ListStore(2, typeof(string), typeof(string));
        device_combobox = new Gtk.ComboBox();
        device_combobox.set_model(device_store);
        device_combobox.pack_start(device_renderer, true);
        device_combobox.add_attribute(device_renderer, "text", 1);
        device_combobox.set_halign(Gtk.Align.END);
        device_combobox.set_size_request(90, -1);

        top_grid.attach(device_label, 0, 0);
        top_grid.attach(device_combobox, 1, 0);

        var controls_seperator = new Gtk.Separator(Orientation.HORIZONTAL);
        controls_seperator.set_margin_top(2);
        controls_seperator.set_margin_bottom(2);

        var controls_box = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
        var tab_bar = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
        controls_box.pack_start(tab_bar, false, false, 0);

        var notebook = new Gtk.Notebook();
        notebook.set_show_tabs(false);
        notebook.set_hexpand(true);
        notebook.set_vexpand(true);
        controls_box.pack_start(notebook, true, true, 0);

        string[] page_titles = {
            "Exposure",
            "Color Balance",
            "Focus & Zoom",
            "Orientation",
            "Misc Settings"
        };

        string[] icon_names = {
            "preferences-desktop-display-symbolic",
            "preferences-color-symbolic",
            "zoom-in-symbolic",
            "object-flip-horizontal-symbolic",
            "applications-other-symbolic"
        };

        GLib.List<Gtk.ToggleButton> tab_buttons = new GLib.List<ToggleButton>();
        Gtk.ToggleButton? first_btn = null;

        for (int i = 0; i < page_titles.length; i++) {
            int page_index = i;
            var img = new Gtk.Image.from_icon_name(icon_names[page_index], Gtk.IconSize.BUTTON);
            var btn = new Gtk.ToggleButton();
            btn.add(img);
            btn.set_tooltip_text(page_titles[page_index]);
            btn.set_hexpand(true);

            btn.toggled.connect(() => {
                if (btn.get_active()) {
                    notebook.set_visible(true);
                    foreach (var other in tab_buttons) {
                        if (other != btn) {
                            other.set_active(false);
                        }
                    }
                    notebook.set_current_page(page_index);
                }
                else {
                    var all_inactive = true;
                    foreach (var button in tab_buttons) {
                        if (button.get_active()) {
                            all_inactive = false;
                        }
                    }
                    if (all_inactive) {
                        notebook.set_visible(false);
                    }
                }
            });

            tab_buttons.append(btn);
            tab_bar.pack_start(btn, true, true, 0);

            if (first_btn == null) {
                first_btn = btn;
            }
        }

        if (first_btn != null) {
            first_btn.set_active(true);
        }

        var exposure_box = build_notebook_page(out exposure_flowbox, out exposure_empty_label);
        var colorbalance_box = build_notebook_page(out colorbalance_flowbox, out colorbalance_empty_label);
        var focuszoom_box = build_notebook_page(out focuszoom_flowbox, out focuszoom_empty_label);
        var orientation_box = build_notebook_page(out orientation_flowbox, out orientation_empty_label);
        var miscsettings_box = build_notebook_page(out miscsettings_flowbox, out miscsettings_empty_label);
        
        notebook.insert_page(exposure_box, null, 0);
        notebook.insert_page(colorbalance_box, null, 1);
        notebook.insert_page(focuszoom_box, null, 2);
        notebook.insert_page(orientation_box, null, 3);
        notebook.insert_page(miscsettings_box, null, 4);

        set_default_device();

        container.pack_start(top_grid, true, true, 0);
        container.pack_start(controls_seperator, false, false, 0);
        container.pack_start(controls_box, true, true, 0);
        add(container);

        this.show.connect(() => {
            update_ux_state();

            var all_inactive = true;
            foreach (var button in tab_buttons) {
                if (button.active) {
                    all_inactive = false;
                }
            }
            if (all_inactive) {
                notebook.set_visible(false);
            }
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
                rebuild_controls(active_device);
                print("Switched to device: %s\n", active_device);
            }
        });

        enabled_id = enabled_switch.notify["active"].connect(() => {
            SignalHandler.block(enabled_switch, enabled_id);
            settings.set_boolean("applet-enabled", enabled_switch.active);
            update_ux_state();
            SignalHandler.unblock(enabled_switch, enabled_id);
        });

        /*mode_id = auto_whitebalance_switch.notify["active"].connect(() => {
            SignalHandler.block(auto_whitebalance_switch, mode_id);
            settings.set_boolean("whitebalance-auto", auto_whitebalance_switch.active);
            update_ux_state();
            SignalHandler.unblock(auto_whitebalance_switch, mode_id);
        });*/

        /*settings.changed["whitebalance-temperature"].connect(() => {
            SignalHandler.block(absolute_temperature_spinbutton, absolute_temperature_id);
            update_ux_state();
            SignalHandler.unblock(absolute_temperature_spinbutton, absolute_temperature_id);
        });

        settings.changed["whitebalance-relative"].connect(() => {
            SignalHandler.block(relative_temperature_spinbutton, relative_temperature_id);
            update_ux_state();
            SignalHandler.unblock(relative_temperature_spinbutton, relative_temperature_id);
        });*/

        //absolute_temperature_id = absolute_temperature_spinbutton.value_changed.connect(update_absolute_temperature_value);
        //relative_temperature_id = relative_temperature_spinbutton.value_changed.connect(update_relative_temperature_value);

        /*GLib.Timeout.add(automode_refresh_interval_ms, () => {
            update_automode_temperature();
            return true;
        });*/
    }

    private void clear_flowbox_controls(Gtk.FlowBox flowbox) {
        foreach (var child in flowbox.get_children()) {
            flowbox.remove(child);
        }
    }

    private void fill_flowbox_controls(Gtk.FlowBox flowbox, uint[] control_ids, uint[] available_controls) {
        foreach (var control_id in control_ids) {
            if (!(control_id in available_controls)) {
                continue;
            }

            var control_hbox = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);

            var label = build_label(active_device, control_id);
            var control = build_control(active_device, control_id);

            control_hbox.pack_start(label, true, true, 0);
            control_hbox.pack_start(control, false, false, 0);
            flowbox.add(control_hbox);
            flowbox.show_all();
        }
    }

    private void update_flowbox_empty_state(Gtk.FlowBox flowbox, Gtk.Label label) {
        if (flowbox.get_children().length() > 0) {
            label.set_visible(false);
            flowbox.set_visible(true);
        } else {
            label.set_visible(true);
            flowbox.set_visible(false);
        }
    }

    private void rebuild_controls(string device) {
        uint[] available_controls = get_available_controls(device);

        clear_flowbox_controls(exposure_flowbox);
        clear_flowbox_controls(colorbalance_flowbox);
        clear_flowbox_controls(focuszoom_flowbox);
        clear_flowbox_controls(orientation_flowbox);
        clear_flowbox_controls(miscsettings_flowbox);

        fill_flowbox_controls(exposure_flowbox, EXPOSURE_CIDS, available_controls);
        fill_flowbox_controls(colorbalance_flowbox, COLORBALANCE_CIDS, available_controls);
        fill_flowbox_controls(focuszoom_flowbox, ZOOMFOCUS_CIDS, available_controls);
        fill_flowbox_controls(orientation_flowbox, ORIENTATION_CIDS, available_controls);
        fill_flowbox_controls(miscsettings_flowbox, MISCSETTINGS_CIDS, available_controls);

        // TODO Call upon selection / change of device
        update_controls();
    }

    private void update_controls() {
        update_flowbox_empty_state(exposure_flowbox, exposure_empty_label);
        update_flowbox_empty_state(colorbalance_flowbox, colorbalance_empty_label);
        update_flowbox_empty_state(focuszoom_flowbox, focuszoom_empty_label);
        update_flowbox_empty_state(orientation_flowbox, orientation_empty_label);
        update_flowbox_empty_state(miscsettings_flowbox, miscsettings_empty_label);
        // toDO Call upon auto switches / etc
    }

    public Gtk.Box build_notebook_page(out Gtk.FlowBox page_flowbox, out Gtk.Label page_empty_label) {
        page_flowbox = new Gtk.FlowBox();
        page_flowbox.set_valign(Gtk.Align.START);
        page_flowbox.set_row_spacing(6);
        page_flowbox.set_column_spacing(6);
        page_flowbox.set_selection_mode(Gtk.SelectionMode.NONE);

        page_empty_label = new Gtk.Label(_("No available controls"));
        page_empty_label.set_halign(Gtk.Align.CENTER);
        page_empty_label.set_valign(Gtk.Align.CENTER);
        page_empty_label.set_margin_top(20);
        page_empty_label.set_margin_bottom(20);
        page_empty_label.set_margin_start(30);
        page_empty_label.set_margin_end(30);

        var page_box = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
        page_box.pack_start(page_flowbox, true, true, 0);
        page_box.pack_start(page_empty_label, true, true, 0);

        return page_box;
    }

    private Gtk.Widget? build_control(string device, uint control_id) {
        int fd = open_device(device);
        if (fd < 0) {
            GLib.stderr.printf("Could not open device %s\n", device);
            return null;
        }

        V4L2ControlInfo info;
        if (ioctl_wrapper_queryctrl(fd, out info, control_id) != 0) {
            return null;
        }
        
        var value = get_control(device, control_id);
        Gtk.Widget control_widget;

        if (info.type == V4L2_CTRL_TYPE_BOOLEAN) {
            var switch_control = new Gtk.Switch();
            switch_control.active = value != 0;
            control_widget = switch_control;

            switch_control.notify["active"].connect(() => {
                int new_value = switch_control.active ? 1 : 0;
                set_control(device, control_id, new_value);
            });

        } else if (info.type == V4L2_CTRL_TYPE_INTEGER) {
            var adjustment = new Gtk.Adjustment(value, info.minimum, info.maximum, info.step, 0, 0);
            var spinner_control = new Gtk.SpinButton(adjustment, info.step, 0);
            control_widget = spinner_control;

            spinner_control.value_changed.connect(() => {
                int new_value = (int) spinner_control.value;
                set_control(device, control_id, new_value);
            });

        } else if (info.type == V4L2_CTRL_TYPE_MENU) {
            var combobox_control = build_control_menu(fd, control_id, value);
            control_widget = combobox_control;

            combobox_control.changed.connect(() => {
                int new_value = combobox_control.get_active();
                set_control(device, control_id, new_value);
            });

        }/* else if (info.type == V4L2_CTRL_TYPE_BUTTON) {
            var button_control = new Gtk.Button.with_label("Press");
            control_widget = button_control;

            button_control.clicked.connect(() => {
                set_control(device, control_id, 1);
            });

        }*/ else {
            control_widget = new Gtk.Label("Unsupported");
        }

        control_widget.set_halign(Gtk.Align.END);

        Posix.close(fd);

        return control_widget;
    }

    private Gtk.Label? build_label(string device, uint control_id) {
        int fd = open_device(device);
        if (fd < 0) {
            GLib.stderr.printf("Could not open device %s\n", device);
            return null;
        }

        V4L2ControlInfo info;
        if (ioctl_wrapper_queryctrl(fd, out info, control_id) != 0) {
            return null;
        }

        string name;
        switch (control_id) {
            case V4L2_CID_BRIGHTNESS:
                name = "Brightness";
                break;
            case V4L2_CID_CONTRAST:
                name = "Contrast";
                break;
            case V4L2_CID_SATURATION:
                name = "Saturation";
                break;
            case V4L2_CID_HUE:
                name = "Hue";
                break;
            case V4L2_CID_SHARPNESS:
                name = "Sharpness";
                break;
            case V4L2_CID_GAIN:
                name = "Gain";
                break;
            case V4L2_CID_EXPOSURE_ABSOLUTE:
                name = "Exposure";
                break;
            case V4L2_CID_WHITE_BALANCE_TEMPERATURE:
                name = "White Balance";
                break;
            case V4L2_CID_BACKLIGHT_COMPENSATION:
                name = "Backlight Comp.";
                break;
            case V4L2_CID_HFLIP:
                name = "Horizontal Flip";
                break;
            case V4L2_CID_VFLIP:
                name = "Vertical Flip";
                break;
            case V4L2_CID_FOCUS_ABSOLUTE:
                name = "Focus";
                break;
            case V4L2_CID_ZOOM_ABSOLUTE:
                name = "Zoom";
                break;
            case V4L2_CID_EXPOSURE_AUTO:
                name = "Auto Exposure";
                break;
            case V4L2_CID_FOCUS_AUTO:
                name = "Auto Focus";
                break;
            case V4L2_CID_AUTO_WHITE_BALANCE:
                name = "Auto White Balance";
                break;
            default:
                name = ioctl_wrapper_queryctrl_name(fd, info.id) ?? "Unknown";
                break;
        }

        var label = new Gtk.Label(name ?? "Unnamed");
        label.set_halign(Gtk.Align.START);

        Posix.close(fd);

        return label;
    }

    private Gtk.ComboBoxText build_control_menu(int fd, uint control_id, int current_value) {
        var combo = new Gtk.ComboBoxText();
        int index = 0;

        while (true) {
            string? name = ioctl_wrapper_querymenu_name(fd, control_id, index);

            if (name == null) {
                break;
            }

            combo.append_text(name);
            index++;
        }

        combo.active = current_value;
        return combo;
    }

    public void set_default_device() {
        var device_store = (Gtk.ListStore) device_combobox.get_model();
        TreeIter iter;

        if (device_store.get_iter_first(out iter)) {
            device_combobox.set_active_iter(iter);

            GLib.Value val;
            device_store.get_value(iter, 0, out val);
            active_device = (string) val;
            rebuild_controls(active_device);
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
                    rebuild_controls(active_device);
                    return;
                }
            } while (device_store.iter_next(ref iter));
        }

        set_default_device();
    }

    private int open_device(string device) {
        return Posix.open(device, Posix.O_RDWR);
    }

    private string[] get_video_devices() {
        var devices = new string[0];
        
        try {
            var dir = GLib.Dir.open("/dev", 0);

            while (true) {
                string? entry = dir.read_name();

                if (entry == null) {
                    break;
                }

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
            string name = ioctl_wrapper_querycap_card(fd) ?? "Unnamed device";

            Posix.close(fd);

            TreeIter iter;
            device_store.append(out iter);
            device_store.set(iter, 0, device, 1, name);
        }

        if (current != null) {
            set_active_device(current);

        } else {
            set_default_device();
        }
    }

    private bool is_controllable(uint control_id) {
        return control_id in EXPOSURE_CIDS
            || control_id in COLORBALANCE_CIDS
            || control_id in ZOOMFOCUS_CIDS
            || control_id in ORIENTATION_CIDS
            || control_id in MISCSETTINGS_CIDS;
    }

    private uint[] get_available_controls(string device) {
        int fd = open_device(device);
        if (fd < 0) {
            GLib.stderr.printf("Could not open device %s\n", device);
            return new uint[0];
        }

        uint last_id = 0;
        V4L2ControlInfo info;

        GLib.List<uint> controls = new GLib.List<uint>();

        while (ioctl_wrapper_get_next_control(fd, out info, last_id) == 0) {
            last_id = info.id;

            if ((info.flags & V4L2_CTRL_FLAG_DISABLED) != 0) {
                continue;
            }

            if ((info.flags & V4L2_CTRL_FLAG_READ_ONLY) != 0) {
                continue;
            }

            if (!is_controllable(info.id)) {
                continue;
            }

            controls.append(info.id);
        }

        uint[] result = new uint[controls.length()];
        int i = 0;
        for (unowned GLib.List<uint>? l = controls; l != null; l = l.next) {
            result[i++] = l.data;
        }

        return result;
    }

    public bool set_control(string device, uint control_id, int value) {
        int fd = open_device(device);
        if (fd < 0) {
            return false;
        }

        int result = ioctl_wrapper_set_control(fd, control_id, value);

        Posix.close(fd);

        return result == 0;
    }

    public int get_control(string device, uint control_id) {
        int fd = open_device(device);
        if (fd < 0) {
            GLib.stderr.printf("Could not open device %s\n", device);
            return -1;
        }

        int value = -1;
        int result = ioctl_wrapper_get_control(fd, control_id, out value);

        Posix.close(fd);

        if (result != 0) {
            return -1;
        }
        return value;
    }

    public void update_ux_state() {
        refresh_devices();

        /*
        enabled_switch.active = settings.get_boolean("applet-enabled");
        auto_whitebalance_switch.active = settings.get_boolean("whitebalance-auto");
        //absolute_temperature_spinbutton.value = settings.get_int("whitebalance-temperature");
        //relative_temperature_spinbutton.value = settings.get_int("whitebalance-relative");

        bool enabled = enabled_switch.active;
        bool auto_mode = auto_whitebalance_switch.active;

        if (!enabled) {
            auto_whitebalance_switch.set_sensitive(false);
            auto_whitebalance_label.set_sensitive(false);
            //absolute_temperature_spinbutton.set_sensitive(false);
            //absolute_temperature_label.set_sensitive(false);
            //relative_temperature_spinbutton.set_sensitive(false);
            //relative_temperature_label.set_sensitive(false);
            toggle_webcam_automatic(true);
        } else {
            auto_whitebalance_switch.set_sensitive(true);
            auto_whitebalance_label.set_sensitive(true);
            //absolute_temperature_spinbutton.set_sensitive(true);
            //absolute_temperature_label.set_sensitive(true);
            //relative_temperature_spinbutton.set_sensitive(true);
            //relative_temperature_label.set_sensitive(true);
            toggle_webcam_automatic(false);
        }

        if (auto_mode) {
            //absolute_temperature_spinbutton.set_visible(false);
            //absolute_temperature_label.set_visible(false);
            //relative_temperature_spinbutton.set_visible(true);
            //relative_temperature_label.set_visible(true);
        } else {
            //absolute_temperature_spinbutton.set_visible(true);
            //absolute_temperature_label.set_visible(true);
            //relative_temperature_spinbutton.set_visible(false);
            //relative_temperature_label.set_visible(false);
        }*/
    }
}
