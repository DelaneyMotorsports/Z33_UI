/*!
    @file    FeatureUDisplay.qml
    @brief   Stellar Sky Roof for an immersive celestial experience inside your vehicle.

    The Stellar Sky Roof feature redefines the concept of vehicle luxury, offering passengers
    an unparalleled journey under a customizable night sky. Using state-of-the-art display
    technology, the roof transforms into a vivid representation of the stars and constellations,
    complete with animations like shooting stars and the gentle movement of celestial bodies.

    Passengers can select specific constellations to display, simulate the current night sky based
    on their geographic location, or even enjoy a light show designed to relax or invigorate. This
    feature not only enhances the aesthetic appeal of the vehicle's interior but also creates a
    tranquil environment, making every drive a unique experience.

    The Stellar Sky Roof integrates seamlessly with the vehicle's interior design and lighting
    systems, offering easy control through the infotainment system or voice commands, ensuring
    that this celestial display is as convenient as it is breathtaking.

    @author  Kevin Delaney
    @date    March 8, 2024
    @company Delaney Motorsports, LLC
    @address Sarasota, FL
*/

import QtQuick 2.15

Item {
    id: stellarSkyRoof
    width: 800
    height: 600

    // Simulated properties for demonstration
    property bool shootingStarsEnabled: true
    property string selectedConstellation: "Orion"

    // Imaginary canvas for the night sky
    Rectangle {
        anchors.fill: parent
        color: "black"

        // Stars
        Repeater {
            model: 100 // Number of stars
            delegate: Rectangle {
                x: Math.random() * stellarSkyRoof.width
                y: Math.random() * (stellarSkyRoof.height / 2) // Simulate a half-sky view
                width: 2
                height: 2
                color: "white"
            }
        }

        // Shooting Star Animation
        Rectangle {
            x: 0
            y: 50
            width: 5
            height: 2
            color: "white"
            visible: shootingStarsEnabled

            // Shooting star motion
            Behavior on x {
                NumberAnimation {
                    from: 0
                    to: stellarSkyRoof.width
                    duration: 2000
                    loops: Animation.Infinite
                    running: shootingStarsEnabled
                }
            }
        }

        // Constellation - Example with "Orion"
        // Add in Easter Egg UFO, because why not? 
        // Specific stars or elements representing the selected constellation could be added here
        // For simplicity, this example will focus on the general setup and animations
    }

    // Control logic for selecting constellations, enabling features, and integrating with the vehicle's systems
}