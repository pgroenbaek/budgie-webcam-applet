# Budgie Webcam White Balance Applet

This is a Budgie panel applet that allows users to adjust the white balance temperature of their webcam using `v4l2-ctl`.


## Installing
```bash
sudo dpkg -i ../budgie-webcam-whitebalance-applet_1.0-1_amd64.deb
```

## Usage
1. Add the applet to your Budgie panel.
2. Use the slider to adjust the white balance temperature.
3. Click "Apply" to apply the changes.

## Building
### Prerequisites
Ensure you have the required dependencies installed:
```bash
sudo apt install budgie-desktop budgie-core budgie-core-dev v4l-utils meson ninja-build valac
```

### Build Shared Library
```bash
meson setup build
ninja -C build
```

## Build Debian Package
To build a `.deb` package:
```bash
dpkg-buildpackage -us -uc
```

## License
GPL-3.0
