/*!
    @file    COMPONENTS.md
    @brief   Component documentation for Delaney Motorsports DDU11 Dashboard UI

    This document provides detailed documentation for all UI components in the Delaney
    Motorsports digital dashboard system. Each component is described with its purpose,
    properties, usage examples, and customization options. This guide serves as a
    reference for developers extending or customizing the dashboard system.

    @author  Kevin Delaney
    @date    January 8, 2026
    @company Delaney Motorsports, LLC
    @address Sarasota, FL
*/

# Component Documentation

## Overview

The Delaney Motorsports DDU11 Dashboard UI is built using a modular component architecture. Each component is a self-contained QML module responsible for displaying specific vehicle information or providing particular functionality. This document catalogs all available components, their interfaces, and usage patterns.

---

## Core Components

### main.qml

**Purpose**: Primary application window and main layout manager

**File Location**: `main.qml`

**Description**:
The main entry point for the UI application. Defines the ApplicationWindow, sets up the primary layout structure, and coordinates the arrangement of all display components. Uses StackLayout to manage different views or gauge configurations.

**Key Properties**:
- `width`: Window width (default: 1024px)
- `height`: Window height (default: 600px)
- `title`: Application window title

**Layout Structure**:
```qml
ApplicationWindow {
    visible: true
    width: 1024
    height: 600
    title: "Delaney Motorsports - Dashboard"

    StackLayout {
        id: mainLayout
        anchors.fill: parent

        // Child components arranged here
        VoltageGauge { }
        OilPressureGauge { }
        MultiGauge { }
    }
}
```

**Customization**:
- Adjust window dimensions for target display size
- Modify layout from StackLayout to GridLayout for multi-gauge view
- Add menu bar or toolbar for navigation

**Dependencies**:
- Qt Quick 2.15
- Qt Quick Controls 2.15
- Qt Quick Layouts 1.15
- DelaneyMotorsports 1.0 (C++ module)

---

## Gauge Components

### VoltageGauge.qml

**Purpose**: Displays system electrical voltage

**File Location**: `VoltageGauge.qml`

**Description**:
Monitors and displays the vehicle's electrical system voltage. Critical for detecting charging system issues or battery problems. Typically displays 12-14V for standard automotive systems.

**Properties**:
- `voltage` (double): Current voltage value
- `minVoltage` (double): Minimum scale value (default: 10.0V)
- `maxVoltage` (double): Maximum scale value (default: 16.0V)
- `warningLow` (double): Low voltage warning threshold (default: 11.5V)
- `warningHigh` (double): High voltage warning threshold (default: 15.0V)

**Data Binding**:
```qml
VoltageGauge {
    id: voltageGauge
    voltage: carInterface.voltage
}
```

**Visual Indicators**:
- Green: Normal operation (12-14V)
- Yellow: Warning condition (11.5-12V or 14-15V)
- Red: Critical condition (<11.5V or >15V)

**Customization**:
- Adjust warning thresholds for 24V systems
- Modify color scheme for different aesthetic
- Add numerical display with decimal precision

**Usage Scenarios**:
- Standard 12V automotive systems
- Racing applications monitoring alternator performance
- Electric vehicle auxiliary battery monitoring

---

### OilPressureGauge.qml

**Purpose**: Displays engine oil pressure

**File Location**: `OilPressureGauge.qml`

**Description**:
Monitors engine oil pressure, one of the most critical engine health parameters. Essential for motorsports applications and performance engine monitoring.

**Properties**:
- `oilPressure` (double): Current oil pressure in PSI or bar
- `minPressure` (double): Minimum scale value (default: 0 PSI)
- `maxPressure` (double): Maximum scale value (default: 100 PSI)
- `warningThreshold` (double): Low pressure warning (default: 10 PSI)
- `units` (string): Display units ("PSI" or "bar")

**Data Binding**:
```qml
OilPressureGauge {
    id: oilPressureGauge
    oilPressure: carInterface.oilPressure
    units: "PSI"
}
```

**Warning Behavior**:
- Below warning threshold: Red flashing indicator
- Normal range: Solid green indicator
- Includes visual and optional audible alerts

**Unit Conversion**:
- PSI to bar: multiply by 0.0689476
- bar to PSI: multiply by 14.5038

**Typical Values**:
- Idle: 10-20 PSI
- Cruising: 30-45 PSI
- High RPM: 50-80 PSI

---

### SpeedDisplay.qml

**Purpose**: Digital speedometer display

**File Location**: `SpeedDisplay.qml`

**Description**:
High-visibility digital speed readout designed for quick comprehension at a glance. Features large, bold numerals with customizable units. Inspired by professional motorsports displays.

**Properties**:
- `currentSpeed` (double): Current vehicle speed
- `units` (string): Display units ("mph" or "kph")
- `maxSpeed` (double): Maximum scale value (default: 200)
- `backgroundColor` (color): Gauge background color
- `textColor` (color): Speed text color (default: bright green)

**Data Binding**:
```qml
SpeedDisplay {
    id: speedDisplay
    currentSpeed: carInterface.speed
    units: "mph"
}
```

**Visual Design**:
- Circular background (#1e1e1e dark gray)
- Large centered numerical display (48px)
- Bright green text (#00ff00) for high visibility
- Optional arc indicator for speed range visualization

**Customization Options**:
- Add graphical speed arc (0-max speed)
- Implement color gradient (green→yellow→red)
- Include peak speed indicator
- Add average speed display

**Enhancements**:
```qml
// Add semi-circular speed arc
Canvas {
    id: speedArc
    anchors.fill: parent
    onPaint: {
        var ctx = getContext("2d");
        var centerX = width / 2;
        var centerY = height / 2;
        var radius = width / 2 - 10;
        var angle = (currentSpeed / maxSpeed) * Math.PI;

        ctx.beginPath();
        ctx.arc(centerX, centerY, radius, Math.PI, Math.PI + angle);
        ctx.strokeStyle = "#00ff00";
        ctx.lineWidth = 8;
        ctx.stroke();
    }
}
```

---

### MultiGauge.qml

**Purpose**: Multi-function configurable gauge display

**File Location**: `MultiGauge.qml`

**Description**:
Versatile display component capable of showing multiple metrics with user-selectable modes. Cycles through different data types (Speed, RPM, Fuel Efficiency, etc.) via touch or button input.

**Properties**:
- `metrics` (array): Array of available metric names
- `currentMetricIndex` (int): Currently displayed metric
- `value` (variant): Current metric value
- `units` (string): Units for current metric

**Data Binding**:
```qml
MultiGauge {
    id: multiGauge
    metrics: ["Speed", "RPM", "Fuel Efficiency", "Coolant Temp"]
    currentMetricIndex: 0
    value: getValueForMetric(currentMetricIndex)
}
```

**Interaction**:
- Touch/click to cycle through metrics
- Swipe gestures for navigation (optional)
- Long-press to lock on specific metric

**Functionality**:
```qml
function nextMetric() {
    currentMetricIndex = (currentMetricIndex + 1) % metrics.length
    metricLabel.text = metrics[currentMetricIndex]
}

MouseArea {
    anchors.fill: parent
    onClicked: nextMetric()
}
```

**Use Cases**:
- Compact dashboard with limited space
- Driver-configurable displays
- Context-sensitive information (race mode vs. street mode)

---

## Motorsports Components

### LapTimerDisplay.qml

**Purpose**: Professional lap timing system

**File Location**: `LapTimerDisplay.qml`

**Description**:
Track-focused lap timing display showing current lap time, previous lap time, and best lap time. Essential for motorsports applications and track day enthusiasts. Integrates with GPS or beacon-based lap detection systems.

**Properties**:
- `currentLapTime` (double): Elapsed time for current lap (seconds)
- `lastLapTime` (double): Time for previous lap (seconds)
- `bestLapTime` (double): Best lap time in session (seconds)
- `isRunning` (bool): Timer active state
- `lapCount` (int): Total number of completed laps

**Data Binding**:
```qml
LapTimerDisplay {
    id: lapTimer
    currentLapTime: carInterface.currentLapTime
    lastLapTime: carInterface.lastLapTime
    bestLapTime: carInterface.bestLapTime
}
```

**Display Layout**:
```
Current Lap:  01:23.456  (white)
Last Lap:     01:22.789  (yellow)
Best Lap:     01:21.234  (lime green)
```

**Color Coding**:
- **Current Lap**: White (neutral)
- **Last Lap**: Yellow (reference)
- **Best Lap**: Lime green (target)
- **Personal Best**: Flashing green animation

**Time Formatting**:
```qml
function formatTime(seconds) {
    var mins = Math.floor(seconds / 60);
    var secs = (seconds % 60).toFixed(3);
    return mins.toString().padStart(2, '0') + ":" +
           secs.toString().padStart(6, '0');
}
```

**Advanced Features**:
- Sector timing (split times)
- Delta time vs. best lap
- Predictive lap time
- Session statistics (average, median, standard deviation)

**Integration**:
- GPS-based lap detection (start/finish line crossing)
- IR beacon lap triggers
- Manual start/stop controls

---

### ShiftLightDisplay.qml

**Purpose**: RPM-based shift indicator

**File Location**: `ShiftLightDisplay.qml`

**Description**:
Visual shift indicator for optimal gear changes in manual transmission vehicles. Displays progressive indicator lights that flash when optimal shift point is reached. Common in motorsports and performance applications.

**Properties**:
- `currentRPM` (double): Current engine RPM
- `shiftPoint` (double): Target shift RPM (default: 6500)
- `warningPoint` (double): RPM to start visual warning (default: 6000)
- `maxRPM` (double): Redline RPM (default: 7000)

**Data Binding**:
```qml
ShiftLightDisplay {
    id: shiftLight
    currentRPM: carInterface.rpm
    shiftPoint: 6500
    maxRPM: 7000
}
```

**Visual Progression**:
```
0-5500 RPM:    No lights
5500-6000 RPM: Green lights (1-3)
6000-6500 RPM: Yellow lights (4-6)
6500+ RPM:     Red lights (7-10), flashing
7000+ RPM:     All red, rapid flashing (over-rev warning)
```

**Display Pattern**:
```
◯ ◯ ◯ ◯ ◯ ◯ ◯ ◯ ◯ ◯   (0-5500 RPM: off)
🟢 🟢 🟢 ◯ ◯ ◯ ◯ ◯ ◯ ◯   (5500-6000 RPM: green)
🟢 🟢 🟢 🟡 🟡 🟡 ◯ ◯ ◯ ◯   (6000-6500 RPM: yellow)
🟢 🟢 🟢 🟡 🟡 🟡 🔴 🔴 🔴 🔴   (6500+ RPM: red flash)
```

**Customization**:
- Adjust shift points per gear
- Configure color thresholds
- Add haptic feedback (vibration)
- Include audible shift tone

---

### StopwatchDisplay.qml

**Purpose**: Independent timer for performance testing

**File Location**: `StopwatchDisplay.qml`

**Description**:
General-purpose stopwatch for timing acceleration runs, brake tests, or any measured performance event. Independent of lap timer system.

**Properties**:
- `elapsedTime` (double): Elapsed time in seconds
- `isRunning` (bool): Timer state
- `displayFormat` (string): Time format ("MM:SS.mmm" or "SS.mmm")

**Controls**:
- Start/Stop button
- Reset button
- Lap/split button (records intermediate times)

**Data Display**:
```qml
StopwatchDisplay {
    id: stopwatch

    Text {
        text: formatStopwatchTime(elapsedTime)
        font.pixelSize: 36
        color: isRunning ? "lime" : "white"
    }
}
```

**Use Cases**:
- 0-60 mph acceleration testing
- Quarter-mile runs
- Brake distance measurements
- Autocross stage timing

---

## Information Displays

### CompassDisplay.qml

**Purpose**: Digital compass showing heading

**File Location**: `CompassDisplay.qml`

**Description**:
Displays vehicle heading based on GPS or magnetometer data. Useful for navigation and orientation awareness.

**Properties**:
- `heading` (double): Current heading in degrees (0-360)
- `showCardinal` (bool): Display cardinal direction text (N, NE, E, etc.)
- `showDegrees` (bool): Display numerical degree value

**Data Binding**:
```qml
CompassDisplay {
    id: compass
    heading: carInterface.gpsHeading
    showCardinal: true
}
```

**Cardinal Directions**:
```qml
function getCardinalDirection(degrees) {
    const directions = ["N", "NE", "E", "SE", "S", "SW", "W", "NW"];
    const index = Math.round(degrees / 45) % 8;
    return directions[index];
}
```

**Visual Design**:
- Circular compass rose
- Rotating needle pointing north
- Current heading in degrees
- Cardinal direction abbreviation

---

### RangeDisplay.qml

**Purpose**: Fuel range estimation

**File Location**: `RangeDisplay.qml`

**Description**:
Calculates and displays estimated remaining range based on current fuel level and consumption rate. Uses real-time fuel efficiency data for accurate prediction.

**Properties**:
- `fuelLevel` (double): Current fuel level (percentage or gallons/liters)
- `fuelCapacity` (double): Tank capacity
- `averageMPG` (double): Average fuel efficiency
- `rangeUnits` (string): Display units ("miles" or "km")

**Calculation**:
```qml
property double estimatedRange: (fuelLevel / 100) * fuelCapacity * averageMPG
```

**Display**:
```qml
Text {
    text: estimatedRange.toFixed(0) + " " + rangeUnits
    color: estimatedRange < 50 ? "red" :
           estimatedRange < 100 ? "yellow" : "white"
}
```

**Warning States**:
- Green: >100 miles range
- Yellow: 50-100 miles range
- Red: <50 miles range
- Flashing red: <25 miles (critical)

---

### MpgDisplay.qml

**Purpose**: Fuel economy display

**File Location**: `MpgDisplay.qml`

**Description**:
Displays current and average fuel economy. Provides real-time feedback on driving efficiency.

**Properties**:
- `instantMPG` (double): Current fuel economy
- `averageMPG` (double): Trip average fuel economy
- `units` (string): "MPG" or "L/100km"

**Data Binding**:
```qml
MpgDisplay {
    id: mpgDisplay
    instantMPG: carInterface.instantMPG
    averageMPG: carInterface.averageMPG
}
```

**Display Layout**:
```
Current:  24.5 MPG
Average:  28.3 MPG
```

**Unit Conversion**:
```qml
// MPG to L/100km
function mpgToLPer100km(mpg) {
    return 235.214 / mpg;
}
```

---

## Advanced Feature Displays

### FeatureUDisplay.qml through FeatureZDisplay.qml

**Purpose**: Modular displays for custom telemetry and future features

**File Locations**: `FeatureUDisplay.qml`, `FeatureVDisplay.qml`, `FeatureWDisplay.qml`, `FeatureXDisplay.qml`, `FeatureYDisplay.qml`, `FeatureZDisplay.qml`

**Description**:
Placeholder components for custom telemetry integration and advanced features. These displays are designed to be customized for specific vehicle systems, sensors, or luxury features.

**Common Properties**:
- `featureName` (string): Display name
- `featureValue` (variant): Current value
- `units` (string): Value units
- `active` (bool): Feature availability

**Intended Uses**:

**FeatureUDisplay**: Turbo boost pressure
**FeatureVDisplay**: Transmission temperature
**FeatureWDisplay**: Brake temperature monitoring
**FeatureXDisplay**: Tire pressure monitoring system (TPMS)
**FeatureYDisplay**: Ambient lighting control
**FeatureZDisplay**: Climate control interface

**Customization Template**:
```qml
Item {
    id: customFeatureDisplay
    width: 300
    height: 150

    property string featureName: "Boost Pressure"
    property double featureValue: 0.0
    property string units: "PSI"

    Rectangle {
        anchors.fill: parent
        color: "#2a2a2a"
        radius: 10

        Column {
            anchors.centerIn: parent
            spacing: 10

            Text {
                text: featureName
                font.pixelSize: 18
                color: "#888888"
            }

            Text {
                text: featureValue.toFixed(1) + " " + units
                font.pixelSize: 32
                font.bold: true
                color: "#00ff00"
            }
        }
    }
}
```

---

## Safety-Critical Components

### safeUI.qml

**Purpose**: Safety-critical UI elements using Qt Safe Renderer

**File Location**: `safeUI.qml`

**Description**:
Implements safety-critical display elements that remain visible even in the event of main application failure. Uses Qt Safe Renderer for ISO 26262 compliance. Essential for automotive safety applications.

**Components**:

#### Safe Speed Indicator
- Displays current speed
- Remains functional during system failure
- Simplified rendering for reliability

#### Engine Warning Light
- Critical engine fault indicator
- Binary state (on/off)
- Red warning icon

#### Fuel Low Indicator
- Critical low fuel warning
- Activates at configurable threshold
- Yellow warning icon

**Safety Properties**:
- **Independence**: Runs in separate process from main UI
- **Simplicity**: Minimal code complexity for reliability
- **Verification**: Formally verified rendering path
- **Fail-Safe**: Displays emergency information on main UI failure

**Integration**:
```qml
import QtSafeRenderer 1.0

SafeRenderer {
    Item {
        id: safeSpeedIndicator
        property int speed: carInterface.speed

        Text {
            text: speed + " mph"
            color: "white"
            font.pixelSize: 24
        }
    }
}
```

**Use Cases**:
- Motorsports (critical speed and warning information)
- Automotive safety systems
- Applications requiring ISO 26262 compliance
- Redundant display systems

---

## Backend Interface

### CarInterface (C++ Class)

**Purpose**: Data acquisition and management backend

**File Locations**: `CarInterface.h`, `CarInterface.cpp`

**Description**:
C++ class that interfaces with vehicle sensors and systems. Provides Q_PROPERTY declarations for QML binding and emits signals when data changes. Acts as the bridge between hardware sensors and QML UI.

**Properties**:
```cpp
Q_PROPERTY(double voltage READ voltage NOTIFY voltageChanged)
Q_PROPERTY(double oilPressure READ oilPressure NOTIFY oilPressureChanged)
Q_PROPERTY(double speed READ speed NOTIFY speedChanged)
// Additional properties as needed
```

**Signals**:
```cpp
signals:
    void voltageChanged(double newVoltage);
    void oilPressureChanged(double newOilPressure);
    void speedChanged(double newSpeed);
```

**Usage in QML**:
```qml
// Exposed as context property in main.cpp
// Access in QML:
Text {
    text: "Voltage: " + carInterface.voltage.toFixed(1) + "V"
}
```

**Extending CarInterface**:

To add new sensor data:
1. Add Q_PROPERTY in header
2. Add getter method
3. Add signal for change notification
4. Add update method
5. Implement sensor reading logic

**Example Addition**:
```cpp
// In CarInterface.h
Q_PROPERTY(double fuelLevel READ fuelLevel NOTIFY fuelLevelChanged)

double fuelLevel() const;

signals:
    void fuelLevelChanged(double newLevel);

// In CarInterface.cpp
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

---

## Component Usage Best Practices

### Property Binding

Use Qt's automatic property binding for reactive UI:
```qml
SpeedDisplay {
    currentSpeed: carInterface.speed  // Automatically updates
}
```

### Signal Connections

Connect to signals for event-driven updates:
```qml
Connections {
    target: carInterface
    onSpeedChanged: {
        // Custom logic on speed change
        if (newSpeed > speedLimit) {
            speedWarning.visible = true
        }
    }
}
```

### Component Reusability

Design components to be reusable with configurable properties:
```qml
GenericGauge {
    id: customGauge
    title: "Custom Sensor"
    value: customSensorValue
    units: "units"
    minValue: 0
    maxValue: 100
}
```

### Performance Optimization

- Use `Loader` for conditionally loaded components
- Implement `visible: false` instead of destroying components
- Cache static visual elements
- Minimize property bindings in loops

---

## Future Component Roadmap

### Planned Components

- **GPSMapDisplay.qml**: Track map with GPS overlay
- **GForceDisplay.qml**: Real-time G-force visualization
- **VideoDisplay.qml**: Rear-view / surround camera integration
- **TirePressureDisplay.qml**: TPMS monitoring
- **DataLogger.qml**: Telemetry recording interface
- **ConfigPanel.qml**: Settings and configuration UI
- **AlertDisplay.qml**: Warning and notification system

---

## Support and Customization

For component customization support, integration assistance, or custom component development:

**Kevin Delaney**
Director of Research and Development
Delaney Motorsports, LLC
Sarasota, Florida
[Kevin@DelaneyMotorsports.com](mailto:Kevin@DelaneyMotorsports.com)

---

## Conclusion

This component library provides a comprehensive foundation for automotive display systems, from basic gauges to advanced motorsports telemetry. The modular architecture allows for easy customization and extension to meet specific application requirements.
