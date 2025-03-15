/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @projectName   player
* @brief         MorePro.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @link          www.openedv.com
* @date          2023-03-08
* @link          http://www.openedv.com/forum.php
*******************************************************************/
import QtQuick 2.0
import QtQuick.Controls 2.14

Item {
    property bool opened: false
    anchors.fill: parent
    Rectangle {
        color: "#292421"
        radius: scaleFfactor * 25
        id: start_your_pro
        width: parent.width
        height: parent.height / 2
        z: 10
        x: 5
        y: app_player.height - scaleFfactor * 180
        Behavior on y { PropertyAnimation { duration: control_duration; easing.type: Easing.OutQuad } }

        MouseArea {
            anchors.fill: parent
            drag.target: parent
            drag.minimumX: 0
            drag.minimumY: app_player.height / 2
            drag.maximumX: 0
            drag.maximumY: app_player.height - scaleFfactor * 180
            property int dragY
            onPressed: {
                dragY = parent.y
            }
            onReleased: {
                if (parent.y - dragY >= scaleFfactor * 100)
                    start_your_pro.close()
                else
                    start_your_pro.open()
            }
        }

        function open() {
            control_duration = 200
            start_your_pro.y = app_player.height  / 2
            opened = true
        }

        function close() {
            start_your_pro.y = app_player.height - scaleFfactor * 180
            opened = false
        }


        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: scaleFfactor * 10
            width: scaleFfactor * 100
            height: scaleFfactor * 10
            radius: height / 2
            color: "#393431"
        }

        Button {
            width: scaleFfactor * 100
            height: scaleFfactor * 50
            anchors.horizontalCenter: parent.horizontalCenter
            background: Item {}
            onClicked: {
                if (opened)
                    start_your_pro.close()
                else
                    start_your_pro.open()
            }
        }

        Rectangle {
            anchors.top: parent.top
            anchors.topMargin: scaleFfactor * 120
            width: parent.width
            height: scaleFfactor * 1
            color: "#393431"
        }

        Text {
            text: qsTr("开始项目")
            color: "white"
            font.pixelSize: scaleFfactor * 35
            font.bold: true
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: scaleFfactor * 50
        }

        Column {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: scaleFfactor * 180
            width: parent.width - scaleFfactor * 50
            height: contentItem.height
            spacing: scaleFfactor * 25
            Rectangle {
                width: parent.width
                radius: scaleFfactor * 25
                color: "#393431"
                height: scaleFfactor * 120
            }

            Rectangle {
                width: parent.width
                radius: scaleFfactor * 25
                color: "#393431"
                height: scaleFfactor * 120
            }

            Rectangle {
                width: parent.width
                radius: scaleFfactor * 25
                color: "#393431"
                height: scaleFfactor * 120
            }
        }
    }
}
