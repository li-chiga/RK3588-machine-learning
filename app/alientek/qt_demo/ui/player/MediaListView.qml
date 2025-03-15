/******************************************************************
Copyright 2022 Guangzhou ALIENTEK Electronincs Co.,Ltd. All rights reserved
Copyright © Deng Zhimao Co., Ltd. 1990-2030. All rights reserved.
* @projectName   player
* @brief         mediaListView.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @date          2022-11-21
* @link          http://www.openedv.com/forum.php
*******************************************************************/
import QtQuick 2.12
import QtQuick.Controls 2.5

Item {
    GridView  {
        id: mediaGridView
        visible: true
        anchors.fill: parent
        clip: true
        model: mediaModel
        cellWidth: mediaGridView.width
        cellHeight: cellWidth / 1.5
        onCountChanged: {
            mediaGridView.currentIndex = -1
        }

        Component.onCompleted:  mediaGridView.currentIndex = -1

        onFlickEnded: scrollBar.visible = false
        onFlickStarted: scrollBar.visible = true
        ScrollBar.vertical: ScrollBar {
            id: scrollBar
            width: scaleFfactor * 10
            visible: false
            background: Rectangle {color: "transparent"}
            onActiveChanged: {
                active = true;
            }
            Component.onCompleted: {
                scrollBar.active = true;
            }
            contentItem: Rectangle{
                implicitWidth: scaleFfactor * 15
                implicitHeight: scaleFfactor * 100
                radius: scaleFfactor * 10
                color: scrollBar.pressed ? "#88101010" : "#30101010"
            }
        }

        delegate: Item {
            id: itembg
            width: mediaGridView.cellWidth
            height: mediaGridView.cellHeight
            Rectangle {
                radius: scaleFfactor * 20
                color:  "#292421"
                anchors.centerIn: parent
                width: mediaGridView.cellWidth - scaleFfactor * 30
                height: mediaGridView.cellHeight - scaleFfactor * 30
                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    onClicked: {
                        mediaGridView.currentIndex = index
                        mediaModel.currentIndex = index
                        if (mediaModel.currentIndex !== -1)
                            mediaPlayer.source =  mediaModel.getcurrentPath()
                        //mediaPlayer.play()
                        mediaplayer_swipeView.currentIndex = 1
                    }
                    Image {
                        id: moviesCoverplan
                        source: content
                        anchors.top: parent.top
                        anchors.topMargin: scaleFfactor * 20
                        anchors.left: parent.left
                        anchors.leftMargin: scaleFfactor * 20
                        anchors.rightMargin: scaleFfactor * 20
                        anchors.right: parent.right
                        height: parent.height * 0.75
                        fillMode: Image.PreserveAspectCrop
                        opacity: mouseArea.pressed ? 0.8 : 1.0
                    }
                    Text {
                        id: moviesName
                        text: qsTr(title)
                        anchors.bottom: parent.bottom
                        width: parent.width - scaleFfactor * 20
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.pixelSize: scaleFfactor * 25
                        color: "white"
                        horizontalAlignment: Text.AlignLeft
                        wrapMode: Text.WrapAnywhere
                    }
                }
            }
        }
    }
}
