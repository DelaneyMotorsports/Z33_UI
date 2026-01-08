# Z33 Luxury Vehicle UI Project

**Bosch Motorsports DDU11-Inspired Design**

Welcome to the Z33 Luxury Vehicle UI Project, an innovative approach to in-car entertainment and information systems. Designed for luxury vehicles and high-end custom aftermarket installations, this project leverages Qt Quick and QML to create a user interface that is both visually stunning and functionally advanced.

Inspired by the legendary Bosch Motorsports DDU11 professional data display, this system combines race-proven telemetry visualization with the refined aesthetics expected in modern luxury vehicles like the 2026 Range Rover.

## Features

This project includes several bespoke features tailored to enhance the driving experience:

- **Stellar Sky Roof**: Transforms the car's ceiling into a dynamic night sky display.
- **Holographic Heads-Up Display**: Projects vital information and navigational cues directly onto the windshield.
- **Dynamic Acoustic Environment**: Creates an immersive sound experience tailored to the driver's preferences and current environment.
- **Ambient Wellness Monitor**: Adjusts the vehicle's interior settings to promote passenger well-being.
- **Virtual Sky Canopy**: Offers customizable sky scenes on the vehicle's roof, creating a unique ambiance.
- **Sensory Climate Control**: Dynamically adjusts the cabin's climate, including temperature, scent, and humidity, for optimal comfort.
- **Dynamic Drive Mode Selector**: Automatically adjusts the vehicle's driving dynamics according to the driver's behavior and road conditions.

## Hardware Platforms

This system is designed to run on readily available, powerful embedded computing platforms suitable for automotive installations:

### Supported Hardware

- **Raspberry Pi 5** (4GB/8GB RAM recommended)
  - ARM Cortex-A76 quad-core processor @ 2.4GHz
  - Support for dual 4K HDMI displays
  - GPIO for sensor integration
  - Excellent price-to-performance ratio

- **NVIDIA Jetson Developer Kits** (Jetson Nano, Xavier NX, Orin Nano)
  - Hardware-accelerated GPU rendering
  - Superior graphics performance for complex UI elements
  - AI/ML capabilities for future enhancements
  - Industrial-grade reliability for automotive environments

### Display Requirements

For optimal visual quality comparable to 2026-era luxury vehicles (Range Rover, Mercedes-Benz, BMW):

- **Resolution**: 1920x1080 (1080p) minimum, 2K/4K capable
- **Display Technology**: AMOLED or OLED preferred for deep blacks and vibrant colors
- **Brightness**: 500+ nits for daylight visibility
- **Touch Capability**: Capacitive multi-touch recommended
- **Aspect Ratio**: 16:9 or 21:9 widescreen formats

**Recommended Display Options**:
- Waveshare 10.1" 1920x1200 IPS DSI Display
- Official Raspberry Pi Touch Display (7" for compact builds)
- Custom HDMI OLED panels (available from automotive display suppliers)

For detailed hardware setup instructions, see [HARDWARE_SETUP.md](HARDWARE_SETUP.md).

## Installation

To install and run the Z33 Luxury Vehicle UI project, follow these steps:

1. Ensure you have Qt 5.15 or later installed on your system, including the Qt Quick and Multimedia modules.
2. Clone this repository to your local machine.
3. Open the `Z33_UI.pro` file in Qt Creator.
4. Configure the project for your desired build target (desktop, embedded, etc.).
5. Build and run the project.

## Usage

Once installed, the Z33 UI can be interacted with through a touchscreen interface or the vehicle's existing controls, depending on the integration level. The UI supports customization through the settings menu, where users can select their preferred themes, features, and display options.

## Contributing

We welcome contributions to the Z33 Luxury Vehicle UI Project! If you're interested in contributing, please review our contributing guidelines and open a pull request with your proposed changes or new features.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Thanks to all contributors and testers.
- Special thanks to the Qt community for providing the tools that made this project possible.

## Contact

For questions, suggestions, or collaborations, please contact us at [Kevin@DelaneyMotorsports.com](mailto:Kevin@DelaneyMotorsports.com).
