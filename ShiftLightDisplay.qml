/*!
    @file    ShiftLightDisplay.qml
    @brief   Visual indicator for optimal gear shifting in performance vehicles.

    ShiftLightDisplay provides a clear, immediate signal to the driver when the optimal
    RPM for shifting gears is reached. Designed for performance and racing applications,
    this component changes color or becomes visually prominent as the engine approaches
    and hits the target RPM range, assisting in achieving peak vehicle performance.

    The component's design is focused on visibility and instant recognition, ensuring
    drivers can react quickly without distracting from the driving experience.

    Integration within the MultiGauge system allows this display to be one of several
    selectable options for real-time performance monitoring.

    @author  Kevin Delaney
    @date    March 8, 2024
    @company Delaney Motorsports, LLC
    @address Sarasota, FL
*/

import QtQuick 2.15

Item {
    id: shiftLightDisplay
    width: 200
    height: 50

    // Property bound to the vehicle's current RPM
    property double currentRPM: 0
    // RPM threshold for optimal shifting
    property double shiftRPM: 6500

    Rectangle {
        anchors.fill: parent
        color: currentRPM >= shiftRPM ? "red" : "grey"
        radius: 10

        Label {
            text: "SHIFT NOW"
            anchors.centerIn: parent
            visible: currentRPM >= shiftRPM
            color: "white"
            font.pixelSize: 24
            font.bold: true
        }
    }

    // Animation or additional visual effects could be added here for when the shift condition is met
}