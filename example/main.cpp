#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include <QClipboard>

#include "delcolorgenerator.h"

class QmlApi : public QObject
{
    Q_OBJECT

public:
    QmlApi(QObject *parent = nullptr) : QObject{parent} { }

    Q_INVOKABLE void setClipboardText(const QString &text)
    {
        QGuiApplication::clipboard()->setText(text);
    }
};

int main(int argc, char *argv[])
{
    qmlRegisterType<DelColorGenerator>("DelegateUI.Utils", 1, 0, "DelColorGenerator");

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    const QUrl url(u"qrc:/example/Example.qml"_qs);
    engine.rootContext()->setContextProperty("qmlApi", new QmlApi);
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
        &app, [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}

#include "main.moc"
