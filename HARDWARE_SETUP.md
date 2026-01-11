/*!
    @file    HARDWARE_SETUP.md
    @brief   Hardware setup and configuration guide for Delaney Motorsports DDU11 Dashboard

    This document provides comprehensive hardware setup instructions for deploying the
    Delaney Motorsports digital dashboard on embedded platforms including Raspberry Pi 5
    and NVIDIA Jetson developer kits. Covers operating system installation, Qt setup,
    display configuration, sensor integration, and performance optimization.

    @author  Kevin Delaney
    @date    January 8, 2026
    @company Delaney Motorsports, LLC
    @address Sarasota, FL
*/

# Hardware Setup Guide

## Overview

This guide provides step-by-step instructions for setting up the Delaney Motorsports DDU11 Dashboard UI on embedded hardware platforms. The system is designed to run on readily available, powerful computing platforms suitable for automotive and motorsports applications.

---

## Supported Hardware Platforms

### Raspberry Pi 5

**Specifications**:
- **Processor**: Broadcom BCM2712, Quad-core ARM Cortex-A76 @ 2.4GHz
- **RAM**: 4GB or 8GB LPDDR4X (8GB recommended)
- **GPU**: VideoCore VII with OpenGL ES 3.1, Vulkan 1.2
- **Display**: Dual 4K HDMI output, DSI connector for touch displays
- **Storage**: MicroSD card (Class 10 UHS-I minimum, 32GB+)
- **GPIO**: 40-pin GPIO header for sensor connectivity
- **Connectivity**: Gigabit Ethernet, WiFi 6, Bluetooth 5.0, USB 3.0

**Advantages**:
- Cost-effective (~$60-$80)
- Excellent community support
- Low power consumption (suitable for automotive use)
- Extensive GPIO for sensor integration

**Best For**: Budget-conscious builds, prototyping, aftermarket installations

### NVIDIA Jetson Developer Kits

#### Jetson Nano

**Specifications**:
- **Processor**: Quad-core ARM A57 @ 1.43GHz
- **GPU**: 128-core NVIDIA Maxwell
- **RAM**: 4GB LPDDR4
- **Display**: HDMI 2.0, DisplayPort
- **Storage**: MicroSD card + NVMe option

**Best For**: Entry-level GPU-accelerated applications

#### Jetson Xavier NX

**Specifications**:
- **Processor**: 6-core NVIDIA Carmel ARM v8.2 @ 1.9GHz
- **GPU**: 384-core NVIDIA Volta with 48 Tensor Cores
- **RAM**: 8GB LPDDR4x
- **AI Performance**: 21 TOPS
- **Display**: HDMI 2.0, multiple display outputs

**Best For**: AI-enhanced features, advanced graphics, professional applications

#### Jetson Orin Nano

**Specifications**:
- **Processor**: 6-core NVIDIA ARM Cortex-A78AE
- **GPU**: 1024-core NVIDIA Ampere
- **RAM**: 8GB LPDDR5
- **AI Performance**: 40 TOPS
- **Display**: Multiple output options

**Best For**: Latest performance, future-proof installations, AI integration

**Advantages of Jetson Platforms**:
- Superior graphics performance
- Hardware-accelerated rendering
- AI/ML capabilities for advanced features
- Industrial-grade reliability
- Better thermal management for automotive environments

---

## Raspberry Pi 5 Setup

### 1. Operating System Installation

#### Recommended OS: Raspberry Pi OS (64-bit) with Desktop

**Installation Steps**:

1. **Download Raspberry Pi Imager**:
   ```bash
   # On Linux
   sudo apt install rpi-imager

   # Or download from https://www.raspberrypi.com/software/
   ```

2. **Flash OS to MicroSD Card**:
   - Insert MicroSD card (32GB minimum, 64GB recommended)
   - Launch Raspberry Pi Imager
   - Select: "Raspberry Pi OS (64-bit)" with Desktop
   - Choose your MicroSD card
   - Click "Write" and wait for completion

3. **Initial Configuration**:
   - Insert MicroSD card into Raspberry Pi 5
   - Connect display, keyboard, mouse
   - Power on the system
   - Complete setup wizard (region, WiFi, password)

### 2. System Configuration

#### Update System Packages

```bash
sudo apt update
sudo apt upgrade -y
sudo apt dist-upgrade -y
```

#### Configure Boot Options

```bash
sudo raspi-config
```

Navigate to:
- **System Options → Boot / Auto Login → Console Autologin** (for production)
- **Display Options → Resolution** → Set to native display resolution
- **Performance Options → GPU Memory** → Set to 256MB minimum
- **Interface Options**:
  - Enable **I2C** (for sensors)
  - Enable **SPI** (if needed)
  - Enable **Serial Port** (for CAN bus adapters)

#### Increase Swap Space (Recommended for 4GB models)

```bash
sudo dphys-swapfile swapoff
sudo nano /etc/dphys-swapfile
```

Change `CONF_SWAPSIZE=100` to `CONF_SWAPSIZE=2048`

```bash
sudo dphys-swapfile setup
sudo dphys-swapfile swapon
```

### 3. Qt Installation

#### Method A: Install from Repositories (Easier)

```bash
sudo apt install -y \
    qt5-default \
    qtdeclarative5-dev \
    qtmultimedia5-dev \
    qml-module-qtquick2 \
    qml-module-qtquick-controls2 \
    qml-module-qtquick-layouts \
    qml-module-qtmultimedia \
    libqt5multimedia5-plugins \
    qttools5-dev-tools
```

#### Method B: Build from Source (Advanced, Better Performance)

```bash
# Install build dependencies
sudo apt install -y \
    build-essential \
    git \
    cmake \
    ninja-build \
    libfontconfig1-dev \
    libdbus-1-dev \
    libfreetype6-dev \
    libicu-dev \
    libsqlite3-dev \
    libssl-dev \
    libpng-dev \
    libjpeg-dev \
    libglib2.0-dev

# Download Qt 5.15.x (or Qt 6.x)
wget https://download.qt.io/official_releases/qt/5.15/5.15.12/single/qt-everywhere-opensource-src-5.15.12.tar.xz
tar xf qt-everywhere-opensource-src-5.15.12.tar.xz
cd qt-everywhere-src-5.15.12

# Configure Qt for embedded ARM
./configure \
    -opensource \
    -confirm-license \
    -release \
    -opengl es2 \
    -eglfs \
    -nomake examples \
    -nomake tests \
    -prefix /opt/qt5

# Build (this takes several hours)
make -j4
sudo make install
```

### 4. Display Configuration

#### For DSI Touch Displays (e.g., Raspberry Pi Official Touch Display)

DSI displays are auto-detected. To rotate display:

```bash
sudo nano /boot/config.txt
```

Add:
```
# Rotate display 180 degrees (if needed)
display_rotate=2

# For better touch response
dtoverlay=vc4-kms-v3d
max_framebuffers=2
```

#### For HDMI Displays

```bash
sudo nano /boot/config.txt
```

Configure resolution:
```
# Force HDMI mode
hdmi_force_hotplug=1

# Set resolution (1920x1080)
hdmi_group=2
hdmi_mode=82

# For OLED/AMOLED displays with deep blacks
hdmi_pixel_encoding=2
```

Reboot:
```bash
sudo reboot
```

### 5. Sensor and Hardware Integration

#### Enable I2C for Accelerometer/Gyroscope

```bash
sudo apt install -y i2c-tools python3-smbus
sudo i2cdetect -y 1
```

#### GPIO Access for Analog Sensors

```bash
sudo apt install -y python3-rpi.gpio wiringpi
sudo usermod -a -G gpio $USER
```

#### Install CAN Bus Support

For CAN bus integration (e.g., MCP2515 CAN HAT):

```bash
sudo nano /boot/config.txt
```

Add:
```
dtparam=spi=on
dtoverlay=mcp2515-can0,oscillator=8000000,interrupt=25
```

Install SocketCAN:
```bash
sudo apt install -y can-utils
```

Configure CAN interface:
```bash
sudo ip link set can0 up type can bitrate 500000
```

To make persistent:
```bash
sudo nano /etc/network/interfaces.d/can0
```

Add:
```
auto can0
iface can0 inet manual
    pre-up /sbin/ip link set $IFACE type can bitrate 500000
    up /sbin/ifconfig $IFACE up
    down /sbin/ifconfig $IFACE down
```

### 6. Build and Install Dashboard Application

```bash
# Clone repository
cd ~
git clone https://github.com/DelaneyMotorsports/Z33_UI.git
cd Z33_UI

# Build with qmake
qmake Z33_UI.pro
make -j4

# Run application
./Z33_UI
```

### 7. Performance Optimization

#### Enable Hardware Acceleration

```bash
sudo raspi-config
```

Navigate to **Advanced Options → GL Driver → GL (Full KMS)**

#### Overclock (Optional, for better performance)

```bash
sudo nano /boot/config.txt
```

Add (conservative overclock):
```
# Raspberry Pi 5 overclock
arm_freq=2600
gpu_freq=900
over_voltage=6
```

**Warning**: Ensure adequate cooling (heatsink + fan)

### 8. Auto-Start Configuration

#### Method A: Desktop Autostart

```bash
mkdir -p ~/.config/autostart
nano ~/.config/autostart/delaney-dashboard.desktop
```

Add:
```
[Desktop Entry]
Type=Application
Name=Delaney Dashboard
Exec=/home/pi/Z33_UI/Z33_UI
```

#### Method B: Systemd Service (Production)

```bash
sudo nano /etc/systemd/system/delaney-dashboard.service
```

Add:
```
[Unit]
Description=Delaney Motorsports Dashboard
After=graphical.target

[Service]
Type=simple
User=pi
Environment=DISPLAY=:0
Environment=QT_QPA_PLATFORM=eglfs
ExecStart=/home/pi/Z33_UI/Z33_UI
Restart=always
RestartSec=5

[Install]
WantedBy=graphical.target
```

Enable service:
```bash
sudo systemctl daemon-reload
sudo systemctl enable delaney-dashboard.service
sudo systemctl start delaney-dashboard.service
```

---

## NVIDIA Jetson Setup

### 1. JetPack Installation

#### Download JetPack SDK

1. Visit: https://developer.nvidia.com/embedded/jetpack
2. Download JetPack SDK matching your Jetson model
3. Flash image using NVIDIA SDK Manager or Balena Etcher

#### Initial Setup

```bash
# Update system
sudo apt update
sudo apt upgrade -y

# Install development tools
sudo apt install -y \
    build-essential \
    git \
    cmake \
    pkg-config
```

### 2. Qt Installation on Jetson

#### Install from Repository

```bash
sudo apt install -y \
    qt5-default \
    qtdeclarative5-dev \
    qtmultimedia5-dev \
    qml-module-qtquick2 \
    qml-module-qtquick-controls2 \
    qml-module-qtquick-layouts \
    libqt5multimedia5-plugins \
    qtwayland5
```

#### Configure for GPU Acceleration

```bash
# Verify GPU acceleration
nvidia-smi

# Set environment variables
echo 'export QT_QPA_EGLFS_INTEGRATION=eglfs_kms' >> ~/.bashrc
echo 'export QT_QPA_PLATFORM=eglfs' >> ~/.bashrc
source ~/.bashrc
```

### 3. Display Configuration

#### For HDMI Displays

Edit X11 configuration:
```bash
sudo nano /etc/X11/xorg.conf
```

Set resolution in "Screen" section:
```
Section "Screen"
    Identifier     "Screen0"
    Device         "Device0"
    Monitor        "Monitor0"
    DefaultDepth    24
    SubSection     "Display"
        Depth       24
        Modes      "1920x1080"
    EndSubSection
EndSection
```

### 4. CAN Bus Setup (Jetson)

Install SocketCAN:
```bash
sudo apt install -y can-utils
sudo modprobe can
sudo modprobe can_raw
```

For USB CAN adapters:
```bash
sudo ip link set can0 up type can bitrate 500000
```

### 5. Build Dashboard Application

```bash
# Clone repository
cd ~
git clone https://github.com/DelaneyMotorsports/Z33_UI.git
cd Z33_UI

# Build
qmake Z33_UI.pro
make -j$(nproc)

# Run
./Z33_UI
```

### 6. Jetson Performance Optimization

#### Maximize Performance Mode

```bash
# Set maximum performance
sudo nvpmodel -m 0
sudo jetson_clocks

# Verify status
sudo nvpmodel -q
```

#### GPU Monitoring

```bash
# Monitor GPU usage
watch -n 1 nvidia-smi

# Detailed stats
tegrastats
```

### 7. Auto-Start on Jetson

Create systemd service (same as Raspberry Pi method):

```bash
sudo nano /etc/systemd/system/delaney-dashboard.service
```

```
[Unit]
Description=Delaney Motorsports Dashboard
After=graphical.target

[Service]
Type=simple
User=nvidia
Environment=DISPLAY=:0
Environment=QT_QPA_PLATFORM=eglfs
ExecStart=/home/nvidia/Z33_UI/Z33_UI
Restart=always
RestartSec=5

[Install]
WantedBy=graphical.target
```

Enable:
```bash
sudo systemctl enable delaney-dashboard.service
sudo systemctl start delaney-dashboard.service
```

---

## Display Recommendations

### Budget Option (Raspberry Pi)

**Raspberry Pi Official 7" Touch Display**
- Resolution: 800x480
- Touch: 10-point capacitive
- Connection: DSI ribbon cable
- Price: ~$70

### Mid-Range Option

**Waveshare 10.1" HDMI LCD (H)**
- Resolution: 1920x1080
- Touch: Capacitive
- Connection: HDMI + USB touch
- Price: ~$100-150

### Professional Option

**Automotive-Grade OLED Display**
- Resolution: 1920x1080 or higher
- Technology: AMOLED/OLED
- Brightness: 600+ nits
- Temperature Range: -20°C to +70°C
- Price: $300-800 (from automotive suppliers)

---

## Sensor Integration

### Accelerometer / Gyroscope (I2C)

**Recommended**: MPU6050, MPU9250

```bash
# Detect I2C device
sudo i2cdetect -y 1

# Install library
git clone https://github.com/jrowberg/i2cdevlib.git
```

Integrate with CarInterface in C++.

### GPS Module

**Recommended**: U-blox NEO-M8N

```bash
# Install gpsd
sudo apt install -y gpsd gpsd-clients

# Configure
sudo dpkg-reconfigure gpsd
```

### CAN Bus Adapter

**Recommended**:
- MCP2515 CAN HAT (Raspberry Pi)
- PEAK PCAN-USB (USB adapter)
- Kvaser Leaf Light (professional option)

---

## Troubleshooting

### Display Issues

**Problem**: No display output
- Check HDMI cable connection
- Verify config.txt settings
- Try forcing HDMI: `hdmi_force_hotplug=1`

**Problem**: Touch not working
- Check USB connection for touch interface
- Verify touch driver installation
- Calibrate touch: `sudo apt install xinput-calibrator`

### Performance Issues

**Problem**: Low frame rate
- Enable GPU acceleration
- Check CPU/GPU temperature: `vcgencmd measure_temp`
- Verify no CPU throttling: `vcgencmd get_throttled`
- Add cooling (heatsink + fan)

**Problem**: Application crashes
- Check Qt version compatibility
- Verify all QML modules installed
- Review application logs: `journalctl -u delaney-dashboard`

### CAN Bus Issues

**Problem**: CAN interface not detected
- Verify SPI enabled in config.txt
- Check physical connections
- Test with `candump can0`

---

## Production Deployment Checklist

- [ ] OS installed and updated
- [ ] Qt framework installed and tested
- [ ] Display configured and calibrated
- [ ] Touch input verified (if applicable)
- [ ] Sensors connected and tested
- [ ] CAN bus / OBD-II interface configured
- [ ] Application builds without errors
- [ ] Auto-start configured
- [ ] Performance optimized
- [ ] Cooling solution installed
- [ ] Power supply tested (automotive voltage range)
- [ ] Watchdog timer configured
- [ ] Backup/recovery mechanism in place

---

## Support and Resources

### Documentation
- Qt Documentation: https://doc.qt.io/
- Raspberry Pi Documentation: https://www.raspberrypi.com/documentation/
- NVIDIA Jetson Documentation: https://developer.nvidia.com/embedded/learn/getting-started

### Community
- Delaney Motorsports Support: [Kevin@DelaneyMotorsports.com](mailto:Kevin@DelaneyMotorsports.com)
- GitHub Issues: https://github.com/DelaneyMotorsports/Z33_UI/issues

---

## Conclusion

This hardware setup guide provides comprehensive instructions for deploying the Delaney Motorsports DDU11 Dashboard on embedded platforms. For additional assistance, detailed troubleshooting, or custom integration support, contact our engineering team.

**Kevin Delaney**
Director of Research and Development
Delaney Motorsports, LLC
Sarasota, Florida
[Kevin@DelaneyMotorsports.com](mailto:Kevin@DelaneyMotorsports.com)
