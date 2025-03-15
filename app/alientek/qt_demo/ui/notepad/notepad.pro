QT += quick virtualkeyboard

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        filereadwrite.cpp \
        main.cpp \
        notepadListModel.cpp

RESOURCES += qml.qrc \
    greywhite/virtualkeyboard_custom_style.qrc \
    notepad_icons.qrc \
    notepad_qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/ui/src/apps
!isEmpty(target.path): INSTALLS += target

include(../client/client.pri)
INCLUDEPATH += ../client

HEADERS += \
    filereadwrite.h \
    notepadListModel.h
