/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @projectName   music
* @brief         ControlPanel.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @link          www.openedv.com
* @date          2023-02-27
*******************************************************************/
import QtQuick 2.0

Rectangle {
    id: controlPanel
    height: scaleFfactor * 200
    color: "white"
    width: parent.width

    Row {
        id: row1
        anchors.horizontalCenter: parent.horizontalCenter
        Item {
            width: controlPanel.width / 4
            height: width / 2

                Image {
                    width: parent.width / 2.5
                    height: width
                    anchors.centerIn: parent
                    source: "qrc:/icons/first_page_icon.png"
                }
        }

        Item {
            width: controlPanel.width / 4
            height: width / 2

            Image {
                width: parent.width / 2.5
                height: width
                anchors.centerIn: parent
                source: "qrc:/icons/live_icon.png"
            }
        }

        Item {
            width: controlPanel.width / 4
            height: width / 2

            Image {
                width: parent.width / 2.5
                height: width
                anchors.centerIn: parent
                source: "qrc:/icons/listen_icon.png"
            }
        }

        Item {
            width: controlPanel.width / 4
            height: width / 2

            Image {
                width: parent.width / 2.5
                height: width
                anchors.centerIn: parent
                source: "qrc:/icons/mine_icon.png"
            }
        }
    }

    Row {
        id: row2
        anchors.top: row1.bottom
        anchors.topMargin: - scaleFfactor * 10
        anchors.horizontalCenter: parent.horizontalCenter
        Text {
            width: controlPanel.width / 4
            font.pixelSize: scaleFfactor * 25
            height: scaleFfactor * 40
            text: "首页"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }
        Text {
            width: controlPanel.width / 4
            font.pixelSize: scaleFfactor * 25
            height: scaleFfactor * 40
            text: "直播"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }
        Text {
            width: controlPanel.width / 4
            font.pixelSize: scaleFfactor * 25
            height: scaleFfactor * 40
            text: "随身听"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }
        Text {
            width: controlPanel.width / 4
            font.pixelSize: scaleFfactor * 25
            height: scaleFfactor * 40
            text: "我的"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }
    }
}
