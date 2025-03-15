/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @brief         Page1.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @date          2024-04-07
* @link          http://www.openedv.com/forum.php
*******************************************************************/
import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.12
import com.alientek.qmlcomponents 1.0
Item {
    id: page1
    ApkListModel {
        id: apkListModel
        Component.onCompleted: apkListModel.add(appCurrtentDir + "/src/"+ hostName +"/apk1.cfg")
    }

    ColumnLayout {
        id: columnLayout1
        width: control_item.width
        height: control_item.height / 3 * 1

        Row {
            id: row
            Layout.alignment: Qt.AlignCenter
            spacing:  control_item.width / 13
            Rectangle {
                color: "#DDDDDD"
                radius: desktop.width / 14.4
                width: desktop.width / 2.5
                height: width
                id: calendarRect
                anchors.verticalCenter: parent.verticalCenter
                RowLayout {
                    spacing: 10
                    id: rowLayout1
                    height: parent.height / 3
                    anchors.right: parent.right
                    anchors.rightMargin: desktop.width / 720 * 25
                    anchors.left: parent.left
                    anchors.leftMargin: desktop.width / 720 * 25

                    Text {
                        id: dateText
                        width: dateText.contentWidth
                        text: systemTime.system_date3
                        font.pixelSize: desktop.width / 720 * 45
                        color: "black"
                        Layout.alignment: Qt.AlignVCenter
                    }

                    Rectangle {
                        height: calendarRect.height / 5
                        color: "gray"
                        width: 1
                        Layout.alignment: Qt.AlignVCenter
                    }
                    Text {
                        id: weekText
                        width: weekText.contentWidth
                        text: systemTime.system_week
                        height: weekText.contentHeight
                        font.pixelSize: desktop.width / 720 * 25
                        color: "#E3170D"
                        font.bold: true
                        Layout.alignment: Qt.AlignVCenter
                    }
                    Item {
                        Layout.fillWidth: true
                    }

                }

                ColumnLayout {
                    spacing: 10
                    height: parent.height / 3 * 2
                    anchors.right: parent.right
                    anchors.rightMargin: desktop.width / 720 * 25
                    anchors.left: parent.left
                    anchors.leftMargin: desktop.width / 720 * 25
                    anchors.top: rowLayout1.bottom
                    Text {
                        id: timeText
                        text: systemTime.system_time
                        font.bold: false
                        color: "black"
                        font.pixelSize: desktop.width / 720 * 50
                        font.letterSpacing: 3
                        Layout.alignment: Qt.AlignVCenter
                    }
                    Text {
                        text: "今日无日程"
                        font.pixelSize: desktop.width / 720 * 30
                        color: "#AAAAAA"
                        Layout.alignment: Qt.AlignVCenter
                    }
                }
                Text {
                    anchors.top: parent.bottom
                    anchors.topMargin: desktop.width / 720 * 5
                    visible: true
                    anchors.horizontalCenter: parent.horizontalCenter
                    horizontalAlignment: Text.AlignHCenter
                    text: qsTr("日历")
                    color: "white"
                    font.pixelSize: desktop.width / 720 * 20
                    font.bold: true
                }

            }
            Rectangle {
                color: "white"
                radius: desktop.width / 14.4
                width: desktop.width / 2.5
                height: width
                anchors.verticalCenter: parent.verticalCenter
                visible: true
                Image {
                    id: photo
                    source: "file:///" + appCurrtentDir + "/src/apps/resource/images/雪.jpeg"
                    fillMode: Image.PreserveAspectCrop
                    anchors.fill: parent
                    visible: false
                    Rectangle {
                        anchors.fill: parent
                        color: "#3380878A"
                    }
                }
                OpacityMask {
                    anchors.fill: parent
                    source: photo
                    maskSource: parent
                    cached: true
                }

                Column {
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: desktop.width / 720 * 25
                    anchors.left: parent.left
                    anchors.leftMargin: desktop.width / 720 * 25
                    Text {
                        horizontalAlignment: Text.AlignHCenter
                        text: qsTr("行思坐忆")
                        color: "white"
                        font.pixelSize: desktop.width / 720 * 35
                        font.bold: true
                    }

                    Text {
                        horizontalAlignment: Text.AlignHCenter
                        text: qsTr("那些年，一起走过的路")
                        color: "white"
                        font.pixelSize: desktop.width / 720 * 25
                        font.bold: false
                    }
                }
                Text {
                    anchors.top: parent.bottom
                    anchors.topMargin: desktop.width / 720 * 5
                    visible: true
                    anchors.horizontalCenter: parent.horizontalCenter
                    horizontalAlignment: Text.AlignHCenter
                    text: qsTr("照片")
                    color: "white"
                    font.pixelSize: desktop.width / 720 * 20
                    font.bold: true
                }
            }
        }
    }
    ColumnLayout {
        id: columnLayout2
        width: control_item.width
        height: control_item.height / 3 * 2
        y:  control_item.height / 3
        GridView {
            Layout.alignment: Qt.AlignHCenter
            Layout.fillHeight: true
            width: control_item.width - control_item.width / 13
            height: control_item.width / 4 * 3  // three column
            id: item_gridView
            visible: true
            interactive: false
            clip: false
            snapMode: ListView.SnapOneItem
            cellWidth: item_gridView.width / 4
            cellHeight: cellWidth * 1.2
            model: apkListModel
            delegate: item_gridView_delegate
        }
    }

    Component {
        id: item_gridView_delegate
        Button {
            id: appButton
            width: item_gridView.cellWidth
            height: item_gridView.cellHeight
            enabled: installed
            onClicked: {
                callApp(programName, mapToGlobal(appIcon.x, appIcon.y).x, mapToGlobal(appIcon.x, appIcon.y).y, appIcon, apkIconPath, 0, main_swipeView.currentIndex)
            }

            background: Image {
                id: appIcon
                anchors.centerIn: parent
                width: desktop.width / 6.5
                height: width
                source: apkIconPath
                visible: systemUICommonApiServer.currtentLauchAppName !== programName
            }

            Image {
                id: appIcon2
                anchors.centerIn: parent
                width: appIcon.width
                height: width
                source: apkIconPath
                visible: systemUICommonApiServer.firstTimeStart
            }

            Text {
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                text: apkName
                color: "white"
                font.pixelSize: desktop.width / 720 * 20
                font.bold: true
            }

            Colorize {
                id: colorize1
                anchors.fill: appIcon2
                source: appIcon2
                saturation: 0.0
                lightness: -1.0
                opacity: 0.2
                cached: true
                visible: appButton.pressed
            }

        }
    }
}
