/**
 * @file    CarInterface.h
 * @brief   Interface for accessing and managing car data.
 * 
 * CarInterface provides an abstraction layer over the vehicle's data, such as voltage,
 * oil pressure, speed, and more. It includes functionalities to fetch and update these
 * data points, emitting signals to the QML UI whenever changes occur. This allows for
 * a responsive and interactive user interface in the vehicle's head unit system.
 * Designed with modularity and extensibility in mind, CarInterface can be easily
 * adapted or extended to include additional metrics and functionalities as needed.
 *
 * Compiler version: g++ 6.3.0
 *
 * @author  Kevin Delaney
 * @date    March 8, 2024
 * @company Delaney Motorsports, LLC
 * @address Sarasota, FL
 */

#ifndef CARINTERFACE_H
#define CARINTERFACE_H

#include <QObject>
#include <QTimer>

namespace DelaneyMotorsports {

class CarInterface : public QObject {
    Q_OBJECT

    Q_PROPERTY(double voltage READ voltage NOTIFY voltageChanged)
    Q_PROPERTY(double oilPressure READ oilPressure NOTIFY oilPressureChanged)
    Q_PROPERTY(double speed READ speed NOTIFY speedChanged)

public:
    explicit CarInterface(QObject *parent = nullptr);

    double voltage() const;
    double oilPressure() const;
    double speed() const;

signals:
    void voltageChanged(double newVoltage);
    void oilPressureChanged(double newOilPressure);
    void speedChanged(double newSpeed);

public slots:
    void updateVoltage(double newVoltage);
    void updateOilPressure(double newOilPressure);
    void updateSpeed(double newSpeed);

private:
    double m_voltage{0.0};
    double m_oilPressure{0.0};
    double m_speed{0.0};
    QTimer m_dataUpdateTimer;

    void simulateDataFetch();
    void onSimulatedDataUpdate();

private slots:
    void handleDataUpdateTimerTimeout();
};

} // namespace DelaneyMotorsports

#endif // CARINTERFACE_H