using Budgie;
using Gtk;
using GLib;

public class WebcamColorTempApplet : Applet {
    private Scale temp_slider;
    private CheckButton auto_adjust;
    private Button apply_button;

    construct {
        temp_slider = new Scale.with_range(Gtk.Orientation.HORIZONTAL, 2500, 6500, 100);
        temp_slider.set_value(get_current_temperature());
        temp_slider.set_hexpand(true);

        auto_adjust = new CheckButton.with_label("Auto Adjust");
        auto_adjust.toggled.connect(this.toggle_auto_adjust);

        apply_button = new Button.with_label("Apply");
        apply_button.clicked.connect(this.apply_temperature);

        var box = new Box(Gtk.Orientation.HORIZONTAL, 5);
        box.pack_start(temp_slider, true, true, 0);
        box.pack_start(auto_adjust, false, false, 0);
        box.pack_start(apply_button, false, false, 0);

        add(box);
    }

    public WebcamColorTempApplet(Budgie.PanelApplet api) {
        Object(api: api);
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
            var match = Regex.simple_match("white_balance_temperature: (\\d+)", output);
            return match != null ? int.parse(match[1]) : 4500;
        } catch (Error e) {
            stderr.printf("Error getting webcam temperature: %s\n", e.message);
            return 4500;
        }
    }
}
