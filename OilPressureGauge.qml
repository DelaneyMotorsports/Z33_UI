/*!
    @file    OilPressureGauge.qml
    @brief   Specialized gauge for displaying oil pressure in the car's UI.

    OilPressureGauge customizes the generic Gauge component to display engine oil
    pressure levels, crucial for monitoring the health and performance of the vehicle's
    engine. It defines specific ranges and colors to alert the user to normal, warning,
    and critical oil pressure states, ensuring the vehicle operates safely and efficiently.

    The gauge's appearance and range values are designed to provide clear, at-a-glance
    information about oil pressure, helping prevent engine damage due to low or high
    pressure conditions.

    @author  Kevin Delaney
    @date    March 8, 2024
    @company Delaney Motorsports, LLC
    @address Sarasota, FL
*/

import QtQuick 2.15

Gauge {
    id: oilPressureGauge
    minValue: 0 // Minimum oil pressure value
    maxValue: 100 // Adjust based on typical high-end oil pressure in psi for your vehicle
    gaugeColor: "#f4a261" // Choosing an orange color to indicate caution or attention
    label: "Oil Pressure (psi)"

    // Implement custom behavior or visualization specific to oil pressure here
    // For example, adjusting the needle's color based on pressure ranges
}