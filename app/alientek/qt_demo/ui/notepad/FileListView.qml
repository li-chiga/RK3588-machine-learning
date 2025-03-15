/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @projectName   QDesktop
* @brief         FileListView.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @link          www.openedv.com
* @date          2021-10-27
*******************************************************************/
import QtQuick 2.12
import QtQuick.Controls 2.5

Item {
    Text {
        id: appTitle
        text: qsTr("备忘录")
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: scaleFfactor * 60
        font.pixelSize: scaleFfactor * 30
    }

    ListView  {
        id: fileListView
        visible: true
        anchors.top: appTitle.bottom
        anchors.topMargin: scaleFfactor * 25
        anchors.bottom: parent.bottom
        anchors.bottomMargin: scaleFfactor * 130
        width: parent.width
        orientation:ListView.Vertical
        clip: true
        model: notepadModel
        onCurrentIndexChanged: {
            notepadModel.currentIndex = currentIndex
        }
        delegate: Rectangle {
            id: itembg
            clip: true
            width: fileListView.width
            height: scaleFfactor * 100
            color: mouseArea.pressed ? "#88d7c388" : "transparent"
            Behavior on color { PropertyAnimation { duration: 200; easing.type: Easing.InOutBack } }
            MouseArea {
                id: mouseArea
                anchors.fill: parent
                onClicked: {
                    fileListView.currentIndex = index
                    fileReadWrite.openFile(path)
                    notepad_swipeView.currentIndex = 1
                }

                onPressAndHold: {
                    fileListView.currentIndex = index
                    removeFile_drawer_bottom.open()
                }
            }

            Rectangle {
                anchors.top: parent.top
                width: parent.width - scaleFfactor * 20
                anchors.right: parent.right
                height: 1
                color: "#c6c6c8"
                visible: index == 0
                clip: true
            }

            Rectangle {
                anchors.bottom: parent.bottom
                width: parent.width - scaleFfactor * 20
                anchors.right: parent.right
                height: 1
                color: "#c6c6c8"
                clip: true
            }

            Text {
                id: content_text
                width: parent.width
                text:  content
                elide: Text.ElideRight
                font.pixelSize: scaleFfactor * 25
                anchors.left: parent.left
                anchors.leftMargin: scaleFfactor * 20
                anchors.bottom: parent.verticalCenter
                color: "black"
            }

            Text {
                id: lastUpdate_text
                width: parent.width
                text: lastModified
                elide: Text.ElideRight
                font.pixelSize: scaleFfactor * 25
                anchors.left: parent.left
                anchors.leftMargin: scaleFfactor * 20
                anchors.top: parent.verticalCenter
                color: "#c6c6c8"
            }
        }
    }

    Button {
        id: editor_bt
        anchors.top: fileListView.bottom
        anchors.right: parent.right
        anchors.rightMargin: scaleFfactor * 10
        opacity: editor_bt.pressed ? 0.5 : 1.0
        background: Image {
            width: scaleFfactor * 50
            height: width
            source: "qrc:/icons/pen_icon.png"
        }
        onClicked:  {
            fileReadWrite.newFile(appCurrtentDir +  "/resource/txt/" + Qt.formatDateTime(new Date(), "AP-hh-mm-ss" ) + ".txt")
            notepad_swipeView.currentIndex = 1
        }
    }

    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        text: notepadModel.count + "个备忘录"
        anchors.top: fileListView.bottom
        font.pixelSize: scaleFfactor * 25
    }
}
