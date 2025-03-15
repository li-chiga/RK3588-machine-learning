/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @projectName   camera
* @brief         ModelSelect.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @link          www.openedv.com
* @date          2023-03-15
* @link          http://www.openedv.com/forum.php
*******************************************************************/
import QtQuick 2.0

Item {
    width: parent.width
    height: 60
    ListModel {
        id: model
        ListElement {
            textContent: "延时摄影"
        }
        ListElement {
            textContent: "慢动作"
        }
        ListElement {
            textContent: "电影效果"
        }
        ListElement {
            textContent: "视频"
        }
        ListElement {
            textContent: "照片"
        }
        ListElement {
            textContent: "人像"
        }
        ListElement {
            textContent: "全景"
        }
    }

    ListView {
        id: listView
        anchors.centerIn: parent
        width: scaleFfactor * 120
        height: parent.height
        orientation:  ListView.Horizontal
        model: model
        clip: false
        snapMode: ListView.SnapOneItem
        currentIndex: 4
        Component.onCompleted: listView.contentX = 500
        delegate: Item {
            width: scaleFfactor * 120
            height: width / 2
            Text {
                anchors.centerIn: parent
                id: modelText
                text: textContent
                color: listView.currentIndex === index ? "#E3CF57" : "white"
                font.pixelSize: scaleFfactor * 25
            }
            MouseArea {
                anchors.fill: parent
                onClicked: listView.currentIndex = index
            }
        }
    }
}
