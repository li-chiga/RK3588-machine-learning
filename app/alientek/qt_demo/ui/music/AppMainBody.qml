/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @brief         AppMainBody.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @date          2024-04-07
* @link          http://www.openedv.com/forum.php
*******************************************************************/
import QtQuick 2.12
import QtQuick.Controls 2.5
import QtMultimedia 5.0
import com.alientek.qmlcomponents 1.0
Item {
    //property QtObject music_playlistModel
    //property QtObject music_lyricModel
    anchors.fill: parent
    Rectangle {
        anchors.fill: parent
        color: "white"
    }

    VolumeMonitor {
        id: volumeMonitor
    }

    Audio {
        id: musicPlayer
        source: ""
        volume: volumeMonitor.volume
        objectName: "myAudio"
        autoPlay: false
        onSourceChanged: {
            music_lyricModel.setPathofSong(source, appCurrtentDir);
        }
    }

    function songsInit(){
        music_playlistModel.add(appCurrtentDir)
    }

    LyricModel {
        id: music_lyricModel
        onCurrentIndexChanged: {
            lyric_CurrtentIndex = currentIndex
        }
    }

    PlayListModel {
        id: music_playlistModel
        currentIndex: 0
        onCurrentIndexChanged: {
            musicPlayer.source = getcurrentPath()
        }
        Component.onCompleted: {
            songsInit()
        }
    }

    /*Loader {
        id: loader
        anchors.fill: parent
        asynchronous: true
        Component.onCompleted:  loader.sourceComponent = component
    }

    Component {
        id: component
        Item {
            anchors.fill: parent
            LyricModel {
                id: m_music_lyricModel
                onCurrentIndexChanged: {
                    lyric_CurrtentIndex = currentIndex
                }
                Component.onCompleted: music_lyricModel = m_music_lyricModel
            }

            PlayListModel {
                id: m_music_playlistModel
                currentIndex: 0
                onCurrentIndexChanged: {
                    musicPlayer.source = getcurrentPath()
                }
                Component.onCompleted: {
                    music_playlistModel = m_music_playlistModel
                    songsInit()
                }
            }
        }
    }*/

    MusicLayout {

    }
}
