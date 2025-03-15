QT += quick

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        main.cpp \
        volumecontrol.cpp \
        volumecontrolthread.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/ui/src/apps
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    volumecontrol.h \
    volumecontrolthread.h
unix {
    SRC_FILE = $$OUT_PWD/$$TARGET
    DST_FILE = $$OUT_PWD/../ui/src/apps
    QMAKE_POST_LINK += cp $$SRC_FILE $$DST_FILE;
}

