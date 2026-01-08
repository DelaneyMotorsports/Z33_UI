/*!
    @file    main.qml
    @brief   DDU11-inspired digital dashboard for motorsports and luxury vehicles.

    This QML file defines the main display interface inspired by the Bosch Motorsports DDU11.
    Features a professional motorsports layout with shift lights, large central display,
    and peripheral data fields for comprehensive vehicle telemetry monitoring.

    The design emphasizes instant readability, high contrast, and professional aesthetics
    suitable for both track and street applications.

    @author  Kevin Delaney
    @date    January 8, 2026
    @company Delaney Motorsports, LLC
    @address Sarasota, FL
    @compiler    Qt QML Module version 5.15.2
*/

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ApplicationWindow {
    visible: true
    width: 1920
    height: 1080
    title: "Delaney Motorsports DDU11"
    color: "#000000"

    // Simulated data (replace with CarInterface when available)
    property double currentSpeed: 87
    property double currentRPM: 4500
    property double maxRPM: 8000
    property double oilPressure: 45
    property double oilTemp: 195
    property double waterTemp: 185
    property double voltage: 13.8
    property double fuelLevel: 67
    property double lapTime: 92.456
    property double bestLap: 89.234

    Rectangle {
        anchors.fill: parent
        color: "#000000"

        // Main DDU11 Layout
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 15

            // ========== SHIFT LIGHT BAR (Top) ==========
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 80
                color: "#0a0a0a"
                border.color: "#333333"
                border.width: 2
                radius: 5

                Row {
                    anchors.centerIn: parent
                    spacing: 15

                    Repeater {
                        model: 12

                        Rectangle {
                            width: 140
                            height: 60
                            radius: 8

                            property double threshold: (index + 1) / 12.0
                            property bool isActive: (currentRPM / maxRPM) >= threshold

                            color: {
                                if (!isActive) return "#1a1a1a"
                                if (index < 6) return "#00ff00"      // Green (low RPM)
                                if (index < 9) return "#ffff00"      // Yellow (medium RPM)
                                if (index < 11) return "#ff8800"     // Orange (high RPM)
                                return "#ff0000"                      // Red (shift point)
                            }

                            border.color: isActive ? "#ffffff" : "#333333"
                            border.width: isActive ? 3 : 1

                            // Flashing effect at max RPM
                            SequentialAnimation on opacity {
                                running: index >= 11 && isActive
                                loops: Animation.Infinite
                                NumberAnimation { to: 0.3; duration: 200 }
                                NumberAnimation { to: 1.0; duration: 200 }
                            }
                        }
                    }
                }
            }

            // ========== MAIN DISPLAY AREA ==========
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: "#0a0a0a"
                border.color: "#333333"
                border.width: 2
                radius: 5

                // Grid layout for data fields
                GridLayout {
                    anchors.fill: parent
                    anchors.margins: 20
                    columns: 3
                    rows: 2
                    columnSpacing: 20
                    rowSpacing: 20

                    // ===== TOP LEFT: Oil Pressure =====
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: "#151515"
                        border.color: "#444444"
                        border.width: 2
                        radius: 8

                        Column {
                            anchors.centerIn: parent
                            spacing: 10

                            Text {
                                text: "OIL PSI"
                                font.pixelSize: 32
                                font.family: "Roboto"
                                font.bold: true
                                color: "#888888"
                                anchors.horizontalCenter: parent.horizontalCenter
                            }

                            Text {
                                text: oilPressure.toFixed(1)
                                font.pixelSize: 120
                                font.family: "Roboto"
                                font.bold: true
                                color: oilPressure < 20 ? "#ff0000" : "#00ff00"
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }
                    }

                    // ===== CENTER: MAIN SPEED DISPLAY =====
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: "#151515"
                        border.color: "#00ff00"
                        border.width: 4
                        radius: 8

                        Column {
                            anchors.centerIn: parent
                            spacing: 5

                            Text {
                                text: "SPEED"
                                font.pixelSize: 42
                                font.family: "Roboto"
                                font.bold: true
                                color: "#00ff00"
                                anchors.horizontalCenter: parent.horizontalCenter
                            }

                            Text {
                                text: Math.round(currentSpeed).toString()
                                font.pixelSize: 280
                                font.family: "Roboto"
                                font.bold: true
                                color: "#00ff00"
                                anchors.horizontalCenter: parent.horizontalCenter
                            }

                            Text {
                                text: "MPH"
                                font.pixelSize: 42
                                font.family: "Roboto"
                                font.bold: true
                                color: "#888888"
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }
                    }

                    // ===== TOP RIGHT: RPM =====
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: "#151515"
                        border.color: "#444444"
                        border.width: 2
                        radius: 8

                        Column {
                            anchors.centerIn: parent
                            spacing: 10

                            Text {
                                text: "RPM"
                                font.pixelSize: 32
                                font.family: "Roboto"
                                font.bold: true
                                color: "#888888"
                                anchors.horizontalCenter: parent.horizontalCenter
                            }

                            Text {
                                text: Math.round(currentRPM).toString()
                                font.pixelSize: 120
                                font.family: "Roboto"
                                font.bold: true
                                color: {
                                    if (currentRPM > maxRPM * 0.85) return "#ff0000"
                                    if (currentRPM > maxRPM * 0.70) return "#ffff00"
                                    return "#00ff00"
                                }
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }
                    }

                    // ===== BOTTOM LEFT: Water Temp =====
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: "#151515"
                        border.color: "#444444"
                        border.width: 2
                        radius: 8

                        Column {
                            anchors.centerIn: parent
                            spacing: 10

                            Text {
                                text: "WATER °F"
                                font.pixelSize: 32
                                font.family: "Roboto"
                                font.bold: true
                                color: "#888888"
                                anchors.horizontalCenter: parent.horizontalCenter
                            }

                            Text {
                                text: Math.round(waterTemp).toString()
                                font.pixelSize: 120
                                font.family: "Roboto"
                                font.bold: true
                                color: waterTemp > 220 ? "#ff0000" : "#00ccff"
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }
                    }

                    // ===== BOTTOM CENTER: Lap Timer =====
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: "#151515"
                        border.color: "#444444"
                        border.width: 2
                        radius: 8

                        Column {
                            anchors.centerIn: parent
                            spacing: 15

                            // Current Lap
                            Row {
                                spacing: 15
                                anchors.horizontalCenter: parent.horizontalCenter

                                Text {
                                    text: "LAP:"
                                    font.pixelSize: 38
                                    font.family: "Roboto"
                                    font.bold: true
                                    color: "#888888"
                                }

                                Text {
                                    text: formatLapTime(lapTime)
                                    font.pixelSize: 48
                                    font.family: "Roboto Mono"
                                    font.bold: true
                                    color: "#ffffff"
                                }
                            }

                            // Best Lap
                            Row {
                                spacing: 15
                                anchors.horizontalCenter: parent.horizontalCenter

                                Text {
                                    text: "BEST:"
                                    font.pixelSize: 38
                                    font.family: "Roboto"
                                    font.bold: true
                                    color: "#888888"
                                }

                                Text {
                                    text: formatLapTime(bestLap)
                                    font.pixelSize: 48
                                    font.family: "Roboto Mono"
                                    font.bold: true
                                    color: "#00ff00"
                                }
                            }
                        }
                    }

                    // ===== BOTTOM RIGHT: Voltage & Fuel =====
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: "#151515"
                        border.color: "#444444"
                        border.width: 2
                        radius: 8

                        Column {
                            anchors.centerIn: parent
                            spacing: 25

                            // Voltage
                            Row {
                                spacing: 15
                                anchors.horizontalCenter: parent.horizontalCenter

                                Text {
                                    text: "VOLTS:"
                                    font.pixelSize: 38
                                    font.family: "Roboto"
                                    font.bold: true
                                    color: "#888888"
                                }

                                Text {
                                    text: voltage.toFixed(1)
                                    font.pixelSize: 52
                                    font.family: "Roboto"
                                    font.bold: true
                                    color: voltage < 12.5 ? "#ff8800" : "#00ff00"
                                }
                            }

                            // Fuel Level
                            Row {
                                spacing: 15
                                anchors.horizontalCenter: parent.horizontalCenter

                                Text {
                                    text: "FUEL:"
                                    font.pixelSize: 38
                                    font.family: "Roboto"
                                    font.bold: true
                                    color: "#888888"
                                }

                                Text {
                                    text: Math.round(fuelLevel) + "%"
                                    font.pixelSize: 52
                                    font.family: "Roboto"
                                    font.bold: true
                                    color: {
                                        if (fuelLevel < 15) return "#ff0000"
                                        if (fuelLevel < 30) return "#ffff00"
                                        return "#00ff00"
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    // Helper function to format lap time
    function formatLapTime(seconds) {
        var mins = Math.floor(seconds / 60)
        var secs = (seconds % 60).toFixed(3)
        return mins.toString() + ":" + (secs < 10 ? "0" : "") + secs
    }

    // Simulation timer for demo purposes
    Timer {
        interval: 100
        running: true
        repeat: true
        onTriggered: {
            // Simulate varying RPM
            currentRPM = 3000 + Math.sin(Date.now() / 1000) * 2500 + 2500
            // Simulate varying speed
            currentSpeed = 60 + Math.sin(Date.now() / 800) * 40 + 40
            // Simulate lap timer
            lapTime += 0.1
            if (lapTime > 120) lapTime = 0
        }
    }
}