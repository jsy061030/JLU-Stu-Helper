#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "WeatherParser.h"
#include "SystemHelper.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    // 创建并注册C++对象到QML上下文
    WeatherParser weatherParser;
    SystemHelper systemHelper;

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("weatherParser", &weatherParser);
    engine.rootContext()->setContextProperty("systemHelper", &systemHelper);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QGuiApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("Win1", "Main");

    return app.exec();
}
