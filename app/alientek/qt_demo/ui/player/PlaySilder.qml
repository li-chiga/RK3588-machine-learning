/******************************************************************
Copyright 2022 Guangzhou ALIENTEK Electronincs Co.,Ltd. All rights reserved
Copyright © Deng Zhimao Co., Ltd. 1990-2030. All rights reserved.
* @projectName   player
* @brief         PlaySilder.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @date          2022-11-22
* @link          http://www.openedv.com/forum.php
*******************************************************************/
import QtQuick 2.0
import QtQuick.Controls 2.5
import QtQuick 2.2

Slider {
    id: media_play_Hprogress
    height: parent.height
    from: 0
    stepSize: 10
    orientation: Qt.Horizontal
    Connections{
        target: playerLayout
        function  onMediaDuratrionChaged() {
            media_play_Hprogress.to = mediaPlayer.duration
        }
        function  onMediaPositonChaged() {
            media_play_Hprogress.value = mediaPlayer.position

        }
    }
    onPressedChanged: {
        progress_pressed = media_play_Hprogress.pressed
        if (!media_play_Hprogress.pressed && mediaPlayer.seekable) {
            mediaPlayer.setPosition(value)
            mediaPlayer.play()
        }
        if (media_play_Hprogress.pressed)
            timerCountToHide.restart()
    }

    onValueChanged: {

    }
    background: Rectangle {
        x: media_play_Hprogress.leftPadding
        y: media_play_Hprogress.topPadding + media_play_Hprogress.availableHeight / 2 - height / 2
        implicitWidth: 200
        implicitHeight: 8
        width: media_play_Hprogress.availableWidth
        height: 8
        radius: 0
        color: "#38383a"

        Rectangle {
            width: media_play_Hprogress.visualPosition * parent.width
            height: parent.height
            color: "#7a7a7c"
            radius: 0
        }
    }

    handle: Rectangle {
        x: media_play_Hprogress.leftPadding + media_play_Hprogress.visualPosition * (media_play_Hprogress.availableWidth - width)
        y: media_play_Hprogress.topPadding + media_play_Hprogress.availableHeight / 2 - height / 2
        implicitWidth: 20
        implicitHeight: 20
        color: "transparent"
        Rectangle {
            anchors.centerIn: parent
            width: parent.width
            height: parent.height
            color: "#ffffff"
            radius: width / 2
            Rectangle {
                visible: false
                anchors.centerIn: parent
                color: "#ffffff"
                width: parent.width - 8
                height: width
                radius: width / 2
                Rectangle {
                    anchors.centerIn: parent
                    color: "#8dcff4"
                    width: 10
                    height: width
                    radius: width / 2
                }
            }
        }
    }
}

