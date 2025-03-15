#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QTextCodec>
#include <QQmlContext>
#include <QFile>
#include "apklistmodel.h"
#include "applistmodel.h"
#include "appstateimage.h"
#include "systemuicommonapiserver.h"
#include "launchintent.h"
#include <QScreen>

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QGuiApplication app(argc, argv);
    qputenv("QT_QUICK_BACKEND", "");
    QTextCodec::setCodecForLocale(QTextCodec::codecForName("UTF-8"));

    QLocale locale(QLocale::Chinese);
    QLocale::setDefault(locale);

    QString hostName;
    QFile file("/etc/hostname");
    if (file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        hostName =  file.readLine().simplified();
        file.close();
        if (hostName == "ATK-DLRK3568") {
            QScreen *screen = QGuiApplication::primaryScreen();
            QRect screenGeometry = screen->geometry();
            if ( screenGeometry.width() == 1080 ) {
                // The rk3568 scales 1080P to 720p for smoothness
                // 參考文檔08、RK官方文档\01、Linux\Linux\Graphics\Rockchip_Developer_Guide_Buildroot_Weston_CN.pdf=>2.16小節
                // rk3568板子，根據RK的UI優化建議，分辨率越大UI性能會不佳，判斷如果是1080P屏幕縮放Weston到720P。
                system("echo \"output:DSI-1:size=720x1280\" >> /tmp/.weston_drm.conf");
            }
        }
    }

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("appCurrtentDir", QCoreApplication::applicationDirPath());
    engine.rootContext()->setContextProperty("hostName", hostName);
    qmlRegisterType<ApkListModel>("com.alientek.qmlcomponents", 1, 0, "ApkListModel");
    qmlRegisterType<AppListModel>("com.alientek.qmlcomponents", 1, 0, "AppListModel");
    qmlRegisterType<AppStateImage>("com.alientek.qmlcomponents", 1, 0, "AppStateImage");
    qmlRegisterType<SystemUICommonApiServer>("com.alientek.qmlcomponents", 1, 0, "SystemUICommonApiServer");
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
