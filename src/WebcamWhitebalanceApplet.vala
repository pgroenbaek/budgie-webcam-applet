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

    private ThemedIcon? caffeine_full_cup;
    private ThemedIcon? caffeine_empty_cup;

    public string uuid { public set; public get; }

    public WebcamWhitebalanceApplet(string uuid) {
        Object(uuid: uuid);

        interface_settings = new GLib.Settings("org.gnome.desktop.interface");
        settings = new GLib.Settings("io.grnbk.webcamwhitebalance");

        caffeine_full_cup = new ThemedIcon.from_names( {"caffeine-cup-full", "budgie-caffeine-cup-full" });
        caffeine_empty_cup = new ThemedIcon.from_names( {"caffeine-cup-empty", "budgie-caffeine-cup-empty" });

        event_box = new Gtk.EventBox();
        this.add(event_box);
        //applet_icon = new Gtk.Image.from_gicon(get_current_mode_icon(), Gtk.IconSize.MENU);
        applet_icon = new Gtk.Image.from_icon_name("whitebalanceapplet", Gtk.IconSize.MENU);
        event_box.add(applet_icon);

        popover = new WebcamWhitebalanceWindow(event_box, settings);

        /*settings.changed["caffeine-mode"].connect(() => {
            update_icon();
        });

        interface_settings.changed["icon-theme"].connect_after(() => {
            Timeout.add(200, () => {
                set_caffeine_icons();
                update_icon();
                return false;
            });
        });*/

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
            //case 2:
            //    toggle_caffeine_mode();
            //    break;
            default:
                return Gdk.EVENT_PROPAGATE;
            }

            return Gdk.EVENT_STOP;
        });

        this.show_all();
    }

    private ThemedIcon get_current_mode_icon() {
        bool enabled = true;//settings.get_boolean("caffeine-mode");
        ThemedIcon state_icon = (enabled) ? caffeine_full_cup : caffeine_empty_cup;
        return state_icon;
    }

    private void toggle_caffeine_mode() {
        /*bool enabled = settings.get_boolean("caffeine-mode");
        settings.set_boolean("caffeine-mode", !enabled);*/
    }

    private void set_caffeine_icons() {
        caffeine_full_cup = new ThemedIcon.from_names( {"caffeine-cup-full", "budgie-caffeine-cup-full" });
        caffeine_empty_cup = new ThemedIcon.from_names( {"caffeine-cup-empty", "budgie-caffeine-cup-empty" });
    }

    private void update_icon() {
        //applet_icon.set_from_gicon(get_current_mode_icon(), Gtk.IconSize.MENU);
        applet_icon = new Gtk.Image.from_icon_name("whitebalanceapplet", Gtk.IconSize.MENU);
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
