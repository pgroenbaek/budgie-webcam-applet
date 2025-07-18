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

using Budgie;
using Gtk;
using GLib;

public class WebcamWhitebalancePlugin : Budgie.Plugin, Peas.ExtensionBase {
    public Budgie.Applet get_panel_widget(string uuid) {
        return new WebcamWhitebalanceApplet(uuid);
    }
}

public class WebcamWhitebalanceApplet : Budgie.Applet {
    private Gtk.EventBox event_box;
    private Gtk.Image? applet_icon;

    private Budgie.Popover? popover = null;
    private unowned Budgie.PopoverManager? manager = null;

    private GLib.Settings? interface_settings;
    private GLib.Settings? settings;

    private string? whitebalance_disabled;
    private string? whitebalance_enabled;

    public string uuid { public set; public get; }

    public WebcamWhitebalanceApplet(string uuid) {
        Object(uuid: uuid);

        interface_settings = new GLib.Settings("org.gnome.desktop.interface");
        settings = new GLib.Settings("io.grnbk.webcamwhitebalance");

        whitebalance_disabled = "camera-whitebalance-disabled";
        whitebalance_enabled = "camera-whitebalance-enabled";

        event_box = new Gtk.EventBox();
        this.add(event_box);
        applet_icon = new Gtk.Image.from_icon_name(get_current_mode_icon(), Gtk.IconSize.MENU);
        event_box.add(applet_icon);

        popover = new WebcamWhitebalanceWindow(event_box, settings);

        settings.changed["whitebalance-enabled"].connect(() => {
            update_icon();
        });

        event_box.button_press_event.connect((e) => {
            switch (e.button) {
            case 1:
                if (popover.get_visible()) {
                    popover.hide();
                } else {
                    popover.show_all();
                    this.manager.show_popover(event_box);
                }
                break;
            case 2:
                toggle_enabled();
                break;
            default:
                return Gdk.EVENT_PROPAGATE;
            }

            return Gdk.EVENT_STOP;
        });

        this.show_all();
    }

    private string get_current_mode_icon() {
        bool enabled = settings.get_boolean("whitebalance-enabled");
        string state_icon = (enabled) ? whitebalance_enabled : whitebalance_disabled;
        return state_icon;
    }

    private void toggle_enabled() {
        bool enabled = settings.get_boolean("whitebalance-enabled");
        settings.set_boolean("whitebalance-enabled", !enabled);
    }

    private void update_icon() {
        if (applet_icon != null) {
            applet_icon.set_from_icon_name(get_current_mode_icon(), Gtk.IconSize.MENU);
        }
    }

    public override void update_popovers(Budgie.PopoverManager? manager) {
        manager.register_popover(event_box, popover);
        this.manager = manager;
    }

    public override bool supports_settings() {
        return true;
    }

    public override Gtk.Widget? get_settings_ui() {
        return new WebcamWhitebalanceSettings(this.get_applet_settings(uuid));
    }
}

[ModuleInit]
public void peas_register_types(TypeModule module)
{
    var objmodule = module as Peas.ObjectModule;
    objmodule.register_extension_type(typeof(Budgie.Plugin), typeof(WebcamWhitebalancePlugin));
}
