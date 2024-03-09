/*!
    @file    CompassDisplay.qml
    @brief   Elegant and functional compass display for the car's UI.

    CompassDisplay offers drivers a clear, real-time indication of the vehicle's
    directional heading, enhancing navigation and situational awareness. The design
    is focused on simplicity and elegance, featuring a minimalist aesthetic that
    complements modern car dashboards. 

    The component dynamically updates to reflect changes in direction, using smooth
    animations to rotate the compass. Color accents and subtle visual cues guide the
    driver, making it easy to interpret heading information at a glance.

    This compass display is an essential tool for navigation, merging functionality
    with style to improve the driving experience.

    @author  Kevin Delaney
    @date    March 8, 2024
    @company Delaney Motorsports, LLC
    @address Sarasota, FL
*/

import QtQuick 2.15

Item {
    id: compassDisplay
    width: 200
    height: 200

    property double direction: 0 // Direction in degrees

    // Compass circle
    Rectangle {
        id: background
        anchors.centerIn: parent
        width: parent.width * 0.8
        height: parent.height * 0.8
        color: "#1e1e1e"
        border.color: "#76b5c5"
        border.width: 3
        radius: background.width / 2
    }

    // Direction indicator (N)
    Label {
        text: "N"
        font.pixelSize: 24
        color: "white"
        anchors {
            bottom: background.top
            horizontalCenter: background.horizontalCenter
            bottomMargin: 10
        }
        rotation: -direction
        Behavior on rotation { RotationAnimation { duration: 500 } }
    }

    // Additional cardinal points (E, S, W) and intermediate directions can be added similarly

    // Dynamic rotation based on direction property
    background.rotation: -direction
    Behavior on rotation { RotationAnimation { duration: 500 } }
}