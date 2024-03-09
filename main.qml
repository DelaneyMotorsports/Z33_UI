/*!
    @file    main.qml
    @brief   Main user interface for the car's head unit system.

    This QML file defines the main window and layout of the car's head unit interface,
    incorporating gauges for voltage, oil pressure, and a multifunctional digital gauge
    that displays various metrics like speed, fuel efficiency, and navigation details.
    The design emphasizes clarity, ease of use, and aesthetic appeal, drawing inspiration
    from high-end automotive standards.

    The interface is built to be modular, allowing for easy addition and integration of new
    components and functionalities. It showcases the application's main features and provides
    the user with interactive access to the car's performance and status metrics.

    @author  Kevin Delaney
    @date    March 8, 2024
    @company Delaney Motorsports, LLC
    @address Sarasota, FL
    @compiler    Qt QML Module version 5.15.2
*/

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import DelaneyMotorsports 1.0

ApplicationWindow {
    visible: true
    width: 1024
    height: 600
    title: "Delaney Motorsports - Dashboard"

    // Use a StackLayout for managing different views or components
    StackLayout {
        id: mainLayout
        anchors.fill: parent

        // Example gauge components
        VoltageGauge {
            id: voltageGauge
        }

        OilPressureGauge {
            id: oilPressureGauge
        }

        MultiGauge {
            id: multiGauge
            // Property bindings or additional configuration for MultiGauge
        }
    }

    // Additional UI components like menus, buttons, or status bars can be added here
}