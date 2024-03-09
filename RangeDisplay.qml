/*!
    @file    RangeDisplay.qml
    @brief   Modern display component for showing the vehicle's estimated range.

    RangeDisplay provides the driver with a clear and concise view of the estimated
    distance the vehicle can travel on its current fuel or charge level. The design
    emphasizes simplicity and readability, incorporating modern visual elements to
    ensure that the information integrates well with newer car dashboards.

    The component uses a dynamic visual indicator alongside a numeric readout, offering
    a quick understanding of the range status at a glance. The color and animation
    adapt based on the range level, visually cueing the driver to low range situations.

    This component enhances driver awareness and confidence in vehicle performance,
    especially in critical travel or commuting scenarios.

    @author  Kevin Delaney
    @date    March 8, 2024
    @company Delaney Motorsports, LLC
    @address Sarasota, FL
*/

import QtQuick 2.15

Item {
    id: rangeDisplay
    width: 300
    height: 150

    property double currentRange: 0  // The current estimated range in miles or kilometers
    property double maxRange: 400    // Maximum range of the vehicle under ideal conditions

    // Background for aesthetic and contrast
    Rectangle {
        anchors.fill: parent
        color: "#333333"
        radius: 20
    }

    // Numeric readout of the range
    Label {
        text: currentRange.toFixed(0) + " mi"
        anchors.centerIn: parent
        color: "white"
        font.pixelSize: 28
        font.bold: true
    }

    // Visual indicator (e.g., a horizontal bar) showing the relative range
    Rectangle {
        id: rangeIndicator
        width: parent.width * (currentRange / maxRange)
        height: 5
        color: currentRange < maxRange * 0.2 ? "red" : "limegreen"
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.bottomMargin: 20
        radius: 2.5

        Behavior on width { SpringAnimation { damping: 0.2; stiffness: 100; } }
    }
}