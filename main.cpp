#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "CarInterface.h" // Ensure this is the correct path to your CarInterface.h file.

/*!
 * Main entry point for the Z33 Luxury Vehicle UI application.
 * Initializes the application and sets up the QML environment.
 * 
 * Note: Replace placeholders (indicated with <...>) as appropriate for your project.
 * 
 * @author Kevin Delaney
 * @contact Kevin@DelaneyMotorsports.com
 * @date 2024-03-15
 */
int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    // Instantiate your CarInterface implementation.
    // <CarInterfaceImpl> should be replaced with the name of your concrete class that implements CarInterface.
    // Example: DelaneyMotorsports::CarInterfaceImpl carInterface;
    DelaneyMotorsports::<CarInterfaceImpl> carInterface;
    
    // Expose the car interface to QML for UI interaction.
    // The string "carInterface" is how you will reference it in QML. Adjust as needed.
    engine.rootContext()->setContextProperty("carInterface", &carInterface);

    // Load the main QML file.
    // Ensure the path to main.qml is correct. Adjust <main.qml> as necessary.
    const QUrl url(QStringLiteral("qrc:/<main.qml>"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl) {
            QCoreApplication::exit(-1);
        }
    }, Qt::QueuedConnection);
    
    engine.load(url);

    return app.exec();
}