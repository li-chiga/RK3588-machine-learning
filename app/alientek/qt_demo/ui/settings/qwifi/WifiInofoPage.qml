/******************************************************************
Copyright 2022 Guangzhou ALIENTEK Electronincs Co.,Ltd. All rights reserved
Copyright © Deng Zhimao Co., Ltd. 1990-2030. All rights reserved.
* @projectName   qwifi
* @brief         WifiInofoPage.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @date          2022-12-07
* @link          http://www.openedv.com/forum.php
*******************************************************************/
import QtQuick 2.0
import QtQuick 2.12
import QtQuick.Controls 2.5
import AQuickPlugin 1.0

Item {

    /*Item {
        anchors.top: parent.top
        anchors.topMargin: scaleFfactor * 60
        width: scaleFfactor * 100
        height: scaleFfactor * 60
        Text {
            text: qsTr("无线局域网")
            font.underline: false
            font.family: "Montserrat Light"
            color: "#0b62f6"
            font.pixelSize: scaleFfactor * 25
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: scaleFfactor * 55
            opacity: back_button.opacity
        }
    }*/
    BackButton {
        id: backButton
        backText: "无线局域网"
        onBackButtonClick: {
            //settings_swipeView.currentIndex = 0
            wifi_swipeView.currentIndex = 0
        }
    }

    Item {
        anchors.top: parent.top
        anchors.topMargin: scaleFfactor * 160
        anchors.bottom: parent.bottom
        anchors.bottomMargin: scaleFfactor * 80
        width: parent.width
        Flickable {
            id: flickable
            anchors.fill: parent
            contentHeight: column.height + scaleFfactor * 100
            contentWidth: parent.width
            clip: true
            onFlickStarted: scrollBar.visible = true
            onFlickEnded: scrollBar.visible = false
            ScrollBar.vertical: ScrollBar {
                id: scrollBar
                width: 10
                visible: false
                background: Rectangle {color: "transparent"}
                onActiveChanged: {
                    active = true;
                }
                Component.onCompleted: {
                    scrollBar.active = true;
                }
                contentItem: Rectangle{
                    implicitWidth: 10
                    implicitHeight: 100
                    radius: 2
                    color: scrollBar.pressed ? "#88101010" : "#30101010"
                }
            }

            Column {
                id: column
                anchors.top: parent.top
                anchors.topMargin: 0
                width: parent.width
                spacing: scaleFfactor * 100
                Button {
                    visible: wifi.currentIndex !== -1 && wifi.getcurrentWifiSate() !== AWifi.OnlineState
                    id: join_bt
                    height: scaleFfactor * 80
                    clip: true
                    width: parent.width - scaleFfactor * 50
                    anchors.horizontalCenter: parent.horizontalCenter
                    background: Rectangle{
                        anchors.fill: parent
                        radius: scaleFfactor * 25
                        color: join_bt.pressed ? "#88d7c388" : "white"
                        Behavior on color { PropertyAnimation { duration: 200; easing.type: Easing.Linear } }
                    }
                    Text {
                        text: qsTr("加入此网络")
                        anchors.verticalCenter: parent.verticalCenter
                        color: Qt.rgba(0, 0.5, 1, 1)
                        font.pixelSize: scaleFfactor * 25
                        anchors.left: parent.left
                        anchors.leftMargin: scaleFfactor * 32
                    }

                    onClicked: {
                        wifi_swipeView.currentIndex = 0
                        if (wifi.getcurrentWifiSate() !== AWifi.RegistedNotOnlineState && wifi.getcurrentWifiSate() !== AWifi.OnlineState)
                            actionSheet.open()
                        else
                            wifi.startConnectWifi("")
                    }
                }

                Button {
                    id: ingnore_bt
                    height: scaleFfactor * 80
                    width: parent.width - scaleFfactor  * 50
                    anchors.horizontalCenter: parent.horizontalCenter
                    clip: true
                    visible: wifi.currentIndex !== -1 && wifi.getcurrentWifiSate() !== AWifi.UnknownNotRegistedState
                    background: Rectangle{
                        anchors.fill: parent
                        radius: scaleFfactor * 25
                        color: ingnore_bt.pressed ? "#88d7c388" : "white"
                        Behavior on color { PropertyAnimation { duration: 200; easing.type: Easing.Linear } }
                    }
                    Text {
                        text: qsTr("忽略此网络")
                        anchors.verticalCenter: parent.verticalCenter
                        color: Qt.rgba(0, 0.5, 1, 1)
                        font.pixelSize: scaleFfactor * 25
                        anchors.left: parent.left
                        anchors.leftMargin: scaleFfactor * 32
                    }
                    onClicked: centerChoseStyleDialog.open()
                }
            }
        }
    }
}
