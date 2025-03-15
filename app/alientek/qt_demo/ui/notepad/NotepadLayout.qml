/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @projectName   notepad
* @brief         NotepadLayout.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @link          www.openedv.com
* @date          2023-03-19
* @link          http://www.openedv.com/forum.php
*******************************************************************/
import QtQuick 2.0
import QtQuick.Controls 2.14
import com.alientek.qmlcomponents 1.0
Item {
    id: notePadLayout
    anchors.fill: parent
    property real scaleFfactor: app_notepad.width / 720
    property QtObject notepadModel
    signal drawerClosed()

    Loader {
        id: loader
        anchors.fill: parent
        asynchronous: true
        Component.onCompleted:  loader.sourceComponent = component
    }

    Component {
        id: component
        Item {
            NotepadListModel {
                id: m_notepadModel
                Component.onCompleted: {
                    m_notepadModel.add(appCurrtentDir +  "/resource/txt")
                    notepadModel = m_notepadModel
                }
            }
        }
    }

    FileReadWrite {
        id: fileReadWrite
    }

    Rectangle {
        anchors.fill: parent
        color: "#f7f7f7"
    }

    onDrawerClosed:{
        removeFile_drawer_bottom.close()
    }


    SwipeView {
        id: notepad_swipeView
        visible: true
        anchors.fill: parent
        clip: true
        interactive: false
        FileListView { }
        TextEditor { }
    }

    Rectangle {
        anchors.fill: parent
        color: "#33101010"
        visible: removeFile_drawer_bottom.y === app_notepad.height - scaleFfactor * 400
    }

    Item {
        id: removeFile_drawer_bottom
        width: parent.width
        height: scaleFfactor * 400
        z: 10
        x: 0
        visible: false
        y: parent.height
        Behavior on y { PropertyAnimation { duration: 250; easing.type: Easing.OutQuad } }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                removeFile_drawer_bottom.close()
            }
        }

        FileDelete {
            id: fileDelete
            anchors.fill: parent
        }

        function open() {
            removeFile_drawer_bottom.visible = true
            removeFile_drawer_bottom.y = app_notepad.height - scaleFfactor * 400
        }

        function close() {
            removeFile_drawer_bottom.y = app_notepad.height

        }
    }
}
