/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @projectName   music
* @brief         ExclusiveRecommend.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @link          www.openedv.com
* @date          2023-02-27
*******************************************************************/

import QtQuick 2.0

Rectangle {
    width: parent.width - scaleFfactor * 50
    height: item_listView.height + scaleFfactor * 70
    // anchors.horizontalCenter: parent.horizontalCenter
    radius: scaleFfactor * 25
    color: "white"
    Text {
        id: music_list_text
        text: qsTr("专属推荐")
        font.pixelSize: scaleFfactor * 35
        anchors.left: parent.left
        anchors.leftMargin: scaleFfactor * 25
        anchors.top: parent.top
        anchors.topMargin: scaleFfactor * 5
        font.bold: true
    }
    ListModel {
        id: model1
        ListElement {
            name: "80年代经典情歌，知音在何方"
            icon: "qrc:/images/music_album_1.png"
            count: "690.6万"
        }

        ListElement {
            name: "汽车劲爆DJ，2023最新500首车载歌曲"
            icon: "qrc:/images/music_album_2.png"
            count: "460万"
        }

        ListElement {
            name: "怀旧经典，往事如烟，难忘情怀"
            icon: "qrc:/images/music_album_3.png"
            count: "3600万"
        }

        ListElement {
            name: "现代古风，年轻新生代主力"
            icon: "qrc:/images/music_album_4.png"
            count: "1900万"
        }

        ListElement {
            name: "民间民谣，传诵经典，快乐舞出来"
            icon: "qrc:/images/music_album_5.png"
            count: "900万"
        }

        ListElement {
            name: "欧美情歌，DJ摇滚，情歌王子"
            icon: "qrc:/images/music_album_6.png"
            count: "60.5万"
        }
    }

    GridView {
        id: item_listView
        visible: true
        anchors.top: music_list_text.bottom
        anchors.topMargin: scaleFfactor * 10
        width: parent.width
        height: contentHeight
        interactive: true
        clip: true
        model: model1
        cellWidth: item_listView.width / 3
        cellHeight: cellWidth + scaleFfactor * 50
        delegate: Rectangle {
            id: listView_delegate
            width: item_listView.cellWidth
            height: item_listView.cellHeight
            color: "transparent"
            Image {
                id: image1
                source: icon
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width - scaleFfactor * 30
                height: width
                fillMode: Image.PreserveAspectFit
                Rectangle {
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right
                    width: play_count_text.contentWidth + scaleFfactor * 10
                    height: scaleFfactor * 30
                    radius: height / 2
                    color: "#88888888"
                    Text {
                        id: play_count_text
                        text: count
                        color: "white"
                        font.pixelSize: scaleFfactor * 20
                        anchors.centerIn: parent
                    }
                }
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                height: contentHeight
                width: image1.width
                text: name
                font.pixelSize: scaleFfactor * 20
                wrapMode: Text.WrapAnywhere
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    image1.opacity = 1
                }

                onEntered: {
                    image1.opacity = 0.8
                }

                onPressed:{
                    image1.opacity = 0.8
                }

                onReleased:{
                    image1.opacity = 1
                }

                onExited: {
                    image1.opacity = 1
                }
            }
        }
    }
}
