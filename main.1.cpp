
#include <QQmlApplicationEngine>
#include "SystemHelper.h"
#include "WeatherParser.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    SystemHelper systemHelper;
    WeatherParser weatherParser;
    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("systemHelper", &systemHelper);
    engine.rootContext()->setContextProperty("weatherParser", &weatherParser);
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QGuiApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("Win1", "Main");

    return app.exec();
}
