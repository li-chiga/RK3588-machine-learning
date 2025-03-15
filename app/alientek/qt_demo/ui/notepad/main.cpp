#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "systemuicommonapiclient.h"
#include "notepadListModel.h"
#include "filereadwrite.h"

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));
    qputenv("QT_QUICK_BACKEND", "");
    QGuiApplication app(argc, argv);
    qmlRegisterType<SystemUICommonApiClient>("com.alientek.qmlcomponents", 1, 0, "SystemUICommonApiClient");
    qmlRegisterType<NotepadListModel>("com.alientek.qmlcomponents", 1, 0, "NotepadListModel");
    qmlRegisterType<FileReadWrite>("com.alientek.qmlcomponents", 1, 0, "FileReadWrite");
    QQmlApplicationEngine engine;
    engine.addImportPath(":/CustomStyle");
    qputenv("QT_VIRTUALKEYBOARD_STYLE", "greywhite");
    engine.rootContext()->setContextProperty("appCurrtentDir", QCoreApplication::applicationDirPath());
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
