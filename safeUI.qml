import QtQuick 2.0
import QtSafeRenderer 1.0

/*!
 * safeUI.qml defines safety-critical UI elements for the luxury vehicle project.
 * These elements are rendered using Qt Safe Renderer, ensuring they remain visible
 * even in the event of system failure.
 *
 * Elements included:
 * - Speed Indicator: Displays the current speed.
 * - Engine Warning Light: Illuminates if there's an engine issue.
 * - Fuel Low Indicator: Alerts when fuel is critically low.
 *
 * @author Kevin Delaney
 * @contact Kevin@DelaneyMotorsports.com
 */

SafeRenderer {
    // Safe Item for Speed Indicator
    Item {
        id: speedIndicator
        width: 100; height: 50
        property int speed: 0 // This property would be dynamically updated from the vehicle's data
        
        Text {
            text: speed + " mph"
            anchors.centerIn: parent
            color: "white"
        }
    }

    // Safe Item for Engine Warning Light
    Item {
        id: engineWarning
        width: 50; height: 50
        property bool engineFault: false // Dynamically updated
        
        Image {
            source: engineFault ? "qrc:/images/engineWarningOn.png" : "qrc:/images/engineWarningOff.png"
            anchors.fill: parent
        }
    }

    // Safe Item for Fuel Low Indicator
    Item {
        id: fuelLowIndicator
        width: 50; height: 50
        property bool fuelLow: false // Dynamically updated
        
        Image {
            source: fuelLow ? "qrc:/images/fuelLowOn.png" : "qrc:/images/fuelLowOff.png"
            anchors.fill: parent
        }
    }
}