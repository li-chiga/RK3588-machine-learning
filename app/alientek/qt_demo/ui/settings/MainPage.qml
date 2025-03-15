/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @projectName   QDesktop
* @brief         MainPage.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @link          www.openedv.com
* @date          2021-10-27
*******************************************************************/
import QtQuick 2.12
import QtQuick.Controls 2.5

Item {
    id: mainPage
    property QtObject settingText2Object: settingText2

    Rectangle {
        id: top_line
        anchors.bottom: item1.top
        width: settingsLayout.width
        height: 1
        color: "#ddc6c6c8"
        z: 5
    }

    Text {
        id: settingText1
        text: qsTr("设置")
        font.pixelSize: scaleFfactor * 30
        font.bold: true
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: item1.top
        visible: settings_flickable.visibleArea.yPosition >= 0.067
    }

    Item {
        id: item1
        anchors.top: parent.top
        anchors.topMargin: settingsLayout.width / 6
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.rightMargin: 0
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        Flickable {
            id: settings_flickable
            anchors.fill: parent
            contentHeight: parent.height + scaleFfactor * 100
            contentWidth: parent.width
            clip: true
            visibleArea.onYPositionChanged: {
                //console.log(visibleArea.yPosition)
            }

            Column {
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.leftMargin: scaleFfactor * 20
                anchors.topMargin: user_icon.anchors.leftMargin * 4
                spacing: settingsLayout.height / 1280 * 70
                anchors.horizontalCenter: parent.horizontalCenter

                Rectangle {
                    //clip: true
                    id: user_Rect
                    width: parent.width - scaleFfactor * 50
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: scaleFfactor * 130
                    radius: height / 5
                    color: device_mouseArea.pressed ? "#DCDCDC" : "white"
                    Behavior on color { PropertyAnimation { duration: 200; easing.type: Easing.Linear } }
                    Text {
                        id: settingText2
                        text: qsTr("设置")
                        font.pixelSize: scaleFfactor * 60
                        font.bold: true
                        anchors.bottom: parent.top
                    }
                    MouseArea {
                        id: device_mouseArea
                        anchors.fill: parent
                        onClicked: {
                            settings_swipeView.contentItem.highlightMoveDuration = 200
                            settings_swipeView.currentIndex = 1
                        }
                    }
                    Image {
                        id: user_icon
                        width: scaleFfactor * 120
                        height: width
                        source: "file:///" + appCurrtentDir + "/resource/logo/alientek_logo.png"
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: scaleFfactor * 25
                    }
                    Text {
                        id: user_text
                        text: qsTr("正点原子")
                        color: "black"
                        font.pixelSize: scaleFfactor * 45
                        anchors.bottom: parent.verticalCenter
                        anchors.left: user_icon.right
                        anchors.leftMargin: scaleFfactor * 20
                        font.weight: Font.Medium
                    }

                    Text {
                        id: alientek_text
                        text: qsTr("Apple ID、iCloud、媒体与购买项目")
                        color: "black"
                        font.pixelSize: scaleFfactor * 25
                        anchors.top: parent.verticalCenter
                        anchors.left: user_icon.right
                        anchors.leftMargin: scaleFfactor * 20
                        font.weight: Font.Medium
                    }

                    Image {
                        id: next1
                        width: wifi_icon.anchors.leftMargin
                        height: width
                        source: "qrc:/icons/item_next.png"
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        anchors.rightMargin: user_icon.anchors.leftMargin
                    }
                }

                Rectangle {
                    clip: true
                    id: net_Rect
                    width: user_Rect.width
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: scaleFfactor * 80
                    radius: user_Rect.radius
                    color: "white"
                    Column {
                        anchors.fill: parent
                        CustomRectangle {
                            radiusCorners:  Qt.AlignLeft |  Qt.AlignRight | Qt.AlignTop | Qt.AlignBottom
                            color: wlan_mouseArea.pressed ? "#DCDCDC" : "white"
                            Behavior on color { PropertyAnimation { duration: 200; easing.type: Easing.Linear } }
                            radius: user_Rect.radius
                            id: net_item_1
                            width: net_Rect.width
                            height: 80 * scaleFfactor
                            MouseArea {
                                id: wlan_mouseArea
                                anchors.fill: parent
                                onClicked: {
                                    settings_swipeView.currentIndex = 2
                                }
                            }

                            Image {
                                id: wifi_icon
                                width:  scaleFfactor * 64
                                height: width
                                source: "qrc:/icons/wifi_icon.png"
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: parent.left
                                anchors.leftMargin: scaleFfactor * 20
                            }

                            Text {
                                id: wlan_text
                                text: qsTr("无线局域网")
                                color: "black"
                                font.pixelSize: scaleFfactor * 30
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: wifi_icon.right
                                anchors.leftMargin: wifi_icon.anchors.leftMargin
                            }

                            Image {
                                id: next2
                                width: wifi_icon.anchors.leftMargin
                                height: width
                                source: "qrc:/icons/item_next.png"
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.right: parent.right
                                anchors.rightMargin: user_icon.anchors.leftMargin
                                opacity: device_mouseArea.pressed ? 0.8 : 1
                            }
                        }
                        /*Rectangle {
                            id: line_net1
                            width: parent.width - scaleFfactor * 120
                            anchors.right: parent.right
                            height: 1
                            color: "#c6c6c8"
                        }
                        Item {
                            id: net_item_2
                            width: net_item_1.width
                            height: net_item_1.height

                            Image {
                                id: bluetooth_icon
                                width:  wifi_icon.width
                                height: width
                                source: "qrc:/icons/bluetooth_icon.png"
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: parent.left
                                anchors.leftMargin: wifi_icon.anchors.leftMargin
                            }

                            Text {
                                id: bluetooth_text
                                text: qsTr("蓝牙")
                                color: "black"
                                font.pixelSize: wlan_text.font.pixelSize
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: bluetooth_icon.right
                                anchors.leftMargin: wifi_icon.anchors.leftMargin
                            }
                            Image {
                                id: next3
                                width: wifi_icon.anchors.leftMargin
                                height: width
                                source: "qrc:/icons/item_next.png"
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.right: parent.right
                                anchors.rightMargin: user_icon.anchors.leftMargin
                                opacity: device_mouseArea.pressed ? 0.8 : 1
                                visible: false
                            }
                        }
                        Rectangle {
                            width: line_net1.width
                            anchors.right: parent.right
                            height: 1
                            color: "#c6c6c8"
                        }
                        Item {
                            id: net_item_3
                            width: net_item_1.width
                            height: net_item_1.height

                            Image {
                                id: connet_icon
                                width:  wifi_icon.width
                                height: width
                                source: "qrc:/icons/connet_icon.png"
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: parent.left
                                anchors.leftMargin: wifi_icon.anchors.leftMargin
                            }

                            Text {
                                id: connet_text
                                text: qsTr("个人热点")
                                color: "black"
                                font.pixelSize: wlan_text.font.pixelSize
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: connet_icon.right
                                anchors.leftMargin: wifi_icon.anchors.leftMargin
                            }
                            Image {
                                id: next4
                                width:wifi_icon.anchors.leftMargin
                                height: width
                                source: "qrc:/icons/item_next.png"
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.right: parent.right
                                anchors.rightMargin: user_icon.anchors.leftMargin
                                opacity: device_mouseArea.pressed ? 0.8 : 1
                                visible: false
                            }
                        }*/
                    }
                }

                /*Rectangle {
                    clip: true
                    id: media_Rect
                    width: user_Rect.width
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: scaleFfactor * 160
                    color: "white"
                    radius: user_Rect.radius
                    Column {
                        anchors.fill: parent
                        Item {
                            id: media_item_1
                            width: net_item_1.width
                            height: net_item_1.height

                            Image {
                                id: volume_icon
                                width:  wifi_icon.width
                                height: width
                                source: "qrc:/icons/volume_icon.png"
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: parent.left
                                anchors.leftMargin: wifi_icon.anchors.leftMargin
                            }

                            Text {
                                id: volume_text
                                text: qsTr("声音")
                                color: "black"
                                font.pixelSize: wlan_text.font.pixelSize
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: volume_icon.right
                                anchors.leftMargin: wifi_icon.anchors.leftMargin
                            }
                            Image {
                                id: next5
                                width:wifi_icon.anchors.leftMargin
                                height: width
                                source: "qrc:/icons/item_next.png"
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.right: parent.right
                                anchors.rightMargin: user_icon.anchors.leftMargin
                                opacity: device_mouseArea.pressed ? 0.8 : 1
                                visible: false
                            }
                        }
                        Rectangle {
                            width: line_net1.width
                            anchors.right: parent.right
                            height: 1
                            color: "#c6c6c8"
                        }
                        Item {
                            id: media_item_2
                            width: net_item_1.width
                            height: net_item_1.height

                            Image {
                                id: brightness_icon
                                width:  wifi_icon.width
                                height: width
                                source: "qrc:/icons/brightness_icon.png"
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: parent.left
                                anchors.leftMargin: wifi_icon.anchors.leftMargin
                            }

                            Text {
                                id:  brightness_text
                                text: qsTr("显示与亮度")
                                color: "black"
                                font.pixelSize: wlan_text.font.pixelSize
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: brightness_icon.right
                                anchors.leftMargin: wifi_icon.anchors.leftMargin
                            }
                            Image {
                                id: next6
                                width:wifi_icon.anchors.leftMargin
                                height: width
                                source: "qrc:/icons/item_next.png"
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.right: parent.right
                                anchors.rightMargin: user_icon.anchors.leftMargin
                                opacity: device_mouseArea.pressed ? 0.8 : 1
                                visible: false
                            }
                        }
                    }
                }*/
            }
        }
    }
}
