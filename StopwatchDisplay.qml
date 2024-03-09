/*!
    @file    StopwatchDisplay.qml
    @brief   Interactive stopwatch component for the car's UI.

    StopwatchDisplay provides a straightforward and user-friendly interface for timing events,
    with functionality to start, stop, and reset the stopwatch. This component is essential for
    drivers looking to measure time intervals accurately, whether for performance testing,
    track laps, or any timed activity. The design ensures easy readability and operation,
    enhancing the vehicle's utility and the driver's experience.

    The component integrates seamlessly within the MultiGauge system as one of the selectable
    display options, offering flexibility and convenience in real-time vehicle monitoring.

    @author  Kevin Delaney
    @date    March 8, 2024
    @company Delaney Motorsports, LLC
    @address Sarasota, FL
*/

import QtQuick 2.15

Item {
    id: stopwatchDisplay
    width: 300
    height: 120

    property int milliseconds: 0
    property bool running: false

    Timer {
        id: stopwatchTimer
        interval: 10 // Update every 10 milliseconds (0.01 seconds)
        repeat: true
        onTriggered: {
            milliseconds += interval
        }
    }

    function startStopwatch() {
        running = true
        stopwatchTimer.start()
    }

    function stopStopwatch() {
        running = false
        stopwatchTimer.stop()
    }

    function resetStopwatch() {
        stopStopwatch()
        milliseconds = 0
    }

    Column {
        anchors.fill: parent

        Label {
            text: "Stopwatch: " + (milliseconds / 1000).toFixed(2) + "s"
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: 24
            color: "white"
        }

        Row {
            spacing: 20
            anchors.horizontalCenter: parent.horizontalCenter

            Button {
                text: running ? "Stop" : "Start"
                onClicked: {
                    if (running) {
                        stopStopwatch()
                    } else {
                        startStopwatch()
                    }
                }
            }

            Button {
                text: "Reset"
                enabled: !running
                onClicked: resetStopwatch
            }
        }
    }
}