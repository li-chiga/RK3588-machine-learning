/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @projectName   desktop
* @brief         PlayPanel.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @link          www.openedv.com
* @date          2021-09-13
*******************************************************************/
import QtQuick 2.0
import QtQuick.Controls 2.5
import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import QtGraphicalEffects 1.14
import QtMultimedia 5.0
import QtQuick 2.4
import com.alientek.qmlcomponents 1.0
Rectangle {
    width: parent.width - scaleFfactor * 50
    height: scaleFfactor * 100
    anchors.horizontalCenter: parent.horizontalCenter
    radius: scaleFfactor * 60
    color: "#edecf1"

    MouseArea {
        enabled: true
        id: playPanelMouseArea
        anchors.fill: parent
        onClicked: music_cd_dawer_bottom.open()
    }

    Button {
        visible: false
        id: btnprevious
        anchors.verticalCenter: btnplay.verticalCenter
        anchors.right: btnplay.left
        anchors.rightMargin: scaleFfactor * 20
        width: scaleFfactor * 32
        height: 32
        onClicked: {
            switch (albumArt.music_loopMode) {
            case 0:
            case 1:
            case 2:
                music_playlistModel.currentIndex--
                musicPlayer.play()
                break;
            case 3:
                music_playlistModel.randomIndex();
                musicPlayer.play()
                break;
            }
        }
        style: ButtonStyle {
            background: Image {
                id: imgbackward
                opacity: btnprevious.pressed ? 0.7 : 1.0
            }
        }
    }

    Button {
        id: btnplay
        anchors.verticalCenter : parent.verticalCenter
        anchors.right: btnforward.left
        anchors.rightMargin: scaleFfactor * 20
        width: scaleFfactor * 60
        height: width
        checkable: true
        checked: false

        onClicked: {
            if (playList.musicCount === 0)
                return
            if (music_playlistModel.currentIndex !== -1) {
                musicPlayer.source =  music_playlistModel.getcurrentPath()
                playList.music_currentIndex = music_playlistModel.currentIndex
                playList.musicName = music_playlistModel.getcurrentSongName()
                musicPlayer.playbackState === Audio.PlayingState ? musicPlayer.pause() : musicPlayer.play()
            }
        }

        style: ButtonStyle {
            background: Image {
                id: imgplay
                source: musicPlayer.playbackState === Audio.PlayingState ? "qrc:/icons/btn_pause.png"
                                                                         : "qrc:/icons/btn_play.png"
                opacity: btnplay.pressed ? 0.7 : 1.0;
            }
        }
    }

    Button {
        id: btnforward
        anchors.right: btnplayList.left
        anchors.rightMargin: scaleFfactor * 20
        anchors.verticalCenter: parent.verticalCenter
        width: scaleFfactor * 60
        height: width
        onClicked: {
            if (musicPlayer.hasAudio)
                switch (albumArt.music_loopMode) {
                case 0:
                case 1:
                case 2:
                    music_playlistModel.currentIndex ++
                    musicPlayer.play()
                    break;
                case 3:
                    music_playlistModel.randomIndex();
                    musicPlayer.play()
                    break;
                }
            btnplay.checked = true
        }
        style: ButtonStyle {
            background: Image {
                id: imgforward
                source: "qrc:/icons/btn_next.png"
                opacity: btnforward.pressed ? 0.7 : 1.0;
            }
        }
    }

    Button {
        id: btnplayList
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: scaleFfactor * 25
        width: scaleFfactor * 60
        height: width
        onClicked: {
            music_playlist_dawer_bottom.open()
        }
        style: ButtonStyle {
            background: Image {
                source: "qrc:/icons/btn_playlist.png"
                opacity: control.hovered ? 0.7 : 1.0;
            }
        }
    }

    Timer {
        interval: 2000
        id: silder_enable_timer
        repeat: false
        onTriggered: {
            musci_play_progress.enabled = true
        }
    }

    Image {
        id: playPanel_music_artist
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: scaleFfactor * 5
        width: parent.height - scaleFfactor * 15
        height: parent.height - scaleFfactor * 15
        visible: false
        source: musicPlayer.hasAudio ?
                    "file:///" + appCurrtentDir + "/resource/artist/" + playList.musicName +".jpg" : ""
    }

    Rectangle {
        id: rect_mask
        height: parent.height
        width: height
        radius: height / 2
        visible: false
        color: "black"
    }

    OpacityMask {
        id: music_artist_opacityMask
        source: playPanel_music_artist
        maskSource: rect_mask
        anchors.fill: playPanel_music_artist
    }

    CircleBar {
        anchors.fill: playPanel_music_artist
    }

    RotationAnimator {
        id: music_artist_rotationAnimator
        target: music_artist_opacityMask
        from: 0
        to: 360
        duration: 50000
        loops: Animation.Infinite
        running:  musicPlayer.playbackState === Audio.PlayingState && app_music.active && appActive
        onRunningChanged: {
            if (running === false) {
                from = music_artist_opacityMask.rotation
                to = from + 360
            }
        }
        onStopped: {
            if (musicPlayer.playbackState === Audio.StoppedState)
                music_artist_opacityMask.rotation = 0
        }
    }


    Text {
        anchors.left: playPanel_music_artist.right
        anchors.leftMargin: scaleFfactor * 25
        anchors.right: btnplay.left
        anchors.rightMargin: scaleFfactor * 25
        anchors.verticalCenter: parent.verticalCenter
        verticalAlignment: Text.AlignVCenter
        text: musicPlayer.status === Audio.Buffered ? music_playlistModel.getcurrentTitle() + " - " + music_playlistModel.getcurrentAuthor() : ""
        elide: Text.ElideRight
        font.pixelSize: scaleFfactor * 25
    }

    Connections {
        target: app_music
        function onPlayBtnSignal() {
            btnplay.clicked()
        }
        function  onPreviousBtnSignal() {
            btnprevious.clicked()
        }
        function  onNextBtnSignal() {
            btnforward.clicked()
        }
    }
}
