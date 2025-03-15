/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @projectName   music
* @brief         SearchField.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @link          www.openedv.com
* @date          2023-02-27
*******************************************************************/
import QtQuick 2.0

Item {
    width: parent.width - scaleFfactor * 50
    height: scaleFfactor * 80
    //anchors.horizontalCenter: parent.horizontalCenter
    Row {
        spacing: 20
        anchors.fill: parent
        Rectangle {
            color: "#e9ecf5"
            width: parent.width - scaleFfactor * 64
            height: parent.height
            radius: height / 2
            Image {
                id: searcher_icon
                anchors.verticalCenter: parent.verticalCenter
                source: "qrc:/icons/search_icon.png"
                anchors.left: parent.left
                anchors.leftMargin: scaleFfactor * 25
            }

            Text {
                id: searchContext
                text: qsTr("纯音乐 许嵩")
                color: "#9f9f9f"
                font.pixelSize: scaleFfactor * 30
                anchors.left: searcher_icon.right
                anchors.leftMargin: scaleFfactor * 25
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        Image {
            id: mic_icon
            source: "qrc:/icons/mic_icon.png"
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}
