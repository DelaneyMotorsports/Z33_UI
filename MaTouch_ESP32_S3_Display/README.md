/*!
    @file    README.md
    @brief   MaTouch ESP32-S3 2.1" Auxiliary Gauge Configuration

    Configuration and interface files for the MaTouch ESP32-S3 Rotary IPS Display
    with Touch 2.1" (ST7701 driver). Designed as a professional motorsport auxiliary
    gauge for A-pillar or dashboard mounting.

    @author  Kevin Delaney
    @date    January 8, 2026
    @company Delaney Motorsports, LLC
    @address Sarasota, FL
*/

# MaTouch ESP32-S3 Auxiliary Gauge

## Display Specifications

**Hardware**: MaTouch ESP32-S3 Rotary IPS Display with Touch 2.1"
**Driver**: ST7701
**Resolution**: 480x480 pixels
**Size**: 2.1 inch diagonal
**Touch**: Capacitive touch
**MCU**: ESP32-S3 with WiFi/Bluetooth

## Purpose

This auxiliary gauge is designed for A-pillar or dashboard mounting, providing at-a-glance
critical telemetry data without distracting from the main dashboard display. Ideal for
motorsports applications where specific parameters need constant monitoring.

## Available Gauge Modes

1. **RPM Gauge** - Tachometer with shift light
2. **Boost Pressure** - Turbo/supercharger boost gauge
3. **Oil Pressure** - Critical oil pressure monitoring
4. **Water Temperature** - Coolant temperature gauge
5. **Oil Temperature** - Engine oil temp monitoring
6. **Fuel Pressure** - Fuel system pressure
7. **AFR (Air/Fuel Ratio)** - Mixture monitoring
8. **G-Force** - Lateral and longitudinal acceleration

## Interface Files

- `rpm_gauge.qml` - Tachometer with redline warning
- `boost_gauge.qml` - Boost pressure (PSI/bar)
- `oil_pressure_gauge.qml` - Oil pressure monitoring
- `water_temp_gauge.qml` - Coolant temperature
- `oil_temp_gauge.qml` - Oil temperature
- `fuel_pressure_gauge.qml` - Fuel system pressure
- `afr_gauge.qml` - Air/fuel ratio display
- `gforce_gauge.qml` - G-force meter

## Integration

### ESP32-S3 Configuration

Connect to main dashboard via:
- **WiFi** - Wireless telemetry data reception
- **CAN Bus** - Direct vehicle data connection
- **Serial** - UART communication with main system

### Data Protocol

The gauge receives JSON data packets over WiFi or serial:

```json
{
  "rpm": 5500,
  "boost": 12.5,
  "oilPressure": 45.2,
  "waterTemp": 195,
  "oilTemp": 210,
  "fuelPressure": 43.5,
  "afr": 14.7,
  "gforce": {"lateral": 0.8, "longitudinal": 0.5}
}
```

## Mounting

**A-Pillar Mount**:
- Quick-glance visibility
- Minimal driver distraction
- Professional motorsport appearance

**Dashboard Mount**:
- Secondary gauge cluster
- Triple-gauge pods compatible
- Custom mounting solutions

## Installation

### Hardware Setup

1. Power ESP32-S3 from 12V vehicle power (via buck converter to 5V USB-C)
2. Connect to vehicle CAN bus or main dashboard system
3. Mount display in A-pillar pod or dashboard location
4. Configure WiFi credentials for wireless data

### Software Setup

1. Flash ESP32-S3 with gauge firmware
2. Configure gauge mode (RPM, boost, etc.)
3. Set warning thresholds
4. Test data reception and display

## Configuration

Edit `config.json` to set gauge parameters:

```json
{
  "mode": "rpm",
  "maxValue": 8000,
  "warningThreshold": 6500,
  "redline": 7500,
  "units": "RPM",
  "wifiSSID": "DelaneyDashboard",
  "wifiPassword": "motorsports2026"
}
```

## Contact

For questions about MaTouch gauge configuration or custom gauge development:

**Kevin Delaney**
Director of Research and Development
Delaney Motorsports, LLC
[Kevin@DelaneyMotorsports.com](mailto:Kevin@DelaneyMotorsports.com)
