/*!
    @file    DEPLOYMENT.md
    @brief   Production deployment guide for Delaney Motorsports DDU11 Dashboard

    This document provides comprehensive guidance for deploying the Delaney Motorsports
    digital dashboard in production automotive and motorsports environments. Covers
    production builds, system hardening, reliability considerations, environmental
    factors, power management, and integration with vehicle electrical systems.

    @author  Kevin Delaney
    @date    January 8, 2026
    @company Delaney Motorsports, LLC
    @address Sarasota, FL
*/

# Production Deployment Guide

## Overview

Deploying a digital dashboard in a vehicle environment requires careful attention to reliability, environmental conditions, power management, and fail-safe operation. This guide provides comprehensive instructions for production-ready deployments in both motorsports and luxury automotive applications.

---

## Production Build Configuration

### Optimization Flags

For production deployment, build the application with release optimizations:

```bash
# Release build with optimizations
qmake CONFIG+=release Z33_UI.pro
make -j$(nproc)

# Strip debug symbols to reduce binary size
strip Z33_UI
```

### Qt Release Configuration

Edit `Z33_UI.pro` for production:

```qmake
# Production configuration
CONFIG += release
CONFIG -= debug

# Optimization flags
QMAKE_CXXFLAGS_RELEASE += -O3 -march=native

# Remove debug output in release
DEFINES += QT_NO_DEBUG_OUTPUT QT_NO_WARNING_OUTPUT

# Link-time optimization
QMAKE_LFLAGS_RELEASE += -flto
```

### Static Linking (Optional)

For self-contained deployment without Qt dependencies:

```bash
# Build Qt statically (advanced)
./configure -static -release -opensource -confirm-license
make -j$(nproc)

# Build application with static Qt
qmake CONFIG+=static Z33_UI.pro
make
```

**Pros**: Single binary, no dependencies
**Cons**: Large binary size, longer build times

---

## System Hardening

### Read-Only Root Filesystem

For production reliability, configure root filesystem as read-only:

```bash
# Edit fstab
sudo nano /etc/fstab
```

Change root mount to read-only:
```
/dev/mmcblk0p2  /  ext4  defaults,ro  0  1
```

Create writable overlay for logs:
```bash
# Create tmpfs for temporary writes
tmpfs  /tmp  tmpfs  defaults,noatime,mode=1777  0  0
tmpfs  /var/log  tmpfs  defaults,noatime,mode=0755  0  0
```

### Disable Unnecessary Services

Reduce attack surface and improve boot time:

```bash
# Disable unnecessary services
sudo systemctl disable bluetooth.service
sudo systemctl disable cups.service
sudo systemctl disable avahi-daemon.service
sudo systemctl disable ModemManager.service

# Keep essential services only
sudo systemctl enable systemd-timesyncd.service
sudo systemctl enable delaney-dashboard.service
```

### Automatic System Updates

Configure unattended security updates:

```bash
sudo apt install unattended-upgrades
sudo dpkg-reconfigure -plow unattended-upgrades
```

### Watchdog Timer

Configure hardware watchdog for automatic recovery:

```bash
# Enable watchdog
sudo modprobe bcm2835_wdt  # For Raspberry Pi
echo "bcm2835_wdt" | sudo tee -a /etc/modules

# Install watchdog daemon
sudo apt install watchdog

# Configure watchdog
sudo nano /etc/watchdog.conf
```

Add:
```
watchdog-device = /dev/watchdog
max-load-1 = 24
min-memory = 1
watchdog-timeout = 15
```

Enable:
```bash
sudo systemctl enable watchdog
sudo systemctl start watchdog
```

---

## Boot Configuration

### Fast Boot Setup

Optimize boot time for automotive applications:

#### Reduce Boot Delay

```bash
sudo nano /boot/cmdline.txt
```

Add `quiet` and remove unnecessary checks:
```
console=serial0,115200 console=tty3 root=/dev/mmcblk0p2 rootfstype=ext4 elevator=deadline fsck.repair=yes rootwait quiet logo.nologo
```

#### Disable Splash Screen Services

```bash
sudo systemctl disable plymouth.service
sudo systemctl disable plymouth-quit-wait.service
```

#### Optimize systemd

```bash
sudo nano /etc/systemd/system.conf
```

Add:
```
DefaultTimeoutStartSec=10s
DefaultTimeoutStopSec=5s
```

### Auto-Login and Auto-Start

#### Console Auto-Login

```bash
sudo systemctl edit getty@tty1
```

Add:
```
[Service]
ExecStart=
ExecStart=-/sbin/agetty --autologin pi --noclear %I $TERM
Type=idle
```

#### Systemd Service (Recommended)

Create production service:

```bash
sudo nano /etc/systemd/system/delaney-dashboard.service
```

```ini
[Unit]
Description=Delaney Motorsports Digital Dashboard
After=graphical.target network-online.target
Wants=network-online.target
StartLimitIntervalSec=0

[Service]
Type=simple
User=pi
Group=pi
Environment=DISPLAY=:0
Environment=XDG_RUNTIME_DIR=/run/user/1000
Environment=QT_QPA_PLATFORM=eglfs
Environment=QT_QPA_EGLFS_PHYSICAL_WIDTH=255
Environment=QT_QPA_EGLFS_PHYSICAL_HEIGHT=145
ExecStartPre=/bin/sleep 2
ExecStart=/usr/local/bin/Z33_UI
Restart=always
RestartSec=3
StandardOutput=journal
StandardError=journal

# Watchdog
WatchdogSec=30s

# Resource limits
MemoryLimit=512M
CPUQuota=85%

[Install]
WantedBy=graphical.target
```

Enable:
```bash
sudo systemctl daemon-reload
sudo systemctl enable delaney-dashboard.service
sudo systemctl start delaney-dashboard.service
```

---

## Environmental Considerations

### Operating Temperature Range

**Standard Raspberry Pi 5**: 0°C to 50°C
**Industrial variants**: -40°C to +85°C
**NVIDIA Jetson**: -25°C to +80°C (varies by model)

### Thermal Management

#### Passive Cooling

Minimum requirement:
- Aluminum heatsink with thermal adhesive
- Adequate airflow ventilation

#### Active Cooling

For enclosed installations:
```bash
# Install fan control
sudo apt install fancontrol

# Configure temperature-based fan control
sudo pwmconfig
```

Create thermal monitoring:
```bash
sudo nano /usr/local/bin/thermal-monitor.sh
```

```bash
#!/bin/bash
TEMP_LIMIT=70000  # 70°C in millidegrees
CURRENT_TEMP=$(cat /sys/class/thermal/thermal_zone0/temp)

if [ $CURRENT_TEMP -gt $TEMP_LIMIT ]; then
    # Reduce CPU frequency
    echo "powersave" | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
    # Turn on fan full speed
    echo 255 | sudo tee /sys/class/hwmon/hwmon0/pwm1
fi
```

Add to crontab:
```bash
*/1 * * * * /usr/local/bin/thermal-monitor.sh
```

### Vibration Resistance

**Mounting Considerations**:
- Use vibration-damping mounts
- Secure all connections with strain relief
- Use industrial MicroSD cards (SLC NAND)
- Consider eMMC or M.2 SSD over SD cards for motorsports

**Recommended Storage**:
- **Development**: Standard MicroSD card
- **Production**: Industrial-grade MicroSD (SanDisk Industrial, Samsung PRO Endurance)
- **Motorsports**: M.2 SSD with adapter (no moving parts, better vibration resistance)

### Humidity and Moisture

**Protection Methods**:
- Conformal coating on PCB
- IP-rated enclosure (IP65 minimum for automotive)
- Desiccant packs in enclosure
- Sealed connectors (automotive-grade)

---

## Power Management

### Automotive Power Supply

**12V DC Input Requirements**:
- Input voltage range: 9V - 16V DC (accommodates voltage fluctuations)
- Transient protection: Essential for automotive environment
- Reverse polarity protection
- EMI filtering

**Recommended Power Supply**:
- Automotive-grade DC-DC converter
- Input: 12V automotive (9-16V tolerance)
- Output: 5V 5A (for Raspberry Pi 5) or 19V for Jetson
- Protection: Over-voltage, under-voltage, over-current, thermal

**Example: Raspberry Pi 5 Power Circuit**
```
Vehicle 12V → Automotive Fuse (5A) → DC-DC Buck Converter (5V 5A) → USB-C Power Delivery → Raspberry Pi 5
```

### Ignition Sensing

Implement automatic power-on with vehicle ignition:

#### Hardware Method

Use automotive relay triggered by ignition:
```
Ignition +12V → Relay Coil → Relay NO Contact → System Power
```

#### Software Method

Monitor GPIO for ignition signal:

```python
#!/usr/bin/env python3
import RPi.GPIO as GPIO
import subprocess
import time

IGNITION_PIN = 17  # GPIO pin connected to ignition signal

GPIO.setmode(GPIO.BCM)
GPIO.setup(IGNITION_PIN, GPIO.IN, pull_up_down=GPIO.PUD_DOWN)

def ignition_on():
    subprocess.run(['systemctl', 'start', 'delaney-dashboard.service'])

def ignition_off():
    subprocess.run(['systemctl', 'stop', 'delaney-dashboard.service'])
    time.sleep(5)
    subprocess.run(['shutdown', '-h', 'now'])

while True:
    if GPIO.input(IGNITION_PIN):
        ignition_on()
        GPIO.wait_for_edge(IGNITION_PIN, GPIO.FALLING)
        ignition_off()
    time.sleep(1)
```

### Graceful Shutdown

Implement delayed shutdown after ignition off:

```bash
sudo nano /usr/local/bin/delayed-shutdown.sh
```

```bash
#!/bin/bash
# Wait 2 minutes after ignition off before shutdown
sleep 120

# Check if vehicle is still off
if [ $(gpio read 17) -eq 0 ]; then
    # Sync filesystem
    sync
    # Shutdown
    shutdown -h now
fi
```

### Battery Protection

Implement low-voltage cutoff to prevent battery drain:

```python
#!/usr/bin/env python3
import time
import subprocess

VOLTAGE_PIN = 0  # ADC channel reading 12V supply (via voltage divider)
LOW_VOLTAGE_THRESHOLD = 11.5  # Volts

def read_voltage():
    # Read from ADC (implementation depends on hardware)
    # Example for MCP3008 ADC
    return read_adc_voltage(VOLTAGE_PIN)

while True:
    voltage = read_voltage()
    if voltage < LOW_VOLTAGE_THRESHOLD:
        # Trigger immediate shutdown
        subprocess.run(['wall', 'Low battery - shutting down'])
        subprocess.run(['shutdown', '-h', 'now'])
    time.sleep(10)
```

---

## Data Integrity and Logging

### Filesystem Journaling

Use ext4 with journaling for data integrity:

```bash
sudo tune2fs -l /dev/mmcblk0p2 | grep features
# Verify "has_journal" is present
```

### Application Logging

Configure structured logging:

```cpp
// In main.cpp
QLoggingCategory::setFilterRules(
    "*.debug=false\n"
    "delaney.dashboard.critical=true\n"
    "delaney.dashboard.warning=true"
);

// Redirect logs to file
qInstallMessageHandler(customMessageHandler);
```

### Log Rotation

Configure logrotate for application logs:

```bash
sudo nano /etc/logrotate.d/delaney-dashboard
```

```
/var/log/delaney-dashboard/*.log {
    daily
    missingok
    rotate 7
    compress
    delaycompress
    notifempty
    create 0644 pi pi
    sharedscripts
    postrotate
        systemctl reload delaney-dashboard > /dev/null 2>&1 || true
    endscript
}
```

---

## CAN Bus Integration

### Production CAN Configuration

#### Hardware Setup

**Recommended CAN Interfaces**:
- **Raspberry Pi**: MCP2515 CAN HAT or Waveshare RS485 CAN HAT
- **Jetson**: PEAK PCAN-USB or Kvaser Leaf Light
- **Professional**: Vector CANcase or ETAS ES910

#### Configure SocketCAN

```bash
# Load CAN modules
sudo modprobe can
sudo modprobe can_raw
sudo modprobe mcp251x  # For MCP2515

# Configure CAN interface
sudo ip link set can0 type can bitrate 500000
sudo ip link set can0 up

# Make persistent
sudo nano /etc/network/interfaces.d/can0
```

```
auto can0
iface can0 can static
    bitrate 500000
    up ip link set $IFACE up
    down ip link set $IFACE down
```

#### CAN Message Filtering

Implement efficient CAN filtering in application:

```cpp
// In CarInterface.cpp
void CarInterface::setupCANInterface() {
    m_canSocket = socket(PF_CAN, SOCK_RAW, CAN_RAW);

    // Set up filters for specific CAN IDs
    struct can_filter rfilter[3];
    rfilter[0].can_id   = 0x100;  // Engine RPM
    rfilter[0].can_mask = CAN_SFF_MASK;
    rfilter[1].can_id   = 0x200;  // Speed
    rfilter[1].can_mask = CAN_SFF_MASK;
    rfilter[2].can_id   = 0x300;  // Oil pressure
    rfilter[2].can_mask = CAN_SFF_MASK;

    setsockopt(m_canSocket, SOL_CAN_RAW, CAN_RAW_FILTER,
               &rfilter, sizeof(rfilter));
}
```

---

## OBD-II Integration

### OBD-II Adapters

**Supported Interfaces**:
- ELM327 Bluetooth/WiFi adapters (consumer-grade)
- OBDLink MX+ (professional-grade)
- Carloop (embedded OBD-II with CAN)

### OBD-II Software Integration

Install Python OBD library:

```bash
sudo apt install python3-pip
pip3 install obd
```

Create OBD bridge service:

```python
#!/usr/bin/env python3
import obd
import socket
import json
import time

# Connect to OBD-II
connection = obd.OBD()

# Create UDP socket for local communication
sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
server_address = ('localhost', 10000)

while True:
    # Query OBD-II
    speed = connection.query(obd.commands.SPEED)
    rpm = connection.query(obd.commands.RPM)
    coolant = connection.query(obd.commands.COOLANT_TEMP)

    # Send data to dashboard application
    data = {
        'speed': speed.value.magnitude if speed.value else 0,
        'rpm': rpm.value.magnitude if rpm.value else 0,
        'coolant_temp': coolant.value.magnitude if coolant.value else 0
    }

    sock.sendto(json.dumps(data).encode(), server_address)
    time.sleep(0.1)  # 10 Hz update rate
```

---

## Network Configuration

### WiFi AP Mode (For Configuration)

Create access point for wireless configuration:

```bash
# Install hostapd and dnsmasq
sudo apt install hostapd dnsmasq

# Configure hostapd
sudo nano /etc/hostapd/hostapd.conf
```

```
interface=wlan0
driver=nl80211
ssid=DelaneyDashboard
hw_mode=g
channel=7
wmm_enabled=0
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
wpa=2
wpa_passphrase=delaney2026
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
rsn_pairwise=CCMP
```

### Remote Monitoring (Optional)

For telemetry and remote diagnostics:

```bash
# Install VPN client (WireGuard)
sudo apt install wireguard

# Configure VPN for secure remote access
sudo nano /etc/wireguard/wg0.conf
```

---

## Testing and Validation

### Pre-Deployment Checklist

- [ ] Application builds without errors
- [ ] All dependencies installed
- [ ] Auto-start configured and tested
- [ ] Display output verified
- [ ] Touch input functional (if applicable)
- [ ] CAN bus communication verified
- [ ] Power supply tested (9-16V range)
- [ ] Thermal performance validated
- [ ] Vibration resistance tested
- [ ] Fail-safe behavior verified
- [ ] Watchdog timer functional
- [ ] Graceful shutdown tested
- [ ] Boot time acceptable (<30 seconds)
- [ ] Logs configured and rotating
- [ ] Backup/recovery procedure documented

### Bench Testing

Before vehicle installation:

1. **Power Cycle Testing**: 100+ power cycles without failure
2. **Temperature Testing**: Operation across full temperature range
3. **Vibration Testing**: Simulate vehicle vibration (if equipment available)
4. **Extended Runtime**: 24+ hour continuous operation
5. **CAN Message Injection**: Verify correct data parsing
6. **Failure Modes**: Test watchdog, low voltage cutoff, sensor failures

### In-Vehicle Testing

1. **Engine off, ignition on**: Verify display powers up
2. **Engine start**: Verify no power glitches or resets
3. **Normal driving**: Verify all gauges update correctly
4. **High RPM operation**: Verify shift lights and warnings
5. **Ignition off**: Verify graceful shutdown
6. **Cold start**: Test at low temperature (if applicable)

---

## Maintenance and Updates

### Remote Update Procedure

For deployed systems, implement OTA updates:

```bash
#!/bin/bash
# remote-update.sh

# Download new version
wget https://updates.delaneymotorsports.com/Z33_UI_latest.tar.gz

# Verify checksum
sha256sum -c Z33_UI_latest.tar.gz.sha256

# Stop service
sudo systemctl stop delaney-dashboard

# Backup current version
sudo cp /usr/local/bin/Z33_UI /usr/local/bin/Z33_UI.backup

# Extract and install
tar -xzf Z33_UI_latest.tar.gz
sudo cp Z33_UI /usr/local/bin/

# Restart service
sudo systemctl start delaney-dashboard

# Verify
sleep 5
sudo systemctl status delaney-dashboard
```

### Configuration Backup

```bash
# Backup configuration
sudo rsync -av /home/pi/Z33_UI/ /mnt/backup/Z33_UI_$(date +%Y%m%d)/

# Backup to cloud (optional)
rclone sync /home/pi/Z33_UI/ remote:backups/Z33_UI/
```

---

## Safety and Compliance

### Automotive Safety Standards

For commercial automotive applications:

- **ISO 26262**: Functional safety for automotive systems
- **ASPICE**: Automotive Software Process Improvement
- **MISRA C++**: Coding standards for safety-critical systems
- **EMC Compliance**: Electromagnetic compatibility (FCC, CE)

### Display Safety

- **Brightness**: Adjustable for night driving (prevent distraction)
- **Glare**: Anti-glare screen coating
- **Color**: Red-shift for night vision preservation
- **Warnings**: Critical warnings must be immediately visible
- **Position**: Mount within driver's field of view without obstruction

### Legal Considerations

- **Driver Distraction**: Ensure display does not distract from driving
- **Speedometer Accuracy**: If replacing OEM speedometer, ensure accuracy
- **Emissions Compliance**: CAN bus modifications must not affect emissions
- **Warranty**: Consider impact on vehicle warranty

---

## Troubleshooting Production Issues

### Common Issues and Solutions

**Issue**: Display not starting after ignition on
- Check power supply voltage
- Verify systemd service status
- Check application logs

**Issue**: Intermittent crashes
- Check temperature (thermal throttling)
- Verify memory usage (increase if needed)
- Review crash logs in `/var/log/`

**Issue**: CAN bus data not received
- Verify CAN termination resistors
- Check bitrate configuration
- Test with `candump can0`

**Issue**: Touch screen unresponsive
- Recalibrate touch: `DISPLAY=:0 xinput_calibrator`
- Check USB connection
- Verify touch driver loaded

---

## Support and Professional Services

### Delaney Motorsports Support

For production deployment support:
- System integration assistance
- Custom hardware design
- Professional installation services
- Extended support contracts
- Training and documentation

**Contact**:
Kevin Delaney
Director of Research and Development
Delaney Motorsports, LLC
Sarasota, Florida
[Kevin@DelaneyMotorsports.com](mailto:Kevin@DelaneyMotorsports.com)

---

## Conclusion

Production deployment of automotive display systems requires careful attention to reliability, environmental factors, and safety. This guide provides comprehensive instructions for professional-grade installations suitable for both motorsports and luxury automotive applications.

Following these guidelines ensures a robust, reliable system that meets the demanding requirements of automotive environments.
