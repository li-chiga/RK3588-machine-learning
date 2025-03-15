/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @projectName   music
* @brief         MusicLayout.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @link          www.openedv.com
* @date          2023-03-01
*******************************************************************/
import QtQuick 2.0
import QtMultimedia 5.0
import QtQuick.Layouts 1.12
Item {
    anchors.fill: parent
    id: musicLayout
    property real scaleFfactor: app_music.width / 720
    Connections {
        target: musicPlayer
        function onPositionChanged() {
            albumArt.progress_maximumValue = musicPlayer.duration
            if(!albumArt.progress_pressed) {
                albumArt.progress_value = musicPlayer.position
                playProgressChanged(musicPlayer.position / musicPlayer.duration)
            }
        }
        function onPlaybackStateChanged(playbackState) {
            switch (playbackState) {
            case Audio.PlayingState:
                break;
            case Audio.PausedState:
            case Audio.StoppedState:
                break;
            default:
                break;
            }
        }
        function onStatusChanged() {
            switch (musicPlayer.status) {
            case Audio.NoMedia:
                break;
            case Audio.Loading:
                break;
            case Audio.Loaded:
                albumArt.progress_maximumValue = musicPlayer.duration
                break;
            case Audio.Buffering:
                break;
            case Audio.Stalled:
                break;
            case Audio.Buffered:
                break;
            case Audio.InvalidMedia:
                switch (musicPlayer.error) {
                case Audio.FormatError:
                    ttitle.text = qsTr("需要安装解码器");
                    break;
                case Audio.ResourceError:
                    ttitle.text = qsTr("文件错误");
                    break;
                case Audio.NetworkError:
                    ttitle.text = qsTr("网络错误");
                    break;
                case Audio.AccessDenied:
                    ttitle.text = qsTr("权限不足");
                    break;
                case Audio.ServiceMissing:
                    ttitle.text = qsTr("无法启用多媒体服务");
                    break;
                }
                break;
            case Audio.EndOfMedia:
                music_lyricModel.currentIndex = 0
                albumArt.progress_maximumValue = 0
                albumArt.progress_value = 0
                if (albumArt.music_loopMode !== 0)
                    musicPlayer.autoPlay = true
                else
                    musicPlayer.autoPlay = false
                switch (albumArt.music_loopMode) {

                case 1:
                    musicPlayer.play()
                    break;
                case 2:
                    music_playlistModel.currentIndex++
                    break;
                case 3:
                    music_playlistModel.randomIndex()
                    break;
                default:
                    break;
                }
                break;
            }
        }
    }

    Connections {
        target: music_playlistModel
        function onCurrentIndexChanged() {
            playList.music_currentIndex = music_playlistModel.currentIndex
            playList.musicName = music_playlistModel.songName
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "#eff2f7"
    }

    Rectangle {
        id: music_playlist_dawer_bottom_mask
        anchors.fill: parent
        color: "#55101010"
        visible: false
        z: 51
    }

    Item {
        id: music_playlist_dawer_bottom
        width: parent.width
        height: parent.height
        z: 51
        MouseArea {anchors.fill: parent}
        x: 0
        y: height
        Behavior on y { PropertyAnimation { duration: control_duration; easing.type: Easing.OutQuad } }

        MouseArea {
            anchors.fill: parent
            drag.target: parent
            drag.minimumX: 0
            drag.minimumY: 0
            drag.maximumX: 0
            drag.maximumY: parent.height
            property int dragY
            onPressed: {
                dragY = parent.y
            }
            onReleased: {
                if (parent.y - dragY >= 100)
                    music_playlist_dawer_bottom.close()
                else
                    music_playlist_dawer_bottom.open()
            }
        }

        PlayList {
            id: playList
            anchors.fill: parent
        }

        function open() {
            control_duration = 200
            music_playlist_dawer_bottom.y = 0
            music_playlist_dawer_bottom_mask.visible = true
        }

        function close() {
            music_playlist_dawer_bottom.y = height
            music_playlist_dawer_bottom_mask.visible = false
        }
    }

    Item {
        id: music_cd_dawer_bottom
        width: parent.width
        height: parent.height
        z: 10
        x: 0
        y: height
        property bool opened: false
        Behavior on y { PropertyAnimation { duration: control_duration; easing.type: Easing.OutQuad } }

        MouseArea {
            anchors.fill: parent
            drag.target: parent
            drag.minimumX: 0
            drag.minimumY: 0
            drag.maximumX: 0
            drag.maximumY: parent.height
            property int dragY
            onPressed: {
                dragY = parent.y
            }
            onReleased: {
                if (parent.y - dragY >= 100)
                    music_cd_dawer_bottom.close()
                else
                    music_cd_dawer_bottom.open()
            }
        }

        AlbumArt {
            id: albumArt
        }

        function open() {
            control_duration = 200
            music_cd_dawer_bottom.y = 0
            controlPanel.y = parent.height + playPanel.height
            opened = true
        }

        function close() {
            music_cd_dawer_bottom.y = height
            controlPanel.y = parent.height - scaleFfactor * 150
            opened = false
        }
    }

    ColumnLayout {
        width: parent.width - scaleFfactor * 50
        anchors.topMargin: scaleFfactor * 60
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        height: parent.height - controlPanel.height

        SituationSelection {
            id: situationSelection
            Layout.fillWidth: true
        }

        SearchField {
            Layout.fillWidth: true
            id: searchField
        }

        Recommend {
            Layout.fillWidth: true
            id: recommend
        }

        ExclusiveRecommend {
            Layout.fillWidth: true
        }
    }
    ControlPanel {
        z: 12
        id: controlPanel
        y: parent.height - scaleFfactor * 150
        Behavior on y { PropertyAnimation { duration: control_duration; easing.type: Easing.OutQuad } }
    }

    PlayPanel {
        id: playPanel
        anchors.bottom: controlPanel.top
        z: 12
    }
}
