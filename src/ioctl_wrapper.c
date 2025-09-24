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

#include <linux/videodev2.h>
#include <sys/ioctl.h>
#include <unistd.h>

int ioctl_wrapper_set_ctrl(int fd, unsigned int id, int value) {
    struct v4l2_control ctrl;
    ctrl.id = id;
    ctrl.value = value;

    return ioctl(fd, VIDIOC_S_CTRL, &ctrl);
}

int ioctl_wrapper_get_ctrl(int fd, unsigned int id, int *value) {
    struct v4l2_control ctrl;
    ctrl.id = id;

    int ret = ioctl(fd, VIDIOC_G_CTRL, &ctrl);

    if (ret == 0) {
        *value = ctrl.value;
    }

    return ret;
}