import QtQuick 2.0

Item {
    visible: settings_swipeView.currentIndex === 1
    BackButton {
        id: backButton
        backText: "设置"
        onBackButtonClick: {
            settings_swipeView.currentIndex = 0
        }
    }
    Text {
        id: setting_Top_center_Text
        text: qsTr("Apple ID")
        z: 10
        color: "black"
        font.pixelSize: scaleFfactor * 25
        anchors.top: parent.top
        anchors.topMargin: scaleFfactor * 70
        opacity: 1.0
        font.weight: Font.DemiBold
        font.family: "Montserrat Light"
        anchors.horizontalCenter: parent.horizontalCenter
        Behavior on opacity { PropertyAnimation { duration: 1000; easing.type: Easing.InOutBack } }
    }

    Rectangle {
        id: top_line
        anchors.top: parent.top
        anchors.topMargin: scaleFfactor * 120
        width: settingsLayout.width
        height: 1
        color: "#ddc6c6c8"
        z: 5
        visible: appleid_flickable.contentY > 45
    }


    Item {
        id: item1
        anchors.top: parent.top
        anchors.topMargin: scaleFfactor * 120
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.rightMargin: 0
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        Flickable {
            id: appleid_flickable
            anchors.fill: parent
            contentHeight: parent.height + scaleFfactor * 80
            contentWidth: parent.width
            clip: true

            Column {
                id: colum1
                anchors.top: parent.top
                anchors.topMargin: scaleFfactor * 50
                anchors.horizontalCenter: parent.horizontalCenter
                width: contentItem.width
                spacing: scaleFfactor * 10

                Item {
                    id: logo
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: scaleFfactor * 135
                    height: width
                    Image {
                        anchors.fill: parent
                        source: "file:///" + appCurrtentDir + "/resource/logo/alientek_logo.png"
                    }
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: qsTr("正点原子")
                    color: "black"
                    font.bold: true
                    font.pixelSize: scaleFfactor * 45
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: qsTr("www.openedv.com")
                    color: "gray"
                    font.pixelSize: scaleFfactor * 25
                }
            }
            Column {
                anchors.top: colum1.bottom
                anchors.left: parent.left
                anchors.leftMargin: scaleFfactor * 20
                anchors.topMargin: scaleFfactor * 10
                spacing: settingsLayout.height / 1280 * 70
                anchors.horizontalCenter: parent.horizontalCenter

                Rectangle {
                    clip: true
                    id: id_info_Rect
                    width: parent.width
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: scaleFfactor * 320
                    color: "white"
                    radius: scaleFfactor * 30
                    Column {
                        anchors.fill: parent
                        Item {
                            id: id_item_1
                            width: id_info_Rect.width
                            height: id_info_Rect.height / 4

                            Text {
                                id: wlan_text
                                text: qsTr("姓名、电话号码、电子邮件")
                                color: "black"
                                font.pixelSize: settingsLayout.width  / 720 * 30
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: parent.left
                                anchors.leftMargin: scaleFfactor * 25
                            }
                        }
                        Rectangle {
                            id: line_net1
                            width: parent.width -  id_info_Rect.width / 720 * 25
                            anchors.right: parent.right
                            height: 1
                            color: "#c6c6c8"
                        }
                        Item {
                            id: id_item_2
                            width: id_item_1.width
                            height: id_item_1.height

                            Text {
                                id: bluetooth_text
                                text: qsTr("密码与安全性")
                                color: "black"
                                font.pixelSize: wlan_text.font.pixelSize
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: parent.left
                                anchors.leftMargin: scaleFfactor * 25
                            }
                        }
                        Rectangle {
                            width: line_net1.width
                            anchors.right: parent.right
                            height: 1
                            color: "#c6c6c8"
                        }
                        Item {
                            id: id_item_3
                            width: id_item_1.width
                            height: id_item_1.height

                            Text {
                                id: connet_text
                                text: qsTr("付款与配送")
                                color: "black"
                                font.pixelSize: wlan_text.font.pixelSize
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: parent.left
                                anchors.leftMargin: scaleFfactor * 25
                            }
                        }
                        Rectangle {
                            width: line_net1.width
                            anchors.right: parent.right
                            height: 1
                            color: "#c6c6c8"
                        }
                        Item {
                            id: id_item_4
                            width: id_item_1.width
                            height: id_item_1.height

                            Text {
                                id: subscription_text
                                text: qsTr("订阅")
                                color: "black"
                                font.pixelSize: wlan_text.font.pixelSize
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: parent.left
                                anchors.leftMargin: scaleFfactor * 25
                            }
                        }
                    }
                }
            }

        }
    }
}
