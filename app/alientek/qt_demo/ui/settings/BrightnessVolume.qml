/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 1990-2030. All rights reserved.
* @projectName   QDesktop
* @brief         BrightnessVolume.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @date          2022-10-24
* @link          www.opendev.com
*******************************************************************/
import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Styles 1.4

Item {
    id: myBrightnessVolume
    Button {
        id: back_button
        anchors.top: parent.top
        anchors.topMargin: 20
        width: 80
        opacity: back_button.pressed ? 0.5 : 1.0
        background: Image {
            id: back_image
            source: "qrc:/icons/back.png"
            width: 40
        }
        onClicked: settings_swipeView.currentIndex = 0

        Text {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            text: qsTr("设置")
            font.underline: true
            font.family: "Montserrat Light"
            color: "#0b62f6"
            font.pixelSize: 20
        }
    }


    Item {
        anchors.fill: parent

        Text {
            id: myDevice_Top_center_Text
            text: qsTr("亮度与音量")
            color: "black"
            font.pixelSize: 30
            anchors.top: parent.top
            anchors.topMargin: 20
            opacity: 0.0
            font.family: "Montserrat Light"
            anchors.horizontalCenter: parent.horizontalCenter
            Behavior on opacity { PropertyAnimation { duration: 1000; easing.type: Easing.InOutBack } }
        }

        Rectangle {
            anchors.bottom: item2.top
            width: settingsLayout.width
            height: 1
            color: "#c6c6c8"
            z: 5
            visible: myDevice_Top_center_Text.opacity === 1.0
        }

        Item {
            id: item2
            anchors.top: parent.top
            anchors.topMargin: 60
            width: parent.width
            anchors.bottom: parent.bottom

            Flickable {
                id: myDevices_flickable
                anchors.fill: parent
                contentHeight: parent.height + 250
                contentWidth: parent.width
                clip: true

                onFlickEnded:  {
                    if (contentY >= myBrightnessVolume_Text.height / 2) {
                        myDevice_Top_center_Text.opacity = 1.0
                        myBrightnessVolume_Text.opacity = 0.0
                    } else if (contentY <= 20) {
                        myDevice_Top_center_Text.opacity = 0.0
                        myBrightnessVolume_Text.opacity = 1.0
                    }
                }
                Text {
                    id: myBrightnessVolume_Text
                    text: qsTr("亮度与音量")
                    color: "black"
                    font.pixelSize: 50
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    opacity: 1.0
                    font.family: "Montserrat Light"
                    Behavior on opacity { PropertyAnimation { duration: 1000; easing.type: Easing.InOutBack } }
                }

                Column {
                    anchors.top: myBrightnessVolume_Text.bottom
                    spacing: 40
                    Rectangle {
                        id: flash_Rect
                        clip: true
                        width: myBrightnessVolume.width
                        height: 320
                        color: "white"
                        Column {
                            Item {
                                width: flash_Rect.width
                                height: flash_Rect.height / 4
                                Text {
                                    text: qsTr("亮度")
                                    color: "black"
                                    font.pixelSize: 30
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.left: parent.left
                                    anchors.leftMargin: 20
                                    font.family: "Montserrat Light"
                                }
                            }
                            Rectangle {
                                width: parent.width - 40
                                anchors.horizontalCenter: parent.horizontalCenter
                                height: 1
                                color: "#c6c6c8"
                            }

                            Item {
                                width: flash_Rect.width
                                height: flash_Rect.height / 4
                                Slider {
                                    id: control
                                    from: 50
                                    to: 255
                                    anchors.right: parent.right
                                    anchors.left: parent.left
                                    height: 50
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.rightMargin: 20
                                    anchors.leftMargin: 20
                                    stepSize: 1
                                    Component.onCompleted: {
                                        board.getSysBrightness()
                                        control.value = board.sysBrightness
                                    }

                                    onValueChanged: {
                                        if (value > 50)
                                            board.setSysBrightness(value.toString())
                                    }
                                    background: Rectangle {
                                        x: control.leftPadding
                                        y: control.topPadding + control.availableHeight / 2 - height / 2
                                        implicitWidth: 200
                                        implicitHeight: 4
                                        width: control.availableWidth
                                        height: implicitHeight
                                        radius: 2
                                        color: "#bdbebf"

                                        Rectangle {
                                            width: control.visualPosition * parent.width
                                            height: parent.height
                                            color: "#0b62f6"
                                            radius: 2
                                        }
                                    }

                                    handle: Rectangle {
                                        x: control.leftPadding + control.visualPosition * (control.availableWidth - width)
                                        y: control.topPadding + control.availableHeight / 2 - height / 2
                                        implicitWidth: 50
                                        implicitHeight: 50
                                        color: "transparent"
                                        Image {
                                            anchors.centerIn: parent
                                            source: control.pressed ? "qrc:/icons/slider_handle_style_pressed.png" : "qrc:/icons/slider_handle_style.png"
                                        }
                                    }
                                }
                            }

                            Rectangle {
                                width: parent.width - 40
                                anchors.horizontalCenter: parent.horizontalCenter
                                height: 1
                                color: "#c6c6c8"
                            }

                            Item {
                                width: flash_Rect.width
                                height: flash_Rect.height / 4
                                Text {
                                    text: qsTr("音量")
                                    color: "black"
                                    font.pixelSize: 30
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.left: parent.left
                                    anchors.leftMargin: 20
                                    font.family: "Montserrat Light"
                                }

                            }

                            Rectangle {
                                width: parent.width - 40
                                anchors.horizontalCenter: parent.horizontalCenter
                                height: 1
                                color: "#c6c6c8"
                            }

                            Item {
                                width: flash_Rect.width
                                height: flash_Rect.height / 4
                                Slider {
                                    id: volume_control
                                    value: global_system_volume
                                    from: 0
                                    to: 1.0
                                    stepSize: 0.01
                                    anchors.right: parent.right
                                    anchors.left: parent.left
                                    height: 50
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.rightMargin: 20
                                    anchors.leftMargin: 20
                                    onValueChanged: {
                                        global_system_volume = value
                                    }
                                    background: Rectangle {
                                        x: volume_control.leftPadding
                                        y: volume_control.topPadding + volume_control.availableHeight / 2 - height / 2
                                        implicitWidth: 200
                                        implicitHeight: 4
                                        width: volume_control.availableWidth
                                        height: implicitHeight
                                        radius: 2
                                        color: "#bdbebf"

                                        Rectangle {
                                            width: volume_control.visualPosition * parent.width
                                            height: parent.height
                                            color: "#0b62f6"
                                            radius: 2
                                        }
                                    }

                                    handle: Rectangle {
                                        x: volume_control.leftPadding + volume_control.visualPosition * (volume_control.availableWidth - width)
                                        y: volume_control.topPadding + volume_control.availableHeight / 2 - height / 2
                                        implicitWidth: 50
                                        implicitHeight: 50
                                        color: "transparent"
                                        Image {
                                            anchors.centerIn: parent
                                            source: volume_control.pressed ? "qrc:/icons/slider_handle_style_pressed.png" : "qrc:/icons/slider_handle_style.png"
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
