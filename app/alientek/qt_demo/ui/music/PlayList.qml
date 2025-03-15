/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @projectName   desktop
* @brief         PlayList.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @link          www.openedv.com
* @date          2021-09-13
*******************************************************************/
import com.alientek.qmlcomponents 1.0
import QtQuick.Controls 2.5
import QtQuick 2.2
import QtMultimedia 5.0
import QtQuick 2.4
import QtGraphicalEffects 1.14

Item {
    id: root
    property int music_currentIndex: -1
    property int musicCount: 0
    property string musicName

    onMusic_currentIndexChanged: {
        music_listView.currentIndex = music_currentIndex
    }

    Rectangle {
        anchors.top: parent.top
        anchors.topMargin:  parent.height / 4
        width: parent.width
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        color: "white"
        radius: scaleFfactor * 20

        Row {
            anchors.top: parent.top
            anchors.topMargin: scaleFfactor * 25
            id: row1
            z: 3
            anchors.horizontalCenter: parent.horizontalCenter
            Text {
                width: root.width / 4
                text: qsTr("在听")
                font.pixelSize: scaleFfactor * 30
                color: "black"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }

            Text {
                width: root.width / 4
                text: qsTr("最近1")
                font.pixelSize: scaleFfactor * 30
                color: "#DCDCDC"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }

            Text {
                width: parent.width / 4
                text: qsTr("最近2")
                font.pixelSize: scaleFfactor * 30
                color: "#DCDCDC"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }

            Text {
                width: root.width / 4
                text: qsTr("最近3")
                font.pixelSize: scaleFfactor * 30
                color: "#DCDCDC"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
        }


        Text {
            id: list_count
            text: qsTr("(0首)")
            font.pixelSize: scaleFfactor * 25
            anchors.topMargin: scaleFfactor * 10
            anchors.top: row1.bottom
            anchors.left: parent.left
            anchors.leftMargin: scaleFfactor * 25
            color: "#DAA569"
            z: 3
        }

        ListView {
            id: music_listView
            visible: true
            anchors.top: list_count.bottom
            anchors.topMargin: scaleFfactor * 25
            anchors.bottomMargin: scaleFfactor * 15
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.leftMargin: scaleFfactor * 25
            anchors.right: parent.right
            anchors.rightMargin: scaleFfactor * 25
            currentIndex: 0
            clip: false
            spacing: 10
            onFlickStarted: scrollBar.opacity = 1.0
            onFlickEnded: scrollBar.opacity = 0.0

            onCountChanged: {
                list_count.text = "共（" + music_listView.count + ")" + "首，含会员歌曲0首"
                musicCount = music_listView.count
            }

            ScrollBar.vertical: ScrollBar {
                id: scrollBar
                width: scaleFfactor * 10
                opacity: 0.0
                onActiveChanged: {
                    active = true;
                }
                Component.onCompleted: {
                    scrollBar.active = true;
                }
                contentItem: Rectangle{
                    implicitWidth: scaleFfactor * 6
                    implicitHeight: scaleFfactor * 100
                    radius: scaleFfactor * 2
                    color: scrollBar.hovered ? "#88101010" : "#30101010"
                }
                Behavior on opacity { PropertyAnimation { duration: 500; easing.type: Easing.Linear } }
            }

            model: music_playlistModel
            delegate: Item {
                id: itembg
                width: parent.width - scaleFfactor * 10
                height: music_listView.currentIndex === index && musicPlayer.playbackState === Audio.PlayingState ? scaleFfactor * 80 : scaleFfactor * 60
                Rectangle {
                    anchors.centerIn: parent
                    width: root.width
                    height: parent.height
                    color: music_listView.currentIndex === index && musicPlayer.playbackState
                           === Audio.PlayingState ? "#33dddddd" : "transparent"
                }
                Text {
                    id: listIndex
                    text: index < 9 ? "0" + (index + 1) : index + 1
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: scaleFfactor * 25
                    font.pixelSize: scaleFfactor * 25
                }

                Image {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: listIndex.right
                    anchors.leftMargin: scaleFfactor * 25
                    width: itembg.height
                    height: itembg.height
                    id: album
                    visible: false
                    source: musicPlayer.playbackState == Audio.PlayingState && parent.ListView.isCurrentItem  ?
                                "file:///" + appCurrtentDir + "/resource/artist/" + musicName +".jpg" : ""
                }

                Rectangle {
                    id: opacityMaskSource
                    visible: false
                    anchors.fill: album
                    radius: scaleFfactor * 10
                }

                OpacityMask {
                    source: album
                    anchors.fill: album
                    maskSource: opacityMaskSource
                }

                Text {
                    id: songsname
                    width: itembg.width - scaleFfactor * 220
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: album.right
                    verticalAlignment: Text.AlignVCenter
                    text: title
                    elide: Text.ElideRight
                    anchors.leftMargin: scaleFfactor * 10
                    color: parent.ListView.isCurrentItem && musicPlayer.playbackState == Audio.PlayingState ? "#f19ec2" : "black"
                    font.pixelSize: scaleFfactor * 25
                    font.bold: parent.ListView.isCurrentItem && musicPlayer.playbackState == Audio.PlayingState
                }

                Text {
                    id: songsauthor
                    visible: true
                    width: scaleFfactor * 200
                    height: scaleFfactor * 15
                    anchors.bottom: parent.bottom
                    anchors.left: album.right
                    verticalAlignment: Text.AlignVCenter;
                    text: author
                    anchors.leftMargin: scaleFfactor * 10
                    elide: Text.ElideRight
                    color: parent.ListView.isCurrentItem && musicPlayer.playbackState == Audio.PlayingState ? "#f19ec2" : "gray"
                    font.pixelSize: scaleFfactor * 15
                    font.bold: parent.ListView.isCurrentItem
                }

                MouseArea {
                    id: mouserArea
                    anchors.fill: parent
                    acceptedButtons: Qt.LeftButton | Qt.RightButton
                    onClicked: {
                        music_playlistModel.currentIndex = index
                        music_listView.currentIndex = index
                        //app_music.playBtnSignal()
                        musicPlayer.play()
                    }
                }

                Button {
                    id: itembtn
                    anchors.right: parent.right
                    anchors.verticalCenter: itembg.verticalCenter
                    width: itembg.height
                    height: itembg.height
                    onClicked: {
                        music_playlistModel.currentIndex = index
                        music_listView.currentIndex = index
                        if (musicPlayer.playbackState != Audio.PlayingState)
                            musicPlayer.play()
                    }
                    background: Rectangle {
                        width: Control.width
                        height: Control.height
                        radius: scaleFfactor * 3
                        color: Qt.rgba(0,0,0,0)
                        Image {
                            id: itemImage
                            width: parent.height - scaleFfactor * 20
                            height: width
                            anchors.centerIn: parent
                            source:  music_listView.currentIndex != index || musicPlayer.playbackState != Audio.PlayingState
                                     ? "qrc:/icons/btn_play.png" : "qrc:/icons/btn_pause.png"
                            opacity: 0.8
                        }
                    }
                }
            }
        }

        Rectangle {
            width: parent.width
            radius: parent.radius
            height: scaleFfactor * 120
        }
    }
}
