/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @projectName   music
* @brief         SituationSelection.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @link          www.openedv.com
* @date          2023-02-27
*******************************************************************/
import QtQuick 2.0

Item {
    width: parent.width
    //anchors.horizontalCenter: parent.horizontalCenter
    height: scaleFfactor * 120
    ListModel {
        id: situationModel
        ListElement {name: "推荐"}
        ListElement {name: "视频"}
        ListElement {name: "音频"}
        ListElement {name: "小说"}
        ListElement {name: "国语"}
        ListElement {name: "英语"}
        ListElement {name: "纯音乐"}
        ListElement {name: "流行"}
        ListElement {name: "国风"}
    }

    ListView {
        id: situationListView
        anchors.fill: parent
        model: situationModel
        clip: true
        orientation:  ListView.Horizontal
        currentIndex : 0
        delegate: Item {
            width: situationListView.width / 6
            height: situationListView.height
            Text {
                text: name
                font.pixelSize: situationListView.currentIndex === index ? scaleFfactor * 50 : scaleFfactor * 30
                font.bold: situationListView.currentIndex === index ? true : false
                opacity: situationListView.currentIndex === index ? 1.0 : 0.5
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.verticalCenter
            }
            MouseArea {
                anchors.fill: parent
                onClicked: situationListView.currentIndex = index
            }
            Rectangle {
                anchors.top: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: 5
                width: scaleFfactor * 10
                height: scaleFfactor * 10
                radius: scaleFfactor * 5
                color: "#ff2968"
                visible: situationListView.currentIndex === index
            }
        }
    }
}
