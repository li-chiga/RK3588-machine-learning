/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @projectName   notepad
* @brief         TextEditor.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @link          www.openedv.com
* @date          2021-10-25
*******************************************************************/
import QtQuick 2.12
import QtQuick.VirtualKeyboard 2.4
import QtQuick.VirtualKeyboard.Settings 1.2
import QtQuick.Controls 2.5

Item {
    function clickedFunc() {
        if (textEdit.text.length != 0) {
            fileReadWrite.setNeedToSaveFlag(true)
        } else {
            fileReadWrite.setNeedToSaveFlag(false)
        }

        fileReadWrite.closeFile(textEdit.text)
        notepad_swipeView.currentIndex = 0
        notepadModel.add(appCurrtentDir +  "/resource/txt")
    }

    Button {
        id: back_bt
        anchors.top: parent.top
        anchors.topMargin: scaleFfactor * 60
        anchors.left: parent.left
        anchors.leftMargin: scaleFfactor * 10
        width: scaleFfactor * 110
        opacity: back_bt.pressed ? 0.5 : 1.0
        background: Image {
            width: scaleFfactor * 40
            source: "qrc:/icons/notepad_back_icon.png"
        }
        onClicked: clickedFunc()

        Text {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            text: qsTr("备忘录")
            font.family: "Montserrat Light"
            color: "#e1b844"
            font.pixelSize: scaleFfactor * 25
            font.underline: true
        }
    }

    Button {
        id: done_bt
        anchors.top: parent.top
        anchors.topMargin: scaleFfactor * 60
        anchors.verticalCenter: back_bt.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: scaleFfactor * 10
        width: scaleFfactor * 80
        height: back_bt.height
        opacity: done_bt.pressed ? 0.5 : 1.0
        background: Item {}
        onClicked: clickedFunc()

        Text {
            anchors.centerIn: parent
            text: qsTr("完成")
            font.family: "Montserrat Light"
            color: "#e1b844"
            font.pixelSize: scaleFfactor * 25
            font.underline: true
        }
    }

    Flickable {
        id: flickable
        anchors.top: parent.top
        anchors.topMargin: scaleFfactor * 100
        clip: true
        z: 10
        width: parent.width
        //height: inputPanel.y - 80
        height: inputPanel.y
        contentHeight: textEdit.contentHeight + scaleFfactor * 200

        ScrollBar.vertical: ScrollBar {
            id: scrollBar
            width: scaleFfactor * 10
            onActiveChanged: {
                active = true
            }
            Component.onCompleted: {
                scrollBar.active = true
            }
            contentItem: Rectangle{
                implicitWidth: scaleFfactor * 10
                implicitHeight: scaleFfactor * 60
                radius: width / 2
                color: scrollBar.hovered ? "#88101010" : "#30101010"
            }
            background: Rectangle {
                anchors.fill: parent
                color: "transparent"
            }
        }
        TextEdit   {
            id: textEdit
            clip: true
            anchors.top: parent.top
            height: contentHeight
            font.pixelSize: scaleFfactor * 50
            anchors.left: parent.left
            anchors.leftMargin: scaleFfactor * 20
            anchors.right: parent.right
            anchors.rightMargin: scaleFfactor * 20
            text:  notepad_swipeView.currentIndex === 1 ? fileReadWrite.content() : ""
            wrapMode: TextEdit.WrapAnywhere
            mouseSelectionMode: TextInput.SelectCharacters
            selectByMouse: true
            cursorVisible: textEdit.focus // bug fixed
        }
    }
    Connections {
        target: notePadLayout
        function onVisibleChanged() {
            if (!visible)
                textEdit.focus = false
        }
    }

    InputPanel {
        id: inputPanel
        z: 99
        x: 0
        y: app_notepad.height
        width: app_notepad.width
        //active: notePadLayout.visible && notepad_swipeView.currentIndex === 1 && textEdit.focus

        states: State {
            name: "visible"
            when: inputPanel.active
            PropertyChanges {
                target: inputPanel
                y: app_notepad.height - inputPanel.height - scaleFfactor * 50
            }
        }
        transitions: Transition {
            from: ""
            to: "visible"
            reversible: true
            ParallelAnimation {
                NumberAnimation {
                    properties: "y"
                    duration: 50
                    easing.type: Easing.InOutQuad
                }
            }
        }
    }

    Binding {
        target: VirtualKeyboardSettings
        property: "activeLocales"
        value: ["zh_CN","en_US"]
    }
}
