/*!
    @file    main.qml
    @brief   Delaney Motorsports professional motorsports dashboard

    This QML file defines the main display interface for professional motorsports applications.
    Features a race-focused layout optimized for instant readability at high speeds with
    large central RPM display, shift light bar, and peripheral telemetry data.

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
    title: "Delaney Motorsports Dashboard"
    color: "#000000"

    // Simulated data (replace with CarInterface when available)
    property double currentRPM: 4500
    property double maxRPM: 8000
    property double currentSpeed: 87
    property int currentGear: 4
    property double oilPressure: 45
    property double oilTemp: 210
    property double waterTemp: 185
    property double voltage: 13.8
    property double fuelLevel: 67
    property double lapTime: 92.456
    property double bestLap: 89.234
    property double boost: 8.5

    Rectangle {
        anchors.fill: parent
        color: "#000000"

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 0
            spacing: 0

            // ========== SHIFT LIGHT BAR ==========
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 100
                color: "#000000"

                Row {
                    anchors.centerIn: parent
                    spacing: 12

                    Repeater {
                        model: 14

                        Rectangle {
                            width: 120
                            height: 80
                            radius: 6

                            property double threshold: (index + 1) / 14.0
                            property bool isActive: (currentRPM / maxRPM) >= threshold

                            color: {
                                if (!isActive) return "#0d0d0d"
                                if (index < 7) return "#00ff00"      // Green
                                if (index < 10) return "#ffff00"     // Yellow
                                if (index < 12) return "#ff6600"     // Orange
                                return "#ff0000"                      // Red
                            }

                            border.color: isActive ? "#ffffff" : "#222222"
                            border.width: isActive ? 3 : 1

                            // Flashing at redline
                            SequentialAnimation on opacity {
                                running: index >= 12 && isActive
                                loops: Animation.Infinite
                                NumberAnimation { to: 0.2; duration: 150 }
                                NumberAnimation { to: 1.0; duration: 150 }
                            }
                        }
                    }
                }
            }

            // ========== MAIN DISPLAY AREA ==========
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: "#000000"

                // Top row data fields
                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: 20
                    spacing: 40

                    // Boost
                    Rectangle {
                        width: 280
                        height: 140
                        color: "#0a0a0a"
                        border.color: "#333333"
                        border.width: 2
                        radius: 6

                        Column {
                            anchors.centerIn: parent
                            spacing: 8

                            Text {
                                text: "BOOST"
                                font.pixelSize: 26
                                font.family: "Roboto"
                                font.bold: true
                                color: "#666666"
                                anchors.horizontalCenter: parent.horizontalCenter
                            }

                            Text {
                                text: boost.toFixed(1)
                                font.pixelSize: 70
                                font.family: "Roboto"
                                font.bold: true
                                color: boost > 15 ? "#ff0000" : "#00ff00"
                                anchors.horizontalCenter: parent.horizontalCenter
                            }

                            Text {
                                text: "PSI"
                                font.pixelSize: 22
                                font.family: "Roboto"
                                color: "#666666"
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }
                    }

                    // Oil Pressure
                    Rectangle {
                        width: 280
                        height: 140
                        color: "#0a0a0a"
                        border.color: "#333333"
                        border.width: 2
                        radius: 6

                        Column {
                            anchors.centerIn: parent
                            spacing: 8

                            Text {
                                text: "OIL PSI"
                                font.pixelSize: 26
                                font.family: "Roboto"
                                font.bold: true
                                color: "#666666"
                                anchors.horizontalCenter: parent.horizontalCenter
                            }

                            Text {
                                text: oilPressure.toFixed(0)
                                font.pixelSize: 70
                                font.family: "Roboto"
                                font.bold: true
                                color: oilPressure < 20 ? "#ff0000" : "#00ff00"
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }
                    }

                    // Oil Temp
                    Rectangle {
                        width: 280
                        height: 140
                        color: "#0a0a0a"
                        border.color: "#333333"
                        border.width: 2
                        radius: 6

                        Column {
                            anchors.centerIn: parent
                            spacing: 8

                            Text {
                                text: "OIL TEMP"
                                font.pixelSize: 26
                                font.family: "Roboto"
                                font.bold: true
                                color: "#666666"
                                anchors.horizontalCenter: parent.horizontalCenter
                            }

                            Text {
                                text: Math.round(oilTemp).toString()
                                font.pixelSize: 70
                                font.family: "Roboto"
                                font.bold: true
                                color: oilTemp > 240 ? "#ff0000" : "#00ff00"
                                anchors.horizontalCenter: parent.horizontalCenter
                            }

                            Text {
                                text: "°F"
                                font.pixelSize: 22
                                font.family: "Roboto"
                                color: "#666666"
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }
                    }

                    // Water Temp
                    Rectangle {
                        width: 280
                        height: 140
                        color: "#0a0a0a"
                        border.color: "#333333"
                        border.width: 2
                        radius: 6

                        Column {
                            anchors.centerIn: parent
                            spacing: 8

                            Text {
                                text: "WATER"
                                font.pixelSize: 26
                                font.family: "Roboto"
                                font.bold: true
                                color: "#666666"
                                anchors.horizontalCenter: parent.horizontalCenter
                            }

                            Text {
                                text: Math.round(waterTemp).toString()
                                font.pixelSize: 70
                                font.family: "Roboto"
                                font.bold: true
                                color: waterTemp > 220 ? "#ff0000" : "#00ccff"
                                anchors.horizontalCenter: parent.horizontalCenter
                            }

                            Text {
                                text: "°F"
                                font.pixelSize: 22
                                font.family: "Roboto"
                                color: "#666666"
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }
                    }
                }

                // Center: MASSIVE RPM display
                Rectangle {
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: 50
                    width: 800
                    height: 400
                    color: "transparent"

                    Column {
                        anchors.centerIn: parent
                        spacing: 0

                        Text {
                            text: Math.round(currentRPM).toString()
                            font.pixelSize: 350
                            font.family: "Roboto"
                            font.bold: true
                            color: {
                                if (currentRPM > maxRPM * 0.9) return "#ff0000"
                                if (currentRPM > maxRPM * 0.8) return "#ff6600"
                                if (currentRPM > maxRPM * 0.7) return "#ffff00"
                                return "#00ff00"
                            }
                            anchors.horizontalCenter: parent.horizontalCenter
                            style: Text.Outline
                            styleColor: "#000000"
                        }

                        Text {
                            text: "RPM"
                            font.pixelSize: 48
                            font.family: "Roboto"
                            font.bold: true
                            color: "#666666"
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                }

                // Left side: Gear and Speed
                Column {
                    anchors.left: parent.left
                    anchors.leftMargin: 120
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.verticalCenterOffset: 50
                    spacing: 40

                    // Gear
                    Rectangle {
                        width: 200
                        height: 200
                        color: "#0a0a0a"
                        border.color: "#00ff00"
                        border.width: 4
                        radius: 10

                        Text {
                            text: currentGear.toString()
                            font.pixelSize: 140
                            font.family: "Roboto"
                            font.bold: true
                            color: "#00ff00"
                            anchors.centerIn: parent
                        }

                        Text {
                            text: "GEAR"
                            font.pixelSize: 20
                            font.family: "Roboto"
                            font.bold: true
                            color: "#00ff00"
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: 15
                        }
                    }

                    // Speed
                    Rectangle {
                        width: 200
                        height: 180
                        color: "#0a0a0a"
                        border.color: "#333333"
                        border.width: 2
                        radius: 6

                        Column {
                            anchors.centerIn: parent
                            spacing: 5

                            Text {
                                text: "SPEED"
                                font.pixelSize: 22
                                font.family: "Roboto"
                                font.bold: true
                                color: "#666666"
                                anchors.horizontalCenter: parent.horizontalCenter
                            }

                            Text {
                                text: Math.round(currentSpeed).toString()
                                font.pixelSize: 90
                                font.family: "Roboto"
                                font.bold: true
                                color: "#ffffff"
                                anchors.horizontalCenter: parent.horizontalCenter
                            }

                            Text {
                                text: "MPH"
                                font.pixelSize: 20
                                font.family: "Roboto"
                                color: "#666666"
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }
                    }
                }

                // Right side: Lap times and other data
                Column {
                    anchors.right: parent.right
                    anchors.rightMargin: 120
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.verticalCenterOffset: 50
                    spacing: 40

                    // Current Lap
                    Rectangle {
                        width: 320
                        height: 120
                        color: "#0a0a0a"
                        border.color: "#333333"
                        border.width: 2
                        radius: 6

                        Row {
                            anchors.centerIn: parent
                            spacing: 15

                            Text {
                                text: "LAP"
                                font.pixelSize: 28
                                font.family: "Roboto"
                                font.bold: true
                                color: "#666666"
                            }

                            Text {
                                text: formatLapTime(lapTime)
                                font.pixelSize: 48
                                font.family: "Roboto Mono"
                                font.bold: true
                                color: "#ffffff"
                            }
                        }
                    }

                    // Best Lap
                    Rectangle {
                        width: 320
                        height: 120
                        color: "#0a0a0a"
                        border.color: "#00ff00"
                        border.width: 2
                        radius: 6

                        Row {
                            anchors.centerIn: parent
                            spacing: 15

                            Text {
                                text: "BEST"
                                font.pixelSize: 28
                                font.family: "Roboto"
                                font.bold: true
                                color: "#00ff00"
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

                    // Voltage and Fuel
                    Row {
                        spacing: 20

                        Rectangle {
                            width: 150
                            height: 100
                            color: "#0a0a0a"
                            border.color: "#333333"
                            border.width: 2
                            radius: 6

                            Column {
                                anchors.centerIn: parent
                                spacing: 5

                                Text {
                                    text: "VOLTS"
                                    font.pixelSize: 18
                                    font.family: "Roboto"
                                    font.bold: true
                                    color: "#666666"
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }

                                Text {
                                    text: voltage.toFixed(1)
                                    font.pixelSize: 42
                                    font.family: "Roboto"
                                    font.bold: true
                                    color: voltage < 12.5 ? "#ff8800" : "#00ff00"
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }
                            }
                        }

                        Rectangle {
                            width: 150
                            height: 100
                            color: "#0a0a0a"
                            border.color: "#333333"
                            border.width: 2
                            radius: 6

                            Column {
                                anchors.centerIn: parent
                                spacing: 5

                                Text {
                                    text: "FUEL"
                                    font.pixelSize: 18
                                    font.family: "Roboto"
                                    font.bold: true
                                    color: "#666666"
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }

                                Text {
                                    text: Math.round(fuelLevel) + "%"
                                    font.pixelSize: 42
                                    font.family: "Roboto"
                                    font.bold: true
                                    color: {
                                        if (fuelLevel < 15) return "#ff0000"
                                        if (fuelLevel < 30) return "#ffff00"
                                        return "#00ff00"
                                    }
                                    anchors.horizontalCenter: parent.horizontalCenter
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
            // Simulate boost
            boost = 5 + Math.sin(Date.now() / 600) * 6 + 6
            // Simulate lap timer
            lapTime += 0.1
            if (lapTime > 120) lapTime = 0
            // Simulate gear changes
            if (currentRPM > 7000) currentGear = Math.min(6, currentGear + 1)
            if (currentRPM < 3000) currentGear = Math.max(1, currentGear - 1)
        }
    }
}