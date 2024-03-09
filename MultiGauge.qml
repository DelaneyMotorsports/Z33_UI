/*!
    @file    MultiGauge.qml
    @brief   Multifunctional gauge for displaying various car metrics in the UI.

    MultiGauge is a dynamic component capable of displaying different metrics
    based on user selection or automated context switches. It can show speed,
    RPM, fuel efficiency, and more, using a clean and intuitive interface. This
    component is designed for maximum flexibility and user engagement, enhancing
    the overall experience of monitoring and interacting with the vehicle's
    performance data.

    The design emphasizes ease of switching between metrics, clarity of the
    displayed information, and aesthetic integration with the car's dashboard UI.

    @author  Kevin Delaney
    @date    March 8, 2024
    @company Delaney Motorsports, LLC
    @address Sarasota, FL
*/

import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: multiGauge
    width: 300
    height: 300

    property var metrics: ["Speed", "RPM", "Fuel Efficiency"]
    property int currentMetricIndex: 0

    function nextMetric() {
        currentMetricIndex = (currentMetricIndex + 1) % metrics.length
        metricLabel.text = metrics[currentMetricIndex]
    }

    Rectangle {
        id: background
        anchors.fill: parent
        color: "black"
        radius: 150
    }

    Label {
        id: metricLabel
        text: metrics[currentMetricIndex]
        anchors.centerIn: parent
        color: "white"
        font.pixelSize: 24
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            nextMetric()
        }
    }
}