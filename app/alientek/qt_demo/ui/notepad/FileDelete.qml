/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @projectName   notepad
* @brief         FileDelete.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @link          www.openedv.com
* @date          2021-10-26
*******************************************************************/
import QtQuick 2.0
import QtQuick.Controls 2.5

Item {
    id: file

    Column {
        id: column1
        width: parent.width - scaleFfactor * 50
        //height: parent.height / 2
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: scaleFfactor * 80
        spacing: scaleFfactor * 10
        Rectangle {
            id: rectBg1
            color: "#f0f0f0"
            radius: scaleFfactor * 25
            width: parent.width
            height: scaleFfactor * 200
            Column {
                id: app_fileView_row1
                anchors.centerIn: parent
                spacing: 0
                Item {
                    height: rectBg1.height / 2 + scaleFfactor * 10
                    width: rectBg1.width
                    Text {
                        color: "#8e8e93"
                        font.family: "Montserrat Light"
                        font.pixelSize: scaleFfactor * 30
                        text: qsTr("您要将此文本移除吗？")
                        anchors.centerIn: parent
                    }
                }
                Rectangle {
                    width: column1.width
                    height: 1
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "#d2d3d5"
                }

                Button {
                    id: delete_bt
                    checked: true
                    height: rectBg1.height / 2 - scaleFfactor * 11
                    width: rectBg1.width
                    anchors.horizontalCenter: parent.horizontalCenter
                    background: CustomRectangle {
                        anchors.fill: parent
                        radius: rectBg1.radius
                        color: parent.pressed ? "#dddddd" : "transparent"
                        radiusCorners:  Qt.AlignLeft | Qt.AlignRight | Qt.AlignBottom
                        Text {
                            font.pixelSize: scaleFfactor * 30
                            text: qsTr("删除")
                            font.family: "Montserrat Light"
                            anchors.centerIn: parent
                            color: "#ff3b30"
                        }
                    }
                    onClicked: {
                        notepadModel.removeOne(notepadModel.currentIndex)
                        drawerClosed()
                    }
                }
            }
        }
        Item  {
            width: parent.width
            //height: column1.height - rectBg1.height - 20
            height: scaleFfactor * 100
            Button {
                anchors.fill: parent
                background: Rectangle {
                    anchors.fill: parent
                    color: parent.pressed ? "#dddddd" : "white"
                    radius: height / 5
                    Text {
                        text: qsTr("取消")
                        font.family: "Montserrat Light"
                        anchors.centerIn: parent
                        color: "#007aff"
                        font.pixelSize: scaleFfactor * 30
                        font.bold: true
                    }
                }
                onClicked: {
                   drawerClosed()
                }
            }
        }
    }
}
