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

[CCode(cheader_filename = "linux/videodev2.h", cname = "V4L2_CTRL_FLAG_READ_ONLY")]
public static extern uint V4L2_CTRL_FLAG_READ_ONLY;

[CCode(cheader_filename = "linux/videodev2.h", cname = "V4L2_CTRL_TYPE_BOOLEAN")]
public static extern uint V4L2_CTRL_TYPE_BOOLEAN;

[CCode(cheader_filename = "linux/videodev2.h", cname = "V4L2_CTRL_TYPE_INTEGER")]
public static extern uint V4L2_CTRL_TYPE_INTEGER;

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

[CCode(cheader_filename = "ioctl_wrapper.h")]
public extern int ioctl_wrapper_get_next_control(int fd, out V4L2ControlInfo out_info, uint last_id);

[CCode(cheader_filename = "ioctl_wrapper.h")]
public extern int ioctl_wrapper_queryctrl(int fd, out V4L2ControlInfo out_info, uint id);

[CCode(cheader_filename = "ioctl_wrapper.h", free_function = "free")]
public extern string? ioctl_wrapper_querycap_card(int fd);

[CCode(cheader_filename = "ioctl_wrapper.h", free_function = "free")]
public extern string? ioctl_wrapper_querycap_businfo(int fd);

[CCode(cheader_filename = "ioctl_wrapper.h", free_function = "free")]
public extern string? ioctl_wrapper_queryctrl_name(int fd, uint control_id);

[CCode(cheader_filename = "ioctl_wrapper.h", free_function = "free")]
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

private const uint[] EXPOSURE_CIDS = {
    V4L2_CID_BRIGHTNESS,
    V4L2_CID_CONTRAST,
    V4L2_CID_GAIN,
    V4L2_CID_EXPOSURE_AUTO,
    V4L2_CID_EXPOSURE_ABSOLUTE,
    V4L2_CID_BACKLIGHT_COMPENSATION
};

private const uint[] COLORBALANCE_CIDS = {
    V4L2_CID_SATURATION,
    V4L2_CID_HUE,
    V4L2_CID_AUTO_WHITE_BALANCE,
    V4L2_CID_WHITE_BALANCE_TEMPERATURE
};

private const uint[] ZOOMFOCUS_CIDS = {
    V4L2_CID_SHARPNESS,
    V4L2_CID_FOCUS_AUTO,
    V4L2_CID_FOCUS_ABSOLUTE,
    V4L2_CID_ZOOM_ABSOLUTE
};

private const uint[] ORIENTATION_CIDS = {
    V4L2_CID_HFLIP,
    V4L2_CID_VFLIP
};

private const uint[] MISCSETTINGS_CIDS = {
    V4L2_CID_POWER_LINE_FREQUENCY,
    V4L2_CID_PRIVACY
};

private const uint[] AUTO_CIDS = {
    V4L2_CID_EXPOSURE_AUTO,
    V4L2_CID_FOCUS_AUTO,
    V4L2_CID_AUTO_WHITE_BALANCE
};

private const uint[] MANUAL_CIDS = {
    V4L2_CID_EXPOSURE_ABSOLUTE,
    V4L2_CID_FOCUS_ABSOLUTE,
    V4L2_CID_WHITE_BALANCE_TEMPERATURE
};

// TODO's:
// - Properly handle devices, only show one video device per physical device

public class WebcamAppletWindow : Budgie.Popover {

    private Gtk.Switch? enabled_switch = null;
    private Gtk.ComboBox? device_combobox = null;
    private Gtk.ListStore? device_store = null;
    private Gtk.Label? device_label = null;

    private Gtk.Box? exposure_box = null;
    private Gtk.Label? exposure_empty_label = null;
    private Gtk.Box? colorbalance_box = null;
    private Gtk.Label? colorbalance_empty_label = null;
    private Gtk.Box? focuszoom_box = null;
    private Gtk.Label? focuszoom_empty_label = null;
    private Gtk.Box? orientation_box = null;
    private Gtk.Label? orientation_empty_label = null;
    private Gtk.Box? miscsettings_box = null;
    private Gtk.Label? miscsettings_empty_label = null;

    private Gtk.Notebook? notebook = null;
    private Gtk.ToggleButton? first_tab_button = null;
    private GLib.List<Gtk.ToggleButton> tab_buttons = new GLib.List<ToggleButton>();

    private GLib.HashTable<uint, Gtk.Widget> control_widgets =
        new GLib.HashTable<uint, Gtk.Widget>(GLib.direct_hash, GLib.direct_equal);

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

        try {
            css.load_from_data("label.bold-grey { font-weight: bold; color: #8d939e; }");
        } catch(GLib.Error e) {
            // ignore
        }

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

        var top_grid = new Gtk.Grid();
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
        tab_bar.set_margin_bottom(2);
        controls_box.pack_start(tab_bar, false, false, 0);

        notebook = new Gtk.Notebook();
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

        string[] fallback_icon_names = {
            "webcam-exposure",
            "webcam-colorbalance",
            "webcam-focuszoom",
            "webcam-orientation",
            "webcam-miscsettings"
        };

        var icon_theme = Gtk.IconTheme.get_default();

        for (int i = 0; i < page_titles.length; i++) {
            string icon_name = icon_names[i];
            if (!icon_theme.has_icon(icon_name)) {
                icon_name = fallback_icon_names[i];
            }

            var button_icon = new Gtk.Image.from_icon_name(icon_names[i], Gtk.IconSize.BUTTON);
            var button = new Gtk.ToggleButton();
            button.add(button_icon);
            button.set_tooltip_text(page_titles[i]);
            button.set_hexpand(true);

            button.toggled.connect(() => {
                update_notebook_visibility(button);
            });

            tab_buttons.append(button);
            tab_bar.pack_start(button, true, true, 0);

            if (first_tab_button == null) {
                first_tab_button = button;
            }
        }

        if (first_tab_button != null) {
            first_tab_button.set_active(true);
        }

        var exposure_page = build_notebook_page(out exposure_box, out exposure_empty_label);
        var colorbalance_page = build_notebook_page(out colorbalance_box, out colorbalance_empty_label);
        var focuszoom_page = build_notebook_page(out focuszoom_box, out focuszoom_empty_label);
        var orientation_page = build_notebook_page(out orientation_box, out orientation_empty_label);
        var miscsettings_page = build_notebook_page(out miscsettings_box, out miscsettings_empty_label);
        
        notebook.insert_page(exposure_page, null, 0);
        notebook.insert_page(colorbalance_page, null, 1);
        notebook.insert_page(focuszoom_page, null, 2);
        notebook.insert_page(orientation_page, null, 3);
        notebook.insert_page(miscsettings_page, null, 4);

        container.pack_start(top_grid, true, true, 0);
        container.pack_start(controls_seperator, false, false, 0);
        container.pack_start(controls_box, true, true, 0);
        add(container);

        set_default_device();
        refresh_devices();

        this.show.connect(() => {
            refresh_devices();
            update_notebook_visibility(null);
        });

        settings.changed["applet-enabled"].connect(() => {
            refresh_devices();
        });

        device_combobox.changed.connect(() => {
            var device_store = (Gtk.ListStore) device_combobox.get_model();

            TreeIter iter;
            if (device_combobox.get_active_iter(out iter)) {
                GLib.Value val;
                device_store.get_value(iter, 0, out val);
                active_device = (string) val;
                rebuild_controls(active_device);
            }
        });

        enabled_id = enabled_switch.notify["active"].connect(() => {
            SignalHandler.block(enabled_switch, enabled_id);
            settings.set_boolean("applet-enabled", enabled_switch.active);
            refresh_devices();
            SignalHandler.unblock(enabled_switch, enabled_id);
        });
    }

    private void clear_controls(Gtk.Box box) {
        foreach (var child in box.get_children()) {
            box.remove(child);
        }
    }

    private void fill_controls(Gtk.Box box, uint[] control_ids, uint[] available_controls) {
        foreach (var control_id in control_ids) {
            if (!(control_id in available_controls)) {
                continue;
            }

            var control_hbox = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);

            var label = build_label(active_device, control_id);
            var control = build_control(active_device, control_id);

            control_hbox.pack_start(label, true, true, 0);
            control_hbox.pack_start(control, false, false, 0);
            box.add(control_hbox);
            box.show_all();
        }
    }
    
    private void update_empty_state(Gtk.Box box, Gtk.Label label) {
        if (box.get_children().length() > 0) {
            label.set_visible(false);
            box.set_visible(true);
        } else {
            label.set_visible(true);
            box.set_visible(false);
        }
    }

    private int get_tab_button_index(Gtk.ToggleButton button) {
        int index = 0;

        for (unowned GLib.List<Gtk.ToggleButton>? l = tab_buttons; l != null; l = l.next) {
            if (l.data == button) {
                return index;
            }
            index++;
        }

        return -1;
    }

    private void update_notebook_visibility(Gtk.ToggleButton? clicked_button) {
        if (clicked_button != null && clicked_button.get_active()) {
            notebook.set_visible(true);

            foreach (var other_button in tab_buttons) {
                if (other_button != clicked_button) {
                    other_button.set_active(false);
                }
            }

            var page_index = get_tab_button_index(clicked_button);
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
    }

    private void update_manual_state(uint auto_control_id, int auto_value) {
        for (int i = 0; i < AUTO_CIDS.length; i++) {
            if (AUTO_CIDS[i] == auto_control_id) {
                uint manual_control_id = MANUAL_CIDS[i];
                Gtk.Widget? manual_widget = control_widgets.lookup(manual_control_id);

                if (manual_widget != null) {
                    bool enable;

                    if (auto_control_id == V4L2_CID_EXPOSURE_AUTO) {
                        enable = (auto_value == 1);
                    } else {
                        enable = (auto_value == 0);
                    }

                    manual_widget.set_sensitive(enable);
                }

                break;
            }
        }
    }

    private void rebuild_controls(string device) {
        uint[] available_controls = get_available_controls(device);

        clear_controls(exposure_box);
        clear_controls(colorbalance_box);
        clear_controls(focuszoom_box);
        clear_controls(orientation_box);
        clear_controls(miscsettings_box);

        fill_controls(exposure_box, EXPOSURE_CIDS, available_controls);
        fill_controls(colorbalance_box, COLORBALANCE_CIDS, available_controls);
        fill_controls(focuszoom_box, ZOOMFOCUS_CIDS, available_controls);
        fill_controls(orientation_box, ORIENTATION_CIDS, available_controls);
        fill_controls(miscsettings_box, MISCSETTINGS_CIDS, available_controls);

        update_empty_state(exposure_box, exposure_empty_label);
        update_empty_state(colorbalance_box, colorbalance_empty_label);
        update_empty_state(focuszoom_box, focuszoom_empty_label);
        update_empty_state(orientation_box, orientation_empty_label);
        update_empty_state(miscsettings_box, miscsettings_empty_label);
        
        for (int i = 0; i < AUTO_CIDS.length; i++) {
            uint control_id = AUTO_CIDS[i];
            int value = get_control(active_device, control_id);

            update_manual_state(control_id, value);
        }
    }

    private Gtk.Box build_notebook_page(out Gtk.Box out_box, out Gtk.Label out_empty_label) {
        out_box = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
        out_box.set_valign(Gtk.Align.START);

        out_empty_label = new Gtk.Label(_("No available controls"));
        out_empty_label.set_halign(Gtk.Align.CENTER);
        out_empty_label.set_valign(Gtk.Align.CENTER);
        out_empty_label.set_margin_top(20);
        out_empty_label.set_margin_bottom(20);
        out_empty_label.set_margin_start(30);
        out_empty_label.set_margin_end(30);

        var page_box = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
        page_box.pack_start(out_box, true, true, 0);
        page_box.pack_start(out_empty_label, true, true, 0);
        page_box.set_margin_top(4);
        page_box.set_margin_start(4);
        page_box.set_margin_end(4);

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
                update_manual_state(control_id, new_value);
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
            var combobox_control = build_control_menu(fd, control_id, value, info.minimum, info.maximum);
            control_widget = combobox_control;

            combobox_control.changed.connect(() => {
                int new_value = combobox_control.get_active();
                set_control(device, control_id, new_value);
                update_manual_state(control_id, new_value);
            });

        } else {
            control_widget = new Gtk.Label("Unsupported");
        }

        control_widget.set_halign(Gtk.Align.END);
        control_widget.set_margin_bottom(4);

        control_widgets[control_id] = control_widget;

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
        label.set_margin_bottom(4);
        label.set_margin_start(3);

        Posix.close(fd);

        return label;
    }

    private Gtk.ComboBoxText build_control_menu(int fd, uint control_id, int current_value, int min_index, int max_index) {
        var combobox = new Gtk.ComboBoxText();

        for (int index = min_index; index <= max_index; index++) {
            string? name = ioctl_wrapper_querymenu_name(fd, control_id, index);

            if (name == null) {

                if (control_id == V4L2_CID_EXPOSURE_AUTO) {
                    switch (index) {
                        case 0:
                            name = "Auto";
                            break;
                        case 1:
                            name = "Manual";
                            break;
                        case 2:
                            name = "Shutter Priority";
                            break;
                        case 3:
                            name = "Aperture Priority";
                            break;
                        default:
                            continue;
                    }
                
                } else if (control_id == V4L2_CID_POWER_LINE_FREQUENCY) {
                    switch (index) {
                        case 0:
                            name = "Disabled";
                            break;
                        case 1:
                            name = "50 Hz";
                            break;
                        case 2:
                            name = "60 Hz";
                            break;
                        default:
                            continue;
                    }
                } else {
                    continue;
                }
            }

            combobox.append_text(name);
        }

        combobox.active = current_value;
        return combobox;
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
}
