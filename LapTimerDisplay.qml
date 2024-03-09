/*!
    @file    LapTimerDisplay.qml
    @brief   A display component for tracking lap times in performance vehicles.

    LapTimerDisplay is designed for drivers and racers who want to monitor their
    performance on the track. It provides real-time feedback on lap times, helping
    drivers to improve their skills and achieve better results. The display shows
    the current lap time, the last lap time, and the best lap time, offering a
    comprehensive view of the driver's performance.

    The design focuses on clarity and readability, ensuring that the driver can
    quickly glance at the timer and understand their performance without distraction.
    Integration within the MultiGauge system allows this display to be one of several
    selectable options for real-time vehicle monitoring.

    @author  Kevin Delaney
    @date    March 8, 2024
    @company Delaney Motorsports, LLC
    @address Sarasota, FL
*/

import QtQuick 2.15

Item {
    id: lapTimerDisplay
    width: 300
    height: 100

    // Properties to hold lap times
    property double currentLapTime: 0
    property double lastLapTime: 0
    property double bestLapTime: 0

    // Display layout and labels for lap times
    Column {
        anchors.centerIn: parent

        Label {
            text: "Current Lap: " + currentLapTime.toFixed(2) + "s"
            font.pixelSize: 20
            color: "white"
        }
        Label {
            text: "Last Lap: " + lastLapTime.toFixed(2) + "s"
            font.pixelSize: 20
            color: "yellow"
        }
        Label {
            text: "Best Lap: " + bestLapTime.toFixed(2) + "s"
            font.pixelSize: 20
            color: "limegreen"
        }
    }

    // Logic to update lap times can be implemented here, potentially using signals from a timing system

}