#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QTextCodec>
#include <QFile>
#include "systemuicommonapiclient.h"

int main(int argc, char *argv[])
{
    QTextCodec::setCodecForLocale(QTextCodec::codecForName("UTF-8"));
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    qputenv("QT_QUICK_BACKEND", "");
    QString hostName;
    QFile file("/etc/hostname");
    if (file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        hostName =  file.readLine().simplified();
        file.close();
    }

    QGuiApplication app(argc, argv);
    qmlRegisterType<SystemUICommonApiClient>("com.alientek.qmlcomponents", 1, 0, "SystemUICommonApiClient");
    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("appCurrtentDir", QCoreApplication::applicationDirPath());
    engine.rootContext()->setContextProperty("hostName", hostName);
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreated,
        &app,
        [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        },
        Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
