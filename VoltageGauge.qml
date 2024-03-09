/*!
    @file    VoltageGauge.qml
    @brief   Specialized gauge for displaying voltage in the car's UI.

    VoltageGauge extends the generic Gauge component to specifically represent
    electrical voltage levels within the vehicle. It presets certain properties
    such as label, color, and range to values that are suitable for voltage monitoring,
    ensuring that it visually stands out and is immediately recognizable to the user.

    The gauge is calibrated for a typical automotive voltage range, highlighting
    critical thresholds that may indicate charging issues or electrical system health.

    @author  Kevin Delaney
    @date    March 8, 2024
    @company Delaney Motorsports, LLC
    @address Sarasota, FL
*/

import QtQuick 2.15

// Assuming Gauge.qml is in the same directory or accessible via QML import paths
Gauge {
    id: voltageGauge
    minValue: 0 // Minimum voltage typically expected
    maxValue: 16 // Maximum voltage to display
    gaugeColor: "#e63946" // A color indicating electrical or energy, like red for alert or green for safe
    label: "Voltage"

    // Customize further properties or add animations as needed
}