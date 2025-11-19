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

[CCode(cheader_filename = "linux/videodev2.h")]
namespace V4L2 {

    [CCode(cname = "V4L2_CAP_VIDEO_CAPTURE")]
    public const uint CAP_VIDEO_CAPTURE;

    [CCode(cname = "V4L2_CAP_STREAMING")]
    public const uint CAP_STREAMING;

    [CCode(cname = "V4L2_CAP_META_CAPTURE")]
    public const uint CAP_META_CAPTURE;

    [CCode(cname = "V4L2_CID_BRIGHTNESS")]
    public const uint CID_BRIGHTNESS;

    [CCode(cname = "V4L2_CID_CONTRAST")]
    public const uint CID_CONTRAST;

    [CCode(cname = "V4L2_CID_SATURATION")]
    public const uint CID_SATURATION;

    [CCode(cname = "V4L2_CID_HUE")]
    public const uint CID_HUE;

    [CCode(cname = "V4L2_CID_AUTO_WHITE_BALANCE")]
    public const uint CID_AUTO_WHITE_BALANCE;

    [CCode(cname = "V4L2_CID_DO_WHITE_BALANCE")]
    public const uint CID_DO_WHITE_BALANCE;

    [CCode(cname = "V4L2_CID_RED_BALANCE")]
    public const uint CID_RED_BALANCE;

    [CCode(cname = "V4L2_CID_BLUE_BALANCE")]
    public const uint CID_BLUE_BALANCE;

    [CCode(cname = "V4L2_CID_GAMMA")]
    public const uint CID_GAMMA;

    [CCode(cname = "V4L2_CID_EXPOSURE")]
    public const uint CID_EXPOSURE;

    [CCode(cname = "V4L2_CID_AUTOGAIN")]
    public const uint CID_AUTOGAIN;

    [CCode(cname = "V4L2_CID_GAIN")]
    public const uint CID_GAIN;

    [CCode(cname = "V4L2_CID_HFLIP")]
    public const uint CID_HFLIP;

    [CCode(cname = "V4L2_CID_VFLIP")]
    public const uint CID_VFLIP;

    [CCode(cname = "V4L2_CID_POWER_LINE_FREQUENCY")]
    public const uint CID_POWER_LINE_FREQUENCY;

    [CCode(cname = "V4L2_CID_HUE_AUTO")]
    public const uint CID_HUE_AUTO;

    [CCode(cname = "V4L2_CID_WHITE_BALANCE_TEMPERATURE")]
    public const uint CID_WHITE_BALANCE_TEMPERATURE;

    [CCode(cname = "V4L2_CID_SHARPNESS")]
    public const uint CID_SHARPNESS;

    [CCode(cname = "V4L2_CID_BACKLIGHT_COMPENSATION")]
    public const uint CID_BACKLIGHT_COMPENSATION;

    [CCode(cname = "V4L2_CID_COLORFX")]
    public const uint CID_COLORFX;

    [CCode(cname = "V4L2_CID_EXPOSURE_AUTO")]
    public const uint CID_EXPOSURE_AUTO;

    [CCode(cname = "V4L2_CID_EXPOSURE_ABSOLUTE")]
    public const uint CID_EXPOSURE_ABSOLUTE;

    [CCode(cname = "V4L2_CID_EXPOSURE_AUTO_PRIORITY")]
    public const uint CID_EXPOSURE_AUTO_PRIORITY;

    [CCode(cname = "V4L2_CID_FOCUS_ABSOLUTE")]
    public const uint CID_FOCUS_ABSOLUTE;

    [CCode(cname = "V4L2_CID_FOCUS_AUTO")]
    public const uint CID_FOCUS_AUTO;

    [CCode(cname = "V4L2_CID_ZOOM_ABSOLUTE")]
    public const uint CID_ZOOM_ABSOLUTE;

    [CCode(cname = "V4L2_CID_PRIVACY")]
    public const uint CID_PRIVACY;

    [CCode(cname = "V4L2_EXPOSURE_MANUAL")]
    public const int EXPOSURE_MANUAL;

    [CCode(cname = "struct v4l2_queryctrl")]
    public struct QueryCtrl {
        public uint id;
        public uint type;
        public int minimum;
        public int maximum;
        public int step;
        public int default_value;
        public uint flags;
    }

    [CCode(cname = "V4L2_CTRL_FLAG_DISABLED")]
    public static uint CTRL_FLAG_DISABLED;

    [CCode(cname = "V4L2_CTRL_FLAG_READ_ONLY")]
    public static uint CTRL_FLAG_READ_ONLY;

    [CCode(cname = "V4L2_CTRL_TYPE_BOOLEAN")]
    public static uint CTRL_TYPE_BOOLEAN;

    [CCode(cname = "V4L2_CTRL_TYPE_INTEGER")]
    public static uint CTRL_TYPE_INTEGER;

    [CCode(cname = "V4L2_CTRL_TYPE_MENU")]
    public static uint CTRL_TYPE_MENU;
}
