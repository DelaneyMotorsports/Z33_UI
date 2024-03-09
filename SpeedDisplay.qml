/*!
    @file    SpeedDisplay.qml
    @brief   Dedicated display component for vehicle speed within the MultiGauge interface.

    SpeedDisplay is designed to provide a clear and immediate understanding of the vehicle's
    current speed. The component combines digital readout with graphical elements to ensure
    the speed is easily readable under various conditions. The design aligns with modern
    automotive standards, offering a blend of aesthetic appeal and functional clarity.

    The component can be easily integrated into the MultiGauge system, serving as one of
    the selectable displays for monitoring real-time vehicle performance metrics.

    @author  Kevin Delaney
    @date    March 8, 2024
    @company Delaney Motorsports, LLC
    @address Sarasota, FL
*/

import QtQuick 2.15

Item {
    id: speedDisplay
    width: 300
    height: 300

    // Assuming 'currentSpeed' is a property bound to the car's actual speed data
    property double currentSpeed: 0

    // Background for aesthetic purposes
    Rectangle {
        anchors.fill: parent
        color: "#1e1e1e"
        radius: 150
    }

    // Digital Speed Readout
    Label {
        id: speedLabel
        text: currentSpeed.toFixed(0) + " mph"
        anchors.centerIn: parent
        color: "#00ff00" // Bright green for high visibility
        font.pixelSize: 48
        font.bold: true
    }

    // Additional graphical elements like a semi-circular speed arc could be added here
}