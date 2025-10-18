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

using V4L2;

[CCode(cheader_filename = "ioctl_wrapper.h")]
namespace IoctlWrapper {

    [CCode(cname = "ioctl_wrapper_get_control")]
    public int get_control(int fd, uint control_id, out int out_value);

    [CCode(cname = "ioctl_wrapper_set_control")]
    public int set_control(int fd, uint control_id, int value);

    [CCode(cname = "ioctl_wrapper_get_next_control")]
    public int get_next_control(int fd, out V4L2.QueryCtrl out_queryctrl, uint last_id);

    [CCode(cname = "ioctl_wrapper_queryctrl")]
    public int queryctrl(int fd, out V4L2.QueryCtrl out_queryctrl, uint id);

    [CCode(cname = "ioctl_wrapper_querycap_card", free_function = "free")]
    public string? querycap_card(int fd);

    [CCode(cname = "ioctl_wrapper_querycap_businfo", free_function = "free")]
    public string? querycap_businfo(int fd);

    [CCode(cname = "ioctl_wrapper_querycap_capabilities")]
    public uint querycap_capabilities(int fd);

    [CCode(cname = "ioctl_wrapper_queryctrl_name", free_function = "free")]
    public string? queryctrl_name(int fd, uint control_id);

    [CCode(cname = "ioctl_wrapper_querymenu_name", free_function = "free")]
    public string? querymenu_name(int fd, uint control_id, uint index);
}
