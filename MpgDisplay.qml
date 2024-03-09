/*!
    @file    MpgDisplay.qml
    @brief   Modern and interactive MPG display component for the car's UI.

    MpgDisplay showcases the vehicle's current fuel efficiency in miles per gallon (MPG),
    using a blend of numerical data and graphical representation. The design is focused on
    modern aesthetics, with smooth transitions and a color scheme that reflects fuel
    efficiency levels. Green signifies high efficiency, while red indicates lower efficiency,
    providing an intuitive and immediate visual cue to the driver.

    This component leverages animations to engage the user, making the driving experience
    both informative and enjoyable. Integration within the MultiGauge system allows for
    a seamless selection among various performance metrics.

    The modern design competes with newer car UIs, offering clarity, interactivity, and
    encouragement for fuel-efficient driving.

    @author  Kevin Delaney
    @date    March 8, 2024
    @company Delaney Motorsports, LLC
    @address Sarasota, FL
*/

import QtQuick 2.15

Item {
    id: mpgDisplay
    width: 300
    height: 150

    property double currentMpg: 0
    property double maxMpg: 60 // Assumes a maximum reasonable MPG to display

    // Background
    Rectangle {
        id: background
        anchors.fill: parent
        color: "#2a2a2a"
        radius: 20
    }

    // MPG Value Display
    Label {
        text: currentMpg.toFixed(1) + " MPG"
        anchors { centerIn: parent }
        color: currentMpg > 40 ? "limegreen" : currentMpg > 20 ? "yellow" : "red"
        font.pixelSize: 28
        font.bold: true
    }

    // MPG Efficiency Bar
    Rectangle {
        id: efficiencyBar
        width: parent.width * (currentMpg / maxMpg)
        height: 10
        color: currentMpg > 40 ? "limegreen" : currentMpg > 20 ? "yellow" : "red"
        anchors { bottom: parent.bottom; left: parent.left; bottomMargin: 20 }
        radius: 5

        Behavior on width { SpringAnimation { damping: 0.2; stiffness: 100; } }
    }
}