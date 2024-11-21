#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include "delcolorgenerate.h"

int main(int argc, char *argv[])
{
    qmlRegisterType<DelColorGenerator>("DelegateUI.Utils", 1, 0, "DelColorGenerator");

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    const QUrl url(u"qrc:/example/Example.qml"_qs);
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
        &app, [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
