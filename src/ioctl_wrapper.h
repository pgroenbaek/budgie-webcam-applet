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

#ifndef IOCTL_WRAPPER_H
#define IOCTL_WRAPPER_H

#include <stdint.h>
#include <linux/videodev2.h>

int ioctl_wrapper_get_control(int fd, uint32_t control_id, int *value);
int ioctl_wrapper_set_control(int fd, uint32_t control_id, int value);
int ioctl_wrapper_get_next_control(int fd, struct v4l2_queryctrl *ctrl, uint32_t last_id);
int ioctl_wrapper_queryctrl(int fd, struct v4l2_queryctrl *out_info, uint32_t id);
const char* ioctl_wrapper_querycap_card(int fd);
const char* ioctl_wrapper_querycap_businfo(int fd);
unsigned int ioctl_wrapper_querycap_capabilities(int fd);
const char* ioctl_wrapper_queryctrl_name(int fd, uint32_t control_id);
const char* ioctl_wrapper_querymenu_name(int fd, uint32_t control_id, uint32_t index);

#endif