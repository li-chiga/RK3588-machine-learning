/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @brief         main.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @date          2024-04-28
* @link          http://www.openedv.com/forum.php
*******************************************************************/
import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.12
import QtQuick.Layouts 1.15
import com.alientek.qmlcomponents 1.0
Window {
    width: Screen.desktopAvailableWidth
    height: Screen.desktopAvailableHeight
    property real scaleFfactor: Screen.desktopAvailableWidth / 1080
    visible: true
    id: sysvolume

    Timer {
        id: control_visble_timer
        interval: 3500
        repeat: false
        onTriggered: {
            volume_rect_scale.xScale = 0.0
            sysvolume.flags = Qt.WindowStaysOnTopHint | Qt.FramelessWindowHint | Qt.WindowTransparentForInput
        }
    }

    VolumeControl {
        id: volumeControl
        onVolumeChanged: {
            sysvolume.flags = Qt.WindowStaysOnTopHint | Qt.FramelessWindowHint
            control_visble_timer.restart()
            volume_rect_scale.xScale = 1.0
        }
        onTriggerShow: {
            sysvolume.flags = Qt.WindowStaysOnTopHint | Qt.FramelessWindowHint
            control_visble_timer.restart()
            volume_rect_scale.xScale = 1.0
        }
    }

    Rectangle {
        color: "black"
        id: volume_rect
        visible: false
        radius: height / 2
        width: parent.width / 3 * 2
        height: parent.height / 4 * 3
        anchors.centerIn: parent
        transform: Scale {
            id: volume_rect_scale
            origin.x: volume_rect.width / 2
            origin.y: volume_rect.height / 2
            Behavior on xScale { PropertyAnimation { duration: 500; easing.type: Easing.OutQuart} }
            xScale: 0
            yScale: xScale
        }
        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 25
            anchors.rightMargin: 25
            spacing: 25
            Text {
                font.pixelSize: 30
                font.bold: true
                color: "white"
                text: qsTr("音量")
            }
            Slider {
                id: volume_slider
                Layout.fillWidth: true
                height: parent.height
                stepSize: 1
                visible: true
                from: 1
                live: true
                to: 100
                value: volumeControl.volume
                onValueChanged: {
                    if (volume_slider.pressed)
                        volumeControl.writeVolume(value)
                }

                background: Rectangle {
                    x: volume_slider.leftPadding
                    y: volume_slider.topPadding + volume_slider.availableHeight / 2 - height / 2
                    implicitWidth: scaleFfactor * 200
                    implicitHeight: scaleFfactor * 8
                    width: volume_slider.availableWidth
                    height: scaleFfactor * 10
                    radius: height / 2
                    color: "#55DCDCDC"

                    Rectangle {
                        width: volume_slider.visualPosition * parent.width
                        height: parent.height
                        color: "white"
                        radius: scaleFfactor * 4
                    }
                }
                handle: Item{}
            }
        }
    }

    Timer {
        id: timer
        running: true
        interval: 10
        repeat: false
        onTriggered: {
            sysvolume.height = 120 * scaleFfactor
            sysvolume.x = 0
            sysvolume.y = 0
            volume_rect.visible = true
        }
    }
    color: "transparent"
    flags: Qt.WindowStaysOnTopHint | Qt.FramelessWindowHint | Qt.WindowTransparentForInput
}
