/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @brief         Brightness.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @date          2024-04-20
* @link          http://www.openedv.com/forum.php
*******************************************************************/
import QtQuick 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.12
import com.alientek.qmlcomponents 1.0
Item {
    property int brightness_radius_width: 0.2 * brightness_slider.value / 2 <= 10 ? 10 : 0.2 * brightness_slider.value / 2
    property int brightness_rect_width: 0.1 * brightness_slider.value / 2   <= 4 ? 4 : 0.1 * brightness_slider.value / 2
    anchors.fill: parent
    BrightnessControl {
        id: brightnessControl
    }
    Slider {
        from: 0
        value: brightnessControl.brightness
        stepSize: 1
        to: 255
        id: brightness_slider
        orientation: Qt.Vertical
        width: parent.width / 4
        anchors.centerIn: parent
        height: parent.height / 3
        live: true
        onValueChanged: {
            if (brightness_slider.pressed)
                brightnessControl.writeBrightness(value)
        }
        background: Rectangle {
            visible: false
            id: slider_rect
            x: brightness_slider.leftPadding
            y: brightness_slider.topPadding + brightness_slider.availableWidth / 2 - width / 2
            implicitWidth: 8
            implicitHeight: 200
            width: brightness_slider.width
            height:brightness_slider.availableHeight
            radius: width / 4
            color: "white"

            Rectangle {
                width: parent.width
                height: brightness_slider.visualPosition * parent.height
                color: "gray"
            }

            Item {
                id: brightness_item1
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width
                height: width
                Rectangle {
                    anchors.centerIn: parent
                    width: brightness_radius_width
                    height: width
                    radius: height / 2
                    color: "#4c4c4c"
                }

                Rectangle {
                    width: brightness_rect_width
                    height: 4
                    radius: 2
                    color: "#4c4c4c"
                    anchors.left: parent.horizontalCenter
                    anchors.leftMargin: 15
                    anchors.verticalCenter: parent.verticalCenter
                }

                Rectangle {
                    width: brightness_rect_width
                    height: 4
                    radius: 2
                    color: "#4c4c4c"
                    anchors.right: parent.horizontalCenter
                    anchors.rightMargin: 15
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            Item {
                id: brightness_item2
                rotation: 45
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width
                height: width

                Rectangle {
                    width: brightness_rect_width
                    height: 4
                    radius: 2
                    color: "#4c4c4c"
                    anchors.left: parent.horizontalCenter
                    anchors.leftMargin: 15
                    anchors.verticalCenter: parent.verticalCenter
                }

                Rectangle {
                    width: brightness_rect_width
                    height: 4
                    radius: 2
                    color: "#4c4c4c"
                    anchors.right: parent.horizontalCenter
                    anchors.rightMargin: 15
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            Item {
                id: brightness_item3
                rotation: 90
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width
                height: width

                Rectangle {
                    width: brightness_rect_width
                    height: 4
                    radius: 2
                    color: "#4c4c4c"
                    anchors.left: parent.horizontalCenter
                    anchors.leftMargin: 15
                    anchors.verticalCenter: parent.verticalCenter
                }

                Rectangle {
                    width: brightness_rect_width
                    height: 4
                    radius: 2
                    color: "#4c4c4c"
                    anchors.right: parent.horizontalCenter
                    anchors.rightMargin: 15
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            Item {
                id: brightness_item4
                rotation: 135
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width
                height: width

                Rectangle {
                    width: brightness_rect_width
                    height: 4
                    radius: 2
                    color: "#4c4c4c"
                    anchors.left: parent.horizontalCenter
                    anchors.leftMargin: 15
                    anchors.verticalCenter: parent.verticalCenter
                }

                Rectangle {
                    width: brightness_rect_width
                    height: 4
                    radius: 2
                    color: "#4c4c4c"
                    anchors.right: parent.horizontalCenter
                    anchors.rightMargin: 15
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

        }
        handle: Item{}

        Rectangle {
            id: slider_mask
            anchors.fill: slider_rect
            radius: width / 4
            visible: false
        }

        OpacityMask {
            anchors.fill: slider_rect
            source: slider_rect
            maskSource: slider_mask
        }
    }
}
