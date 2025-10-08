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

#include "ioctl_wrapper.h"

#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <errno.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/ioctl.h>

int ioctl_wrapper_get_control(int fd, uint32_t control_id, int *value) {
    struct v4l2_control ctrl;
    memset(&ctrl, 0, sizeof(ctrl));
    ctrl.id = control_id;

    if (ioctl(fd, VIDIOC_G_CTRL, &ctrl) < 0) {
        return -1;
    }

    if (value) {
        *value = ctrl.value;
    }

    return 0;
}

int ioctl_wrapper_set_control(int fd, uint32_t control_id, int value) {
    struct v4l2_control ctrl;
    memset(&ctrl, 0, sizeof(ctrl));
    ctrl.id = control_id;
    ctrl.value = value;

    if (ioctl(fd, VIDIOC_S_CTRL, &ctrl) < 0) {
        fprintf(stderr, "VIDIOC_S_CTRL failed for control 0x%x with value %d: %s\n",
            control_id, value, strerror(errno));
        return -1;
    }

    return 0;
}

int ioctl_wrapper_get_next_control(int fd, struct v4l2_queryctrl *ctrl, uint32_t last_id) {
    memset(ctrl, 0, sizeof(*ctrl));
    if (last_id == 0) {
        ctrl->id = V4L2_CTRL_FLAG_NEXT_CTRL;
    } else {
        ctrl->id = last_id | V4L2_CTRL_FLAG_NEXT_CTRL;
    }

    if (ioctl(fd, VIDIOC_QUERYCTRL, ctrl) == 0) {
        return 0;
    }

    if (errno == EINVAL) {
        return 1;
    }

    return -1;
}

int ioctl_wrapper_queryctrl(int fd, struct v4l2_queryctrl *out_info, uint32_t id) {
    struct v4l2_queryctrl q;
    memset(&q, 0, sizeof(q));
    q.id = id;

    if (ioctl(fd, VIDIOC_QUERYCTRL, &q) < 0) {
        return -1;
    }

    if (out_info) {
        memcpy(out_info, &q, sizeof(struct v4l2_queryctrl));
    }

    return 0;
}

const char* ioctl_wrapper_querycap_card(int fd) {
    struct v4l2_capability cap;
    memset(&cap, 0, sizeof(cap));

    if (ioctl(fd, VIDIOC_QUERYCAP, &cap) < 0) {
        return NULL;
    }

    return strdup((const char*) cap.card);
}

const char* ioctl_wrapper_querycap_businfo(int fd) {
    struct v4l2_capability cap;
    memset(&cap, 0, sizeof(cap));

    if (ioctl(fd, VIDIOC_QUERYCAP, &cap) < 0) {
        return NULL;
    }

    return strdup((const char*) cap.bus_info);
}

unsigned int ioctl_wrapper_querycap_capabilities(int fd) {
    struct v4l2_capability cap;
    memset(&cap, 0, sizeof(cap));

    if (ioctl(fd, VIDIOC_QUERYCAP, &cap) < 0) {
        return 0;
    }

    if (cap.device_caps) {
        return cap.device_caps;
    }

    return cap.capabilities;
}

const char* ioctl_wrapper_queryctrl_name(int fd, uint32_t control_id) {
    struct v4l2_queryctrl c;
    memset(&c, 0, sizeof(c));
    c.id = control_id;

    if (ioctl(fd, VIDIOC_QUERYCTRL, &c) < 0) {
        return NULL;
    }

    return strdup((const char*) c.name);
}

const char* ioctl_wrapper_querymenu_name(int fd, uint32_t control_id, uint32_t index) {
    struct v4l2_querymenu m;
    memset(&m, 0, sizeof(m));
    m.id = control_id;
    m.index = index;

    if (ioctl(fd, VIDIOC_QUERYMENU, &m) < 0) {
        return NULL;
    }

    return strdup((const char*) m.name);
}