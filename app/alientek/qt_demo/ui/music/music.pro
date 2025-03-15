QT += quick multimedia

CONFIG += c++11

# The following define makes your compiler emit warnings if you use
# any Qt feature that has been marked deprecated (the exact warnings
# depend on your compiler). Refer to the documentation for the
# deprecated API to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        audiospectrumanalyzer.cpp \
        imageanalyzer.cpp \
        lyricmodel.cpp \
        main.cpp \
        playlistmodel.cpp

RESOURCES += qml.qrc \
    music_src.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/ui/src/apps
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    audiospectrumanalyzer.h \
    imageanalyzer.h \
    lyricmodel.h \
    playlistmodel.h

include(../client/client.pri)
INCLUDEPATH += ../client
include(spectrum/spectrum.pri)
include(3rdparty/fftreal/fftreal.pri)

INCLUDEPATH += spectrum
