#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QTextCodec>
#include "systemuicommonapiclient.h"
#include "volumemonitor.h"
#include <QQmlContext>
#include <QDir>

#include "lyricmodel.h"
#include "playlistmodel.h"
#include "imageanalyzer.h"
#include "audiospectrumanalyzer.h"
#include <QQmlEngine>

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QTextCodec::setCodecForLocale(QTextCodec::codecForName("UTF-8"));
    qputenv("QT_QUICK_BACKEND","");
    QGuiApplication app(argc, argv);
    qmlRegisterType<SystemUICommonApiClient>("com.alientek.qmlcomponents", 1, 0, "SystemUICommonApiClient");
    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("appCurrtentDir", QCoreApplication::applicationDirPath());
    qmlRegisterType<lyricModel>("com.alientek.qmlcomponents", 1, 0, "LyricModel");
    qmlRegisterType<playListModel>("com.alientek.qmlcomponents", 1, 0, "PlayListModel");
    qmlRegisterType<ImageAnalyzer>("com.alientek.qmlcomponents", 1, 0, "ImageAnalyzer");
    qmlRegisterType<AudioSpectrumAnalyzer>("com.alientek.qmlcomponents", 1, 0, "AudioSpectrumAnalyzer");
    qmlRegisterType<VolumeMonitor>("com.alientek.qmlcomponents", 1, 0, "VolumeMonitor");

    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
        &app, [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        }, Qt::QueuedConnection);
    engine.load(url);

    QObject *root = engine.rootObjects().first();
    QObject *qmlAudio = root->findChild<QObject *>("myAudio");
    QMediaPlayer *player = qvariant_cast<QMediaPlayer *>(qmlAudio->property("mediaObject"));

    engine.rootContext()->setContextProperty("myplayer", player);

    return app.exec();
}
