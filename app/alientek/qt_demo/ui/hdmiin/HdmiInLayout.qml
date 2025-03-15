/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @brief         HdmiInLayout.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @date          2024-03-11
* @link          http://www.openedv.com/forum.php
*******************************************************************/
import QtQuick 2.0

import AQuickPlugin 1.0
Item {
    anchors.fill: parent
    AHdmiInItem {
        id: ahdmiInItem
        anchors.fill: parent
        Component.onCompleted: ahdmiInItem.start(true)
        onSignalIsReady: function(isReady) {
            signalBg.visible = !isReady
        }
    }

    function setVisable(visible) {
        ahdmiInItem.visible = visible
    }

    onVisibleChanged: {
        delaytoStartAndStopCameraTimer.setTimeout(function() {setVisable(visible)}, 100)
        if (visible)
            delaytoStartAndStopCameraTimer.setTimeout(function() {ahdmiInItem.start(visible)}, 100)
        else
            ahdmiInItem.start(false)
    }

    Timer {
        id: delaytoStartAndStopCameraTimer
        function setTimeout(ft, delayTime) {
            delaytoStartAndStopCameraTimer.interval = delayTime;
            delaytoStartAndStopCameraTimer.repeat = false
            delaytoStartAndStopCameraTimer.triggered.connect(ft);
            delaytoStartAndStopCameraTimer.triggered.connect(function release () {
                delaytoStartAndStopCameraTimer.triggered.disconnect(ft)
                delaytoStartAndStopCameraTimer.triggered.disconnect(release)
                //appIsReadyTimer.start()
            })
            delaytoStartAndStopCameraTimer.start()
        }
    }

    Rectangle {
        id: signalBg
        color: "black"
        anchors.fill: parent
        Text {
            id: noSignalText
            text: qsTr("HDMI输入无信号")
            x: Math.floor(Math.random() * (parent.width - noSignalText.contentWidth))
            y: Math.floor(Math.random() * (parent.height - noSignalText.contentHeight))
            color: "white"
            font.pixelSize: 50
        }
        Text {
            anchors.centerIn: parent
            text: qsTr("此程序支持RK3588\n不支持RK3568与RK3588S")
            opacity: 0.2
            color: "white"
            font.pixelSize: 35
            font.bold: true
            horizontalAlignment: Text.AlignHCenter
        }
    }
    Timer {
        id: noSignalTimer
        running: signalBg.visible
        interval: 1000
        repeat: true
        onTriggered: {
            noSignalText.x = Math.floor(Math.random() * (parent.width - noSignalText.contentWidth))
            noSignalText.y = Math.floor(Math.random() * (parent.height - noSignalText.contentHeight))
        }
    }
}
