QT += remoteobjects
SOURCES += \
        $$PWD/systemuicommonapiclient.cpp \
        $$PWD/volumemonitor.cpp

REPC_REPLICA += \
    ../Repcs/systemuicommonapi.rep

HEADERS += \
    $$PWD/systemuicommonapiclient.h \
    $$PWD/volumemonitor.h

RESOURCES += $$PWD/common.qrc


unix {
    SRC_FILE = $$OUT_PWD/$$TARGET
    DST_FILE = $$OUT_PWD/../ui/src/apps
    QMAKE_POST_LINK += cp $$SRC_FILE $$DST_FILE; \
}
