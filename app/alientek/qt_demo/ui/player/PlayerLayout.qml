/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @projectName   player
* @brief         PlayerLayout.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @link          www.openedv.com
* @date          2023-03-08
* @link          http://www.openedv.com/forum.php
*******************************************************************/
import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.5
import com.alientek.qmlcomponents 1.0
import QtQuick.Layouts 1.14
import AQuickPlugin 1.0

Item {
    signal mediaDuratrionChaged()
    signal mediaPositonChaged()
    signal sliderPressChaged(bool pressed)
    property bool fullScreenFlag: false
    property bool progress_pressed: false
    property bool tiltleHeightShow: true
    property bool tiltleWidthShow: true
    id: playerLayout
    property real scaleFfactor: app_player.width / 720
    Rectangle {
        anchors.fill: parent
        color: "black"
    }

    onVisibleChanged: {
        if (visible)
            timerCountToHide.start()
        if (visible) {
            if (mediaPlayer.playbackState === APlayer.PausedState)
                mediaPlayer.play()
        } else {
            if (mediaPlayer.playbackState === APlayer.PlayingState)
                mediaPlayer.pause()
        }
    }

    Timer {
        id: playStarttimer
        function setTimeout(cb, delayTime) {
            playStarttimer.interval = delayTime;
            playStarttimer.repeat = false
            playStarttimer.triggered.connect(cb);
            playStarttimer.triggered.connect(function release () {
                playStarttimer.triggered.disconnect(cb)
                playStarttimer.triggered.disconnect(release)
            })
            playStarttimer.start()
        }
    }

    Timer {
        id: timerCountToHide
        interval: 5000
        repeat: false
        onTriggered: {
        }
    }


    SwipeView {
        id: mediaplayer_swipeView
        visible: true
        anchors.fill: parent
        clip: true
        interactive: false

        onCurrentIndexChanged: {
            if (currentIndex === 0) {
                mediaPlayer.stop()
                mediaModel.currentIndex = -1
            } else
                playStarttimer.setTimeout(function() { if (mediaplayer_swipeView !== 0) mediaPlayer.play()}, 250)
        }

        Item {
            Text {
                id: item
                text: qsTr("项目")
                color: "white"
                font.pixelSize: scaleFfactor * 50
                font.bold: true
                anchors.top: parent.top
                anchors.topMargin: scaleFfactor * 60
                anchors.left: parent.left
                anchors.leftMargin: scaleFfactor * 25
            }

            Button {
                id: bt_more
                anchors.right: parent.right
                anchors.verticalCenter: item.verticalCenter
                anchors.rightMargin: scaleFfactor * 25
                width: scaleFfactor * 50
                height: scaleFfactor * 50
                background: Image {
                    source: "qrc:/icons/videoplayer_more_icon.png"
                }
                opacity: bt_more.pressed ? 0.5 : 1.0
            }

            MediaListView {
                anchors.top: item.bottom
                anchors.topMargin: 0
                anchors.left: parent.left
                anchors.leftMargin: scaleFfactor * 10
                anchors.rightMargin: scaleFfactor * 10
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.bottomMargin: scaleFfactor * 90
            }

            MorePro {}

        }

        VolumeMonitor {
            id: volumeMonitor
        }

        Rectangle {
            id: playWindow
            color: "black"

            APlayer {
                id: mediaPlayer
                anchors.centerIn: fullScreenFlag ? parent : undefined
                anchors.top: fullScreenFlag ? undefined : parent.top
                anchors.topMargin: fullScreenFlag ? undefined: scaleFfactor * 60
                anchors.horizontalCenter: fullScreenFlag ? undefined : parent.horizontalCenter
                volume: volumeMonitor.volume
                MouseArea {
                    id: mouseAreaPlayerItem
                    anchors.fill: parent
                    onClicked: {
                        if (timerCountToHide.running)
                            timerCountToHide.stop()
                        else
                            timerCountToHide.restart()
                    }
                }
                source: ""
                Behavior on width { PropertyAnimation { duration: 350; easing.type: Easing.Linear } }
                Behavior on height { PropertyAnimation { duration: 350; easing.type: Easing.Linear } }
                transform: Rotation{
                    id: mediaRotation
                    origin.x: mediaPlayer.width / 2
                    origin.y: mediaPlayer.height / 2
                    angle: fullScreenFlag ? 90 : 0
                    Behavior on angle { PropertyAnimation { duration: 350; easing.type: Easing.Linear } }
                }
                onSourceChanged: {
                }
                onPositionChanged: {
                    if (!progress_pressed)
                        playerLayout.mediaPositonChaged()
                }

                onDurationChanged: {
                    playerLayout.mediaDuratrionChaged()
                }

                onItemSizeChanged : function(itemWidth, itemHeight) {
                    mediaPlayer.width = itemWidth
                    mediaPlayer.height = itemHeight
                }

                onPlaybackStateChanged: function(playbackState) {
                    switch (playbackState) {
                    case APlayer.PlayingState:
                        break;
                    case APlayer.PausedState:
                    case APlayer.StoppedState:
                        timerCountToHide.restart()
                        break;
                    default:
                        break;
                    }
                }

                Component.onCompleted: {
                    mediaPlayer.setScreenSize(app_player.width, app_player.height)
                }

                Row {
                    visible: timerCountToHide.running
                    anchors.left: parent.left
                    anchors.leftMargin: 30
                    anchors.top: parent.top
                    anchors.topMargin: fullScreenFlag ? scaleFfactor * 50 : -scaleFfactor * 30
                    Button {
                        id: back_button
                        width: scaleFfactor * 120
                        height: width
                        hoverEnabled: true
                        anchors.verticalCenter: fullScreenFlag ? undefined : parent.verticalCenter
                        background: Image {
                            id: back_image
                            width: scaleFfactor * 40
                            height: width
                            anchors.centerIn: back_button
                            opacity: back_button.hovered && !back_button.pressed ? 0.8 : 1.0
                            source: "qrc:/icons/videoplayer_back_icon.png"
                        }
                        onClicked: {
                            if(!fullScreenFlag)
                                mediaplayer_swipeView.currentIndex = 0
                            else
                                fullScreenFlag = !fullScreenFlag
                        }
                    }

                    Text{
                        id: filmNameText
                        width: mediaPlayer.width - back_button.width * 2 - 60
                        anchors.verticalCenter: parent.verticalCenter
                        text: mediaModel.currentIndex !== -1 ? mediaModel.getcurrentTitle() : ""
                        color: "white"
                        horizontalAlignment: Text.AlignHCenter
                        font.pixelSize: scaleFfactor * 25
                        font.bold: true
                    }
                }

                RowLayout {
                    width: parent.width
                    height: 120 * scaleFfactor
                    anchors.bottom: parent.bottom
                    visible: timerCountToHide.running
                    Item {
                        Layout.preferredWidth: 30
                        Layout.preferredHeight: 30
                    }
                    Button {
                        id: play_button
                        Layout.preferredWidth: scaleFfactor * 120
                        Layout.preferredHeight: width
                        hoverEnabled: true
                        background: Image {
                            id: play_image
                            width: scaleFfactor * 36
                            height: width
                            anchors.centerIn: play_button
                            opacity: play_button.hovered && !play_button.pressed ? 0.8 : 1.0
                            source: mediaPlayer.playbackState === APlayer.PlayingState ?  "qrc:/icons/videoplayer_pause_icon.png" : "qrc:/icons/videoplayer_play_icon.png"
                        }
                        onClicked: {
                            if(mediaPlayer.playbackState === APlayer.PlayingState)
                                mediaPlayer.pause()
                            else
                                mediaPlayer.play()
                        }
                    }
                    Text{
                        id: playTimePosition
                        text: currentMediaTime(mediaPlayer.position)
                        color: "white"
                        font.pixelSize: scaleFfactor * 15
                        font.bold: true
                    }

                    PlaySilder {
                        id: silder
                        Layout.fillWidth: true
                    }

                    Text{
                        id: playTimeDuration
                        text: currentMediaTime(mediaPlayer.duration)
                        color: "white"
                        font.pixelSize: scaleFfactor * 15
                        font.bold: true
                    }

                    Button {
                        id: screen_button
                        Layout.preferredWidth: scaleFfactor * 120
                        Layout.preferredHeight: width
                        hoverEnabled: true
                        background: Image {
                            id: screen_image
                            width: scaleFfactor * 40
                            height: width
                            anchors.centerIn: screen_button
                            opacity: screen_button.hovered && !screen_button.pressed ? 0.8 : 1.0
                            source: !fullScreenFlag ?  "qrc:/icons/videoplayer_smallscreen_icon.png" : "qrc:/icons/videoplayer_fullscreen_icon.png"
                        }
                        onClicked: {
                            fullScreenFlag = !fullScreenFlag
                            timerCountToHide.restart()
                        }
                    }
                    Item {
                        Layout.preferredWidth: 30
                        Layout.preferredHeight: 30
                    }
                }
            }
        }
    }


    onFullScreenFlagChanged:{
        mediaPlayer.setFullScreen(fullScreenFlag)
    }


    function currentMediaTime(time){
        var sec = Math.floor(time / 1000);
        var hours = Math.floor(sec / 3600);
        var minutes = Math.floor((sec - hours * 3600) / 60);
        var seconds = sec - hours * 3600 - minutes * 60;
        var hh, mm, ss;
        if(hours.toString().length < 2)
            hh = "0" + hours.toString();
        else
            hh = hours.toString();
        if(minutes.toString().length < 2)
            mm="0" + minutes.toString();
        else
            mm = minutes.toString();
        if(seconds.toString().length < 2)
            ss = "0" + seconds.toString();
        else
            ss = seconds.toString();
        return hh+":" + mm + ":" + ss
    }
}
