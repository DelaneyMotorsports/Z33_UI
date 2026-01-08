# Delaney Motorsports DDU11 Digital Dashboard UI

**A Bosch Motorsports DDU11-Inspired Display System**

Welcome to the Delaney Motorsports Digital Dashboard UI Project, a professional-grade automotive display system inspired by the legendary Bosch Motorsports DDU11. This project delivers a cutting-edge driver information system designed to rival modern luxury vehicles like the 2026 Range Rover, featuring high-resolution AMOLED/OLED displays and advanced telemetry visualization.

Built on Qt Quick and QML, this system provides race-proven functionality with luxury vehicle aesthetics, suitable for both motorsports applications and high-end custom automotive installations.

---

## Project Overview

### Design Philosophy

This dashboard system combines the precision and functionality of professional motorsports data acquisition displays with the refined aesthetics expected in modern luxury vehicles. The interface is designed for:

- **High-performance motorsports applications** - Real-time telemetry, lap timing, and performance metrics
- **Luxury vehicle installations** - Elegant design language comparable to 2026-era premium automotive displays
- **Aftermarket enhancement** - Professional-grade instrumentation for automotive enthusiasts

### Hardware Platform

The system is designed to run on readily available, powerful embedded computing platforms:

#### Supported Hardware

- **Raspberry Pi 5** (4GB/8GB RAM recommended)
  - ARM Cortex-A76 quad-core processor
  - Support for dual 4K displays via HDMI
  - GPIO for sensor integration
  - Excellent price-to-performance ratio

- **NVIDIA Jetson Developer Kits** (Jetson Nano, Xavier NX, Orin Nano)
  - Hardware-accelerated GPU rendering
  - Superior graphics performance for complex UI elements
  - AI/ML capabilities for future enhancements
  - Industrial-grade reliability

#### Display Requirements

For optimal visual quality and authenticity to modern luxury vehicle standards:

- **Resolution**: 1920x1080 (1080p) minimum, 2K/4K capable
- **Display Technology**: AMOLED or OLED preferred for deep blacks and vibrant colors
- **Brightness**: 500+ nits for daylight visibility
- **Touch Capability**: Capacitive multi-touch recommended
- **Aspect Ratio**: 16:9 or 21:9 widescreen formats

**Recommended Display Options**:
- Waveshare 10.1" 1920x1200 IPS DSI Display
- Official Raspberry Pi Touch Display (7" for compact builds)
- Custom HDMI OLED panels (available from automotive display suppliers)

---

## Core Features

This project includes professional-grade features tailored for motorsports and luxury automotive applications:

### Performance Monitoring

- **Multi-Gauge Display System**: Configurable digital gauges for speed, RPM, fuel efficiency, and more
- **Oil Pressure Monitoring**: Real-time oil pressure gauge with configurable warning thresholds
- **Voltage Monitoring**: System voltage display for electrical system health
- **Speed Display**: High-visibility digital speedometer with customizable units

### Motorsports Features

- **Lap Timer Display**: Professional lap timing system with current, last, and best lap tracking
- **Shift Light Indicator**: Configurable RPM-based shift indicators
- **G-Force Display**: Real-time acceleration metrics (with accelerometer integration)
- **Stopwatch Function**: Independent timing for performance testing

### Navigation and Information

- **Compass Display**: Digital heading indicator
- **Range Display**: Fuel range estimation based on current consumption
- **MPG Display**: Real-time and average fuel efficiency tracking

### Advanced Features

- **Feature Displays (U/V/W/X/Y/Z)**: Modular display components for custom telemetry integration
- **Qt Safe Renderer Integration**: Safety-critical UI elements that remain visible even during system failures
- **Stellar Sky Roof**: Ambient ceiling display for luxury installations
- **Holographic HUD Integration**: Support for heads-up display projection systems
- **Dynamic Acoustic Environment**: Audio experience customization
- **Ambient Wellness Monitor**: Interior environment optimization
- **Sensory Climate Control**: Advanced climate management interface

---

## System Architecture

The system is built on a modular Qt/QML architecture:

- **CarInterface (C++)**: Data acquisition and management backend
- **QML Components**: Modular UI widgets for each display function
- **Signal/Slot Architecture**: Real-time data binding between sensors and displays
- **Qt Safe Renderer**: Fail-safe critical information display

For detailed architectural documentation, see [ARCHITECTURE.md](ARCHITECTURE.md).

---

## Installation

### Prerequisites

- **Qt 5.15 or Qt 6.x** with the following modules:
  - Qt Quick
  - Qt QML
  - Qt Multimedia
  - Qt Safe Renderer (for safety-critical features)
- **C++11 compatible compiler** (GCC 6.3.0 or newer)
- **Target hardware** (Raspberry Pi 5 or NVIDIA Jetson)

### Quick Start

1. **Clone the repository**:
   ```bash
   git clone https://github.com/DelaneyMotorsports/Z33_UI.git
   cd Z33_UI
   ```

2. **Install Qt dependencies** (for Raspberry Pi/Debian-based systems):
   ```bash
   sudo apt-get update
   sudo apt-get install qt5-default qtdeclarative5-dev qtmultimedia5-dev
   ```

3. **Build the project**:
   ```bash
   qmake Z33_UI.pro
   make
   ```

4. **Run the application**:
   ```bash
   ./Z33_UI
   ```

For detailed hardware-specific setup instructions, see [HARDWARE_SETUP.md](HARDWARE_SETUP.md).

---

## Usage

The Delaney Motorsports Dashboard supports multiple interaction methods:

- **Touchscreen Interface**: Direct interaction with gauges and displays
- **Physical Controls**: Integration with steering wheel buttons or dashboard controls
- **CAN Bus Integration**: Direct connection to vehicle data networks
- **OBD-II Integration**: Standard automotive diagnostic port connectivity

### Configuration

The system supports extensive customization:

- Display themes and color schemes
- Unit systems (imperial/metric)
- Warning thresholds for gauges
- Layout configuration for different screen sizes
- Data source mapping for various vehicle platforms

---

## Hardware Integration

### Sensor Connectivity

The system supports multiple data acquisition methods:

- **CAN Bus**: Direct integration with motorsports ECUs and vehicle networks
- **OBD-II**: Standard automotive diagnostic protocols
- **Analog Sensors**: GPIO-based analog sensor reading (RPi 5)
- **I2C/SPI Sensors**: Accelerometers, gyroscopes, GPS modules
- **Serial Communication**: RS-232/RS-485 for legacy systems

### Raspberry Pi 5 Setup

For Raspberry Pi 5 deployment:
- Utilize GPIO for direct sensor connections
- Configure I2C for accelerometer/gyroscope
- Enable DSI/HDMI for display output
- Configure boot-to-application for production use

### NVIDIA Jetson Setup

For Jetson platform deployment:
- Leverage CUDA-accelerated rendering
- Configure GPIO/I2C for sensor integration
- Enable display manager for auto-start
- Optimize power management for automotive use

Detailed hardware setup guides are available in [HARDWARE_SETUP.md](HARDWARE_SETUP.md).

---

## Component Documentation

For detailed documentation on each UI component, see [COMPONENTS.md](COMPONENTS.md).

Key components include:
- `main.qml` - Primary application window and layout
- `CarInterface.h/cpp` - Data acquisition backend
- `MultiGauge.qml` - Multi-function gauge display
- `LapTimerDisplay.qml` - Motorsports lap timing
- `SpeedDisplay.qml` - Digital speedometer
- `safeUI.qml` - Safety-critical display elements

---

## Deployment

For production deployment to vehicles and motorsports applications, see [DEPLOYMENT.md](DEPLOYMENT.md) for:

- Production build configuration
- Boot-to-application setup
- System hardening and reliability
- Environmental considerations (temperature, vibration)
- Integration with vehicle electrical systems

---

## Development Roadmap

**Current Version**: 1.0 (Foundation Release)

**Planned Enhancements**:
- [ ] CAN Bus integration module
- [ ] OBD-II data acquisition
- [ ] GPS lap timing with track mapping
- [ ] Data logging and telemetry export
- [ ] Cloud connectivity for remote monitoring
- [ ] AI-driven predictive maintenance alerts
- [ ] Advanced driver assistance system (ADAS) integration
- [ ] Video integration for rear-view and surround cameras

---

## Contributing

We welcome contributions from the automotive and motorsports community! If you're interested in contributing:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/YourFeature`)
3. Commit your changes with clear, descriptive messages
4. Push to your branch (`git push origin feature/YourFeature`)
5. Open a Pull Request with detailed description

Please ensure all code follows the existing style conventions and includes appropriate documentation.

---

## License

This project is licensed under the MIT License - see the LICENSE file for details.

---

## Acknowledgments

- **Bosch Motorsports** - Inspiration from the DDU11 professional data display
- **Qt Project** - For providing the robust application framework
- **Delaney Motorsports Team** - For rigorous testing and feedback
- **Open Source Community** - For contributions and support

---

## Contact

**Delaney Motorsports, LLC**
Sarasota, Florida

**Director of Research and Development**
Kevin Delaney
[Kevin@DelaneyMotorsports.com](mailto:Kevin@DelaneyMotorsports.com)

---

## About Delaney Motorsports

Delaney Motorsports is dedicated to advancing automotive technology through innovative engineering and design. We specialize in high-performance vehicle systems, motorsports electronics, and luxury automotive enhancement solutions.

Visit us at: [www.DelaneyMotorsports.com](https://www.DelaneyMotorsports.com)
