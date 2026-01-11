/*!
    @file    rpm_gauge.qml
    @brief   RPM tachometer gauge for MaTouch ESP32-S3 2.1" display

    Professional motorsport tachometer designed for the 480x480 MaTouch display.
    Features large digital readout, circular sweep gauge, and progressive shift light.
    Optimized for A-pillar mounting with instant readability.

    @author  Kevin Delaney
    @date    January 8, 2026
    @company Delaney Motorsports, LLC
    @address Sarasota, FL
*/

import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    width: 480
    height: 480
    color: "#000000"

    // RPM properties
    property double currentRPM: 3500
    property double maxRPM: 8000
    property double warningRPM: 6500
    property double redlineRPM: 7500

    // Simulated RPM for demo
    Timer {
        interval: 50
        running: true
        repeat: true
        onTriggered: {
            currentRPM = 2000 + Math.sin(Date.now() / 800) * 3000 + 3000
        }
    }

    // Background circle
    Rectangle {
        anchors.centerIn: parent
        width: 460
        height: 460
        radius: 230
        color: "#0a0a0a"
        border.color: "#333333"
        border.width: 3
    }

    // RPM Arc Gauge
    Canvas {
        id: rpmCanvas
        anchors.fill: parent
        onPaint: {
            var ctx = getContext("2d")
            ctx.clearRect(0, 0, width, height)

            var centerX = width / 2
            var centerY = height / 2
            var radius = 200
            var startAngle = Math.PI * 0.75  // Start at 135 degrees
            var endAngle = Math.PI * 2.25    // End at 405 degrees (270 degree sweep)
            var currentAngle = startAngle + (currentRPM / maxRPM) * (endAngle - startAngle)

            // Background arc (dark)
            ctx.beginPath()
            ctx.arc(centerX, centerY, radius, startAngle, endAngle)
            ctx.lineWidth = 40
            ctx.strokeStyle = "#1a1a1a"
            ctx.stroke()

            // Active arc (color based on RPM)
            ctx.beginPath()
            ctx.arc(centerX, centerY, radius, startAngle, currentAngle)
            ctx.lineWidth = 40

            // Color progression
            if (currentRPM >= redlineRPM) {
                ctx.strokeStyle = "#ff0000"  // Red - redline
            } else if (currentRPM >= warningRPM) {
                ctx.strokeStyle = "#ffaa00"  // Orange - warning
            } else if (currentRPM >= maxRPM * 0.6) {
                ctx.strokeStyle = "#ffff00"  // Yellow - high
            } else {
                ctx.strokeStyle = "#00ff00"  // Green - normal
            }
            ctx.stroke()

            // Tick marks
            ctx.strokeStyle = "#888888"
            ctx.lineWidth = 3
            for (var i = 0; i <= 8; i++) {
                var tickAngle = startAngle + (i / 8) * (endAngle - startAngle)
                var innerRadius = radius - 25
                var outerRadius = radius + 15

                var x1 = centerX + Math.cos(tickAngle) * innerRadius
                var y1 = centerY + Math.sin(tickAngle) * innerRadius
                var x2 = centerX + Math.cos(tickAngle) * outerRadius
                var y2 = centerY + Math.sin(tickAngle) * outerRadius

                ctx.beginPath()
                ctx.moveTo(x1, y1)
                ctx.lineTo(x2, y2)
                ctx.stroke()

                // RPM labels
                var labelRadius = radius + 45
                var labelX = centerX + Math.cos(tickAngle) * labelRadius
                var labelY = centerY + Math.sin(tickAngle) * labelRadius

                ctx.fillStyle = "#888888"
                ctx.font = "bold 20px Roboto"
                ctx.textAlign = "center"
                ctx.textBaseline = "middle"
                ctx.fillText((i * 1000).toString(), labelX, labelY)
            }
        }

        Connections {
            target: parent
            function onCurrentRPMChanged() {
                rpmCanvas.requestPaint()
            }
        }
    }

    // Center digital display
    Column {
        anchors.centerIn: parent
        spacing: 10

        Text {
            text: Math.round(currentRPM).toString()
            font.pixelSize: 120
            font.family: "Roboto"
            font.bold: true
            color: {
                if (currentRPM >= redlineRPM) return "#ff0000"
                if (currentRPM >= warningRPM) return "#ffaa00"
                return "#ffffff"
            }
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Text {
            text: "RPM"
            font.pixelSize: 28
            font.family: "Roboto"
            font.bold: true
            color: "#888888"
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    // Shift light indicator (top)
    Rectangle {
        width: 150
        height: 150
        radius: 75
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 40
        color: currentRPM >= redlineRPM ? "#ff0000" : "transparent"
        border.color: "#333333"
        border.width: 2

        // Flashing animation at redline
        SequentialAnimation on opacity {
            running: currentRPM >= redlineRPM
            loops: Animation.Infinite
            NumberAnimation { to: 0.2; duration: 150 }
            NumberAnimation { to: 1.0; duration: 150 }
        }

        Text {
            visible: currentRPM >= redlineRPM
            text: "SHIFT"
            font.pixelSize: 32
            font.family: "Roboto"
            font.bold: true
            color: "#ffffff"
            anchors.centerIn: parent
        }
    }

    // Redline indicator text (bottom)
    Text {
        text: "REDLINE: " + redlineRPM
        font.pixelSize: 22
        font.family: "Roboto"
        font.bold: true
        color: "#ff0000"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 30
    }
}
