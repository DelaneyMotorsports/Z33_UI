/*!
    @file    boost_gauge.qml
    @brief   Boost pressure gauge for MaTouch ESP32-S3 2.1" display

    Turbo/supercharger boost pressure gauge for 480x480 MaTouch display.
    Displays boost in PSI with vacuum indication. Designed for forced induction
    motorsport applications with A-pillar mounting.

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

    // Boost properties
    property double currentBoost: 5.5  // PSI (negative = vacuum)
    property double maxBoost: 25.0     // Max scale
    property double minVacuum: -15.0   // Max vacuum
    property double warningBoost: 20.0 // Warning threshold

    // Simulated boost for demo
    Timer {
        interval: 50
        running: true
        repeat: true
        onTriggered: {
            // Simulate boost cycle (vacuum → boost → vacuum)
            var cycle = (Date.now() % 8000) / 8000.0
            if (cycle < 0.3) {
                // Idle/cruise - vacuum
                currentBoost = -5 + Math.sin(cycle * 10) * 3
            } else if (cycle < 0.7) {
                // Boost build
                currentBoost = (cycle - 0.3) * 50 - 5
            } else {
                // Back to vacuum
                currentBoost = 15 - (cycle - 0.7) * 60
            }
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

    // Boost Arc Gauge
    Canvas {
        id: boostCanvas
        anchors.fill: parent
        onPaint: {
            var ctx = getContext("2d")
            ctx.clearRect(0, 0, width, height)

            var centerX = width / 2
            var centerY = height / 2
            var radius = 200
            var startAngle = Math.PI * 0.75  // Start at 135 degrees
            var endAngle = Math.PI * 2.25    // End at 405 degrees

            // Calculate current angle based on boost
            var totalRange = maxBoost - minVacuum
            var currentPosition = (currentBoost - minVacuum) / totalRange
            var currentAngle = startAngle + currentPosition * (endAngle - startAngle)
            var zeroAngle = startAngle + (-minVacuum / totalRange) * (endAngle - startAngle)

            // Background arc
            ctx.beginPath()
            ctx.arc(centerX, centerY, radius, startAngle, endAngle)
            ctx.lineWidth = 40
            ctx.strokeStyle = "#1a1a1a"
            ctx.stroke()

            // Active arc
            ctx.beginPath()
            if (currentBoost >= 0) {
                // Positive boost - start from zero
                ctx.arc(centerX, centerY, radius, zeroAngle, currentAngle)
            } else {
                // Vacuum - reverse direction from zero
                ctx.arc(centerX, centerY, radius, currentAngle, zeroAngle)
            }
            ctx.lineWidth = 40

            // Color based on boost level
            if (currentBoost >= warningBoost) {
                ctx.strokeStyle = "#ff0000"  // Red - high boost warning
            } else if (currentBoost >= maxBoost * 0.7) {
                ctx.strokeStyle = "#ffff00"  // Yellow - high boost
            } else if (currentBoost > 0) {
                ctx.strokeStyle = "#00ff00"  // Green - positive boost
            } else {
                ctx.strokeStyle = "#00ccff"  // Cyan - vacuum
            }
            ctx.stroke()

            // Tick marks and labels
            ctx.strokeStyle = "#888888"
            ctx.lineWidth = 3
            var ticks = [-15, -10, -5, 0, 5, 10, 15, 20, 25]
            for (var i = 0; i < ticks.length; i++) {
                var tickValue = ticks[i]
                var tickPosition = (tickValue - minVacuum) / totalRange
                var tickAngle = startAngle + tickPosition * (endAngle - startAngle)

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

                // Labels
                var labelRadius = radius + 45
                var labelX = centerX + Math.cos(tickAngle) * labelRadius
                var labelY = centerY + Math.sin(tickAngle) * labelRadius

                ctx.fillStyle = tickValue === 0 ? "#ffffff" : "#888888"
                ctx.font = tickValue === 0 ? "bold 22px Roboto" : "bold 18px Roboto"
                ctx.textAlign = "center"
                ctx.textBaseline = "middle"
                ctx.fillText(tickValue.toString(), labelX, labelY)
            }

            // Zero line marker
            ctx.strokeStyle = "#ffffff"
            ctx.lineWidth = 4
            var zeroInner = radius - 30
            var zeroOuter = radius + 20
            var zeroX1 = centerX + Math.cos(zeroAngle) * zeroInner
            var zeroY1 = centerY + Math.sin(zeroAngle) * zeroInner
            var zeroX2 = centerX + Math.cos(zeroAngle) * zeroOuter
            var zeroY2 = centerY + Math.sin(zeroAngle) * zeroOuter
            ctx.beginPath()
            ctx.moveTo(zeroX1, zeroY1)
            ctx.lineTo(zeroX2, zeroY2)
            ctx.stroke()
        }

        Connections {
            target: parent
            function onCurrentBoostChanged() {
                boostCanvas.requestPaint()
            }
        }
    }

    // Center digital display
    Column {
        anchors.centerIn: parent
        spacing: 10

        Text {
            text: currentBoost >= 0 ?
                  "+" + currentBoost.toFixed(1) :
                  currentBoost.toFixed(1)
            font.pixelSize: 110
            font.family: "Roboto"
            font.bold: true
            color: {
                if (currentBoost >= warningBoost) return "#ff0000"
                if (currentBoost >= maxBoost * 0.7) return "#ffff00"
                if (currentBoost > 0) return "#00ff00"
                return "#00ccff"
            }
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Text {
            text: "PSI"
            font.pixelSize: 32
            font.family: "Roboto"
            font.bold: true
            color: "#888888"
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Text {
            text: currentBoost < 0 ? "VACUUM" : "BOOST"
            font.pixelSize: 24
            font.family: "Roboto"
            font.bold: true
            color: "#666666"
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    // Warning indicator (top)
    Rectangle {
        visible: currentBoost >= warningBoost
        width: 140
        height: 60
        radius: 8
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 50
        color: "#ff0000"
        border.color: "#ffffff"
        border.width: 3

        Text {
            text: "HIGH BOOST"
            font.pixelSize: 22
            font.family: "Roboto"
            font.bold: true
            color: "#ffffff"
            anchors.centerIn: parent
        }

        // Flashing animation
        SequentialAnimation on opacity {
            running: currentBoost >= warningBoost
            loops: Animation.Infinite
            NumberAnimation { to: 0.3; duration: 200 }
            NumberAnimation { to: 1.0; duration: 200 }
        }
    }

    // Label (bottom)
    Text {
        text: "BOOST PRESSURE"
        font.pixelSize: 22
        font.family: "Roboto"
        font.bold: true
        color: "#888888"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 30
    }
}
