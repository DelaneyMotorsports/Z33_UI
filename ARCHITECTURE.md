/*!
    @file    ARCHITECTURE.md
    @brief   System architecture documentation for the Delaney Motorsports DDU11 Dashboard UI

    This document provides a comprehensive overview of the system architecture, design patterns,
    and technical implementation details of the Delaney Motorsports digital dashboard system.
    It covers the layered architecture, data flow, component interactions, and extensibility
    considerations for developers and integrators.

    @author  Kevin Delaney
    @date    January 8, 2026
    @company Delaney Motorsports, LLC
    @address Sarasota, FL
*/

# System Architecture

## Overview

The Delaney Motorsports DDU11 Dashboard UI is built on a modern, modular architecture that separates concerns between data acquisition, business logic, and user interface presentation. The system leverages Qt's powerful Model-View architecture combined with QML's declarative UI framework to create a responsive, maintainable, and extensible automotive display system.

---

## Architecture Layers

### 1. Data Acquisition Layer

**Responsibility**: Interface with vehicle systems and sensors to acquire real-time data.

**Components**:
- **CarInterface (C++)**: Primary data acquisition and management class
- **Sensor Drivers**: Hardware-specific drivers for CAN Bus, OBD-II, I2C, GPIO
- **Data Validation**: Input sanitization and error checking
- **Simulation Mode**: Mock data generation for development and testing

**Key Files**:
- `CarInterface.h` - Interface definition and Q_PROPERTY declarations
- `CarInterface.cpp` - Implementation of data acquisition logic

**Data Sources**:
```
Vehicle CAN Bus → CAN Interface → CarInterface
OBD-II Port → OBD-II Adapter → CarInterface
GPIO Sensors → ADC/Digital Input → CarInterface
I2C Devices → I2C Bus → CarInterface
Simulated Data → Mock Generator → CarInterface
```

### 2. Business Logic Layer

**Responsibility**: Process raw sensor data into meaningful information for display.

**Processing Functions**:
- **Unit Conversion**: Convert raw sensor values to display units (metric/imperial)
- **Averaging and Filtering**: Smooth noisy sensor data
- **Threshold Monitoring**: Detect warning/alarm conditions
- **Derived Calculations**: Compute values like fuel economy, range, etc.
- **State Management**: Track application state and mode changes

**Implementation**:
The business logic is primarily implemented within the `CarInterface` class using Qt's signal/slot mechanism. Data processing occurs in response to timer events or external signals, with processed data emitted via Qt signals for UI consumption.

### 3. Presentation Layer

**Responsibility**: Render visual interface and respond to user interactions.

**Components**:
- **QML Components**: Declarative UI widgets for each display function
- **Layout Management**: Dynamic arrangement of UI elements
- **Animations and Transitions**: Smooth visual feedback
- **Theme System**: Configurable color schemes and styling
- **Touch/Input Handling**: User interaction processing

**Key Files**:
- `main.qml` - Application window and primary layout
- `MultiGauge.qml` - Multi-function gauge display
- `SpeedDisplay.qml` - Digital speedometer
- `LapTimerDisplay.qml` - Lap timing interface
- `VoltageGauge.qml` - Voltage monitoring gauge
- `OilPressureGauge.qml` - Oil pressure gauge
- `safeUI.qml` - Safety-critical display elements

---

## Data Flow Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                     Vehicle / Sensors                            │
│  (CAN Bus, OBD-II, GPIO, I2C, Analog Sensors)                   │
└───────────────────────────┬─────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────────┐
│                   Data Acquisition Layer                         │
│                                                                  │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐         │
│  │  CAN Driver  │  │ OBD-II Driver│  │ GPIO/I2C     │         │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘         │
│         │                  │                  │                  │
│         └──────────────────┴──────────────────┘                 │
│                            │                                     │
│                    ┌───────▼────────┐                           │
│                    │  CarInterface  │                           │
│                    │   (QObject)    │                           │
│                    └───────┬────────┘                           │
└────────────────────────────┼─────────────────────────────────────┘
                             │ Qt Signals
                             │ (voltageChanged, speedChanged, etc.)
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│                   QML Engine / Context                           │
│                                                                  │
│  Context Property: "carInterface"                               │
│  Exposes: voltage, oilPressure, speed, etc.                    │
└───────────────────────────┬─────────────────────────────────────┘
                            │ Property Bindings
                            ▼
┌─────────────────────────────────────────────────────────────────┐
│                   Presentation Layer (QML)                       │
│                                                                  │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐         │
│  │ SpeedDisplay │  │VoltageGauge  │  │MultiGauge    │         │
│  └──────────────┘  └──────────────┘  └──────────────┘         │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐         │
│  │ LapTimer     │  │OilPressure   │  │ShiftLight    │         │
│  └──────────────┘  └──────────────┘  └──────────────┘         │
│                                                                  │
└───────────────────────────┬─────────────────────────────────────┘
                            │
                            ▼
                     ┌──────────────┐
                     │   Display    │
                     │  (OLED/LCD)  │
                     └──────────────┘
```

---

## Component Architecture

### CarInterface Class

**Purpose**: Central data hub for all vehicle telemetry.

**Design Pattern**: Observer (Qt Signal/Slot)

**Key Responsibilities**:
1. Maintain current state of all monitored parameters
2. Emit signals when values change
3. Provide getter methods for QML property binding
4. Abstract away hardware-specific implementation details

**Properties (Q_PROPERTY)**:
- `voltage` (double) - System voltage in volts
- `oilPressure` (double) - Oil pressure in PSI/bar
- `speed` (double) - Vehicle speed in MPH/KPH
- *(Extensible for additional parameters)*

**Signals**:
- `voltageChanged(double)` - Emitted when voltage updates
- `oilPressureChanged(double)` - Emitted when oil pressure updates
- `speedChanged(double)` - Emitted when speed updates

**Thread Safety**: All public methods are thread-safe. Sensor drivers running on separate threads can safely call update methods, with signals automatically queued to the main thread.

### QML Components

**Design Pattern**: Component-based architecture with property bindings

Each UI component is self-contained and follows these principles:
- **Single Responsibility**: Each component displays one type of information
- **Configurable**: Exposed properties for customization
- **Reusable**: No hard-coded dependencies on specific data sources
- **Responsive**: Automatic updates via Qt property binding

**Example Component Structure**:
```qml
Item {
    id: gaugeComponent

    // Public interface
    property double value: 0
    property string units: "mph"
    property double warningThreshold: 100

    // Visual implementation
    Rectangle { ... }
    Text { text: value.toFixed(1) + " " + units }

    // Behavior
    states: [...]
    transitions: [...]
}
```

---

## Safety-Critical Architecture

### Qt Safe Renderer Integration

For safety-critical applications (motorsports, automotive safety systems), the project includes integration with Qt Safe Renderer, which provides a fail-safe UI layer.

**Key Features**:
- **Independent Rendering**: Safe Renderer operates independently of main UI
- **Guaranteed Visibility**: Critical information displayed even during system failure
- **ISO 26262 Compliance**: Suitable for automotive safety integrity levels

**Safe UI Elements** (safeUI.qml):
- Speed indicator
- Engine warning light
- Critical alert indicators

**Separation of Concerns**:
```
┌────────────────────────────────────────────────┐
│         Main Application (Qt Quick)            │
│  Complex UI, animations, non-critical displays │
└────────────────────────────────────────────────┘
                    │
                    │ Falls back on failure
                    ▼
┌────────────────────────────────────────────────┐
│      Qt Safe Renderer (Independent)            │
│  Speed, warnings, critical safety information  │
└────────────────────────────────────────────────┘
```

---

## Extensibility and Customization

### Adding New Sensors/Data Points

To add a new data parameter:

1. **Update CarInterface.h**:
   ```cpp
   Q_PROPERTY(double fuelLevel READ fuelLevel NOTIFY fuelLevelChanged)

   signals:
       void fuelLevelChanged(double newLevel);

   private:
       double m_fuelLevel{0.0};
   ```

2. **Implement in CarInterface.cpp**:
   ```cpp
   double CarInterface::fuelLevel() const {
       return m_fuelLevel;
   }

   void CarInterface::updateFuelLevel(double newLevel) {
       if (m_fuelLevel != newLevel) {
           m_fuelLevel = newLevel;
           emit fuelLevelChanged(newLevel);
       }
   }
   ```

3. **Access in QML**:
   ```qml
   Text {
       text: carInterface.fuelLevel.toFixed(1) + "%"
   }
   ```

### Creating New Display Components

To create a new gauge or display:

1. Create a new QML file (e.g., `FuelGauge.qml`)
2. Define the component's public interface with properties
3. Bind to CarInterface data via property bindings
4. Implement visual representation
5. Add to `main.qml` layout

### Theme Customization

The system supports theme customization through:
- Global color palette definitions
- Font size scaling
- Layout adaptation for different screen sizes
- Day/night mode switching

---

## Performance Considerations

### Rendering Optimization

- **Hardware Acceleration**: Leverages GPU for Qt Quick rendering
- **Layer Caching**: Static elements cached for efficient repainting
- **Minimal Redraws**: Only changed elements are redrawn
- **60 FPS Target**: Smooth animations at automotive display standards

### Data Update Rates

- **Critical Parameters**: 20-60 Hz update rate (speed, RPM)
- **Non-Critical Parameters**: 1-10 Hz update rate (voltage, temperature)
- **Computed Values**: Updated on-demand or at lower rates

### Memory Footprint

- **Target RAM Usage**: 50-150 MB depending on active components
- **Embedded Optimization**: Suitable for Raspberry Pi 5 (4GB) and Jetson platforms
- **Resource Management**: Inactive components unloaded from memory

---

## Build System

### Qt Project Structure

The project uses qmake with a `.pro` file configuration:

```qmake
QT += quick qml multimedia
CONFIG += c++11

SOURCES += main.cpp \
           CarInterface.cpp

HEADERS += CarInterface.h

RESOURCES += qml.qrc \
             images/images.qrc
```

### Resource Management

- **QRC System**: QML files and images embedded in binary
- **Dynamic Loading**: Optional external resource loading for customization
- **Lazy Loading**: Components loaded on-demand to reduce startup time

---

## Testing Strategy

### Unit Testing

- **CarInterface Testing**: Mock sensor inputs, verify signal emission
- **Business Logic Testing**: Unit conversion, threshold detection
- **Data Validation**: Boundary conditions, error handling

### Integration Testing

- **Hardware-in-the-Loop**: Test with actual sensors and CAN bus
- **Display Testing**: Verify rendering on target hardware
- **Performance Testing**: Frame rate, latency, resource usage

### Simulation Mode

The system includes a simulation mode for development and demonstration:
- Generates realistic mock data
- Cycles through various scenarios
- No hardware dependencies required

---

## Deployment Architecture

### Embedded Linux Platform

```
┌─────────────────────────────────────────────┐
│        Raspberry Pi 5 / Jetson              │
│                                             │
│  ┌─────────────────────────────────────┐   │
│  │   Embedded Linux (Debian/Ubuntu)    │   │
│  │                                     │   │
│  │  ┌──────────────────────────────┐  │   │
│  │  │   X11 / Wayland Display      │  │   │
│  │  │                              │  │   │
│  │  │  ┌───────────────────────┐  │  │   │
│  │  │  │  Qt Application       │  │  │   │
│  │  │  │  (Z33_UI)             │  │  │   │
│  │  │  └───────────────────────┘  │  │   │
│  │  └──────────────────────────────┘  │   │
│  └─────────────────────────────────────┘   │
│                                             │
│  Hardware Interfaces:                      │
│  - HDMI/DSI → Display                      │
│  - GPIO → Analog Sensors                   │
│  - I2C → Accelerometer, Gyro               │
│  - USB → CAN Bus Adapter                   │
│  - Ethernet → OBD-II WiFi                  │
└─────────────────────────────────────────────┘
```

---

## Security Considerations

### Automotive Security

- **Input Validation**: All sensor inputs validated and bounds-checked
- **CAN Bus Security**: Optional message authentication
- **Update Mechanism**: Secure firmware update capability
- **Access Control**: Configuration protected by authentication

### Fail-Safe Operation

- **Watchdog Timer**: System reset on application hang
- **Sensor Validation**: Cross-check multiple sources for critical data
- **Graceful Degradation**: Display continues with partial data
- **Error Recovery**: Automatic restart on critical failures

---

## Future Architecture Enhancements

### Planned Improvements

1. **Modular Plugin System**: Load custom display modules at runtime
2. **Network Connectivity**: Remote monitoring and telemetry upload
3. **AI Integration**: Predictive maintenance using machine learning
4. **Video Integration**: Rear-view camera and 360° surround view
5. **Voice Control**: Hands-free operation via voice commands
6. **Cloud Sync**: Configuration and data synchronization

---

## Developer Resources

### Getting Started with Development

1. **Clone Repository**: `git clone https://github.com/DelaneyMotorsports/Z33_UI.git`
2. **Install Qt Creator**: Set up development environment
3. **Build and Run**: Open `.pro` file in Qt Creator
4. **Enable Simulation Mode**: Test without hardware

### Coding Standards

- **C++ Standard**: C++11 or later
- **Qt Version**: Qt 5.15+ or Qt 6.x
- **Code Style**: Qt coding conventions
- **Documentation**: Doxygen-style comments for all public APIs

### Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed guidelines on:
- Code submission process
- Testing requirements
- Documentation standards
- Code review procedures

---

## Conclusion

The Delaney Motorsports DDU11 Dashboard UI architecture is designed for professional automotive applications, balancing performance, safety, extensibility, and maintainability. The modular design allows for easy customization and integration into various vehicle platforms, from motorsports to luxury automotive installations.

For questions about the architecture or implementation details, contact:

**Kevin Delaney**
Director of Research and Development
Delaney Motorsports, LLC
[Kevin@DelaneyMotorsports.com](mailto:Kevin@DelaneyMotorsports.com)
