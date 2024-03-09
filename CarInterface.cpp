/**
 * @file    CarInterface.cpp
 * @brief   Implementation of CarInterface for managing and accessing car data.
 * 
 * This file implements the functionalities defined in CarInterface.h. It provides
 * mechanisms to update and fetch car data such as voltage, oil pressure, and speed.
 * The class emits signals to notify the QML UI about changes in data, enabling a
 * dynamic and interactive user experience. It serves as a crucial part of the vehicle's
 * head unit system, designed for extensibility and modularity to accommodate additional
 * metrics and functionalities.
 * 
 * Compiler version: g++ 6.3.0
 *
 * @author  Kevin Delaney
 * @date    March 8, 2024
 * @company Delaney Motorsports, LLC
 * @address Sarasota, FL
 */

#include "CarInterface.h"

namespace DelaneyMotorsports {

CarInterface::CarInterface(QObject *parent) : QObject(parent) {
    // Initialize your timer, connect slots, or start data fetching operations here
    m_dataUpdateTimer.setInterval(1000); // Example: Update data every 1 second
    connect(&m_dataUpdateTimer, &QTimer::timeout, this, &CarInterface::onSimulatedDataUpdate);
    m_dataUpdateTimer.start();
}

double CarInterface::voltage() const {
    return m_voltage;
}

double CarInterface::oilPressure() const {
    return m_oilPressure;
}

double CarInterface::speed() const {
    return m_speed;
}

void CarInterface::updateVoltage(double newVoltage) {
    if (m_voltage != newVoltage) {
        m_voltage = newVoltage;
        emit voltageChanged(newVoltage);
    }
}

void CarInterface::updateOilPressure(double newOilPressure) {
    if (m_oilPressure != newOilPressure) {
        m_oilPressure = newOilPressure;
        emit oilPressureChanged(newOilPressure);
    }
}

void CarInterface::updateSpeed(double newSpeed) {
    if (m_speed != newSpeed) {
        m_speed = newSpeed;
        emit speedChanged(newSpeed);
    }
}

void CarInterface::simulateDataFetch() {
    // Simulate fetching data from the car's systems
    // This is just a placeholder for actual data fetching logic
}

void CarInterface::onSimulatedDataUpdate() {
    // Update properties with simulated data
    // This is just a placeholder for the simulation logic
    updateVoltage(12.0); // Simulated voltage value
    updateOilPressure(5.0); // Simulated oil pressure value
    updateSpeed(60.0); // Simulated speed value
}

} // namespace DelaneyMotorsports