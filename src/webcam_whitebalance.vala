using Budgie;
using Gtk;
using GLib;

public class WebcamWhitebalanceAppletFactory : GLib.Object, Budgie.Plugin {

    public Budgie.Applet get_panel_widget(string uuid)
    {
        return new WebcamWhitebalanceApplet(uuid);
    }
}

public class WebcamWhitebalanceApplet : Budgie.Applet {
    private Budgie.Popover popover;
    private Scale temp_slider;
    private CheckButton auto_adjust;
    private Button apply_button;

    public WebcamWhitebalanceApplet(string uuid) {
        Object();

        // Create EventBox and Image as a trigger
        var event_box = new Gtk.EventBox();
        var icon = new Gtk.Image.from_icon_name("caffeine-cup-empty", Gtk.IconSize.BUTTON);
        event_box.add(icon);
        this.add(event_box);

        // Create the popover, passing event_box as the parent widget
        popover = new Budgie.Popover(event_box); // Correct constructor
        popover.get_style_context().add_class("caffeine-popover");

        // UI Elements inside Popover
        temp_slider = new Gtk.Scale.with_range(Gtk.Orientation.HORIZONTAL, 2500, 6500, 100);
        temp_slider.set_value(get_current_temperature());
        temp_slider.set_hexpand(true);

        auto_adjust = new Gtk.CheckButton.with_label("Auto Adjust");
        auto_adjust.toggled.connect(this.toggle_auto_adjust);

        apply_button = new Gtk.Button.with_label("Apply");
        apply_button.clicked.connect(this.apply_temperature);

        // Layout inside popover
        var box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 5);
        box.pack_start(temp_slider, true, true, 0);
        box.pack_start(auto_adjust, false, false, 0);
        box.pack_start(apply_button, false, false, 0);

        var layout = new Gtk.Grid();
        layout.set_row_spacing(8);
        layout.set_column_spacing(6);
        layout.set_border_width(10);
        layout.attach(box, 0, 0, 1, 1);

        popover.add(layout);
        popover.show_all();

        // No need for Budgie.PopoverManager.register_popover here, just handle visibility manually
        // Show the popover when clicking the event_box
        event_box.button_press_event.connect((widget, event) => {
            if (popover.is_visible()) {
                popover.hide();
            } else {
                popover.show_all();  // Show popover
            }
            return true;
        });

        show_all();
    }

    private void toggle_auto_adjust() {
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
    }

    public override bool supports_settings() {
        return true;
    }

    public override Gtk.Widget? get_settings_ui()
    {
        return new WebcamWhitebalanceAppletSettings();
    }

    /*public override void update_popovers(Budgie.PopoverManager? manager)
    {
        //manager.register_popover(this.box, this.my_popover);
        //this.manager = manager;
    }*/
}

public class WebcamWhitebalanceAppletSettings : Gtk.Box
{
    public WebcamWhitebalanceAppletSettings()
    {
        var label = new Gtk.Label("I am still Groot.");
        add(label);

        show_all();
    }
}

[ModuleInit]
public void peas_register_types(TypeModule module)
{
    var objmodule = module as Peas.ObjectModule;
    objmodule.register_extension_type(typeof(Budgie.Plugin), typeof(WebcamWhitebalanceAppletFactory));
}
