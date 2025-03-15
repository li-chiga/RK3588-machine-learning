/******************************************************************
Copyright 2022 Guangzhou ALIENTEK Electronincs Co.,Ltd. All rights reserved
Copyright © Deng Zhimao Co., Ltd. 1990-2030. All rights reserved.
* @projectName   qwifi
* @brief         WifiListView.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @date          2022-12-01
* @link          http://www.openedv.com/forum.php
*******************************************************************/
import QtQuick 2.12
import QtQuick.Controls 2.5
import AQuickPlugin 1.0

Item {
    property bool reflashListFlag: false

    BackButton {
        id: backButton
        backText: "设置"
        onBackButtonClick: {
            settings_swipeView.currentIndex = 0
        }
    }
    Connections{
        target: app_qwifi
        function onWlanStateChanged(wlanState) {
            if (wlanState === AWifi.Inexistence)
                wlanSwitch.enabled = false
            else
                wlanSwitch.enabled = true
            if (wlanState === AWifi.Up) {
                if (!wlanSwitch.checked) {
                    wlanSwitch.checked = true
                }
            } else if (wlanState === AWifi.Down) {
                if (wlanSwitch.checked) {
                    wlanSwitch.checked = false
                }
            }
        }
    }

    onVisibleChanged: {
        if (visible)
            wifi.getWlanState()
    }
    Text {
        id: appTitle
        text: qsTr("无线局域网")
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: scaleFfactor * 60
        font.pixelSize: scaleFfactor * 30

    }

    Item {
        anchors.top: appTitle.bottom
        anchors.topMargin: scaleFfactor * 10
        anchors.bottom: parent.bottom
        anchors.bottomMargin: scaleFfactor * 20
        width: parent.width
        Flickable {
            id: flickable
            anchors.fill: parent
            contentHeight: wifiListView.height + scaleFfactor * 80
            contentWidth: parent.width
            clip: true
            onFlickStarted: scrollBar.visible = true
            onFlickEnded: scrollBar.visible = false
            ScrollBar.vertical: ScrollBar {
                id: scrollBar
                width: scaleFfactor * 10
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
                    radius: 5
                    //color: scrollBar.hovered ? "#88101010" : "#30101010"
                    color: scrollBar.pressed ? "#88101010" : "#30101010"
                }
            }
            ListView  {
                id: wifiListView
                visible: true
                anchors.top: parent.top
                anchors.topMargin: scaleFfactor * 40
                height: contentHeight
                width: parent.width - scaleFfactor * 50
                anchors.horizontalCenter: parent.horizontalCenter
                orientation:ListView.Vertical
                interactive: false
                clip: true
                model: wifi
                //currentIndex: wifi.currentIndex

                onCurrentIndexChanged: {
                    //wifi.currentIndex = currentIndex
                }

                onCountChanged: {
                    wifiListView.currentIndex = -1
                    reflashListFlag = false
                }

                Component.onCompleted:  {
                    // wifiListView.currentIndex = -1
                }

                delegate: Item {
                    id: itembg
                    width: wifiListView.width
                    property int tmpheight: if (wifi.connectionState === AWifi.OnlineState )
                                                inhomogeneous ? scaleFfactor * 160 : scaleFfactor * 80
                                            else if (wifi.connectionState === AWifi.RegistedNotOnlineState)
                                                inhomogeneous ?  ((wifiState === AWifi.Inexistence) ? scaleFfactor * 160 : scaleFfactor * 240 ): scaleFfactor * 80
                                            else if (wifi.connectionState === AWifi.UnknownNotRegistedState)
                                                inhomogeneous ? scaleFfactor * 240 : scaleFfactor * 80
                                            else
                                                scaleFfactor * 80
                    height: reflashListFlag ?  0  : tmpheight
                    Component.onCompleted: { itembg.height = tmpheight }
                    Behavior on height { PropertyAnimation { duration: 500; easing.type: Easing.Linear } }
                    Text {
                        text: if (wifiState === AWifi.RegistedNotOnlineState && inhomogeneous)
                                  qsTr("我的网络")
                              else if (wifiState === AWifi.UnknownNotRegistedState && inhomogeneous)
                                  qsTr("其他网络")
                              else
                                  qsTr("")
                        anchors.left: parent.left
                        anchors.leftMargin: scaleFfactor * 48
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: scaleFfactor * 80
                        elide: Text.ElideRight
                        font.pixelSize: scaleFfactor * 25
                        visible: (wifiState === AWifi.RegistedNotOnlineState  || wifiState === AWifi.UnknownNotRegistedState) && inhomogeneous
                        color: "gray"
                    }
                    CustomRectangle {
                        radiusCorners: if (wifiState === AWifi.OnlineState)
                                           Qt.AlignLeft |Qt.AlignRight |Qt.AlignBottom
                                       else if (wifi.registedCount === 1 && wifiState === AWifi.RegistedNotOnlineState)
                                           Qt.AlignLeft | Qt.AlignRight | Qt.AlignTop | Qt.AlignBottom
                                       else if (wifi.registedCount == 2 && wifiState === AWifi.RegistedNotOnlineState && wifi.onlineCount !== 0)
                                           if (wifi.registedCount - 1 === index )
                                               Qt.AlignLeft | Qt.AlignRight |  Qt.AlignTop
                                           else
                                               Qt.AlignLeft | Qt.AlignRight |  Qt.AlignBottom
                                       else if (wifi.registedCount == 2 && wifiState === AWifi.RegistedNotOnlineState && wifi.onlineCount === 0)
                                           if (0 === index )
                                               Qt.AlignLeft | Qt.AlignRight |  Qt.AlignTop
                                           else
                                               Qt.AlignLeft | Qt.AlignRight |  Qt.AlignBottom
                                       else if (wifi.registedCount >= 3 && wifiState === AWifi.RegistedNotOnlineState)
                                           if (index === 1 && wifi.onlineCount === 1)
                                               Qt.AlignLeft | Qt.AlignRight |  Qt.AlignTop
                                           else   if (index === 0 && wifi.onlineCount === 0)
                                               Qt.AlignLeft | Qt.AlignRight |  Qt.AlignTop
                                           else if (wifi.registedCount === index && wifi.onlineCount === 1 )
                                               Qt.AlignLeft | Qt.AlignRight |  Qt.AlignBottom
                                           else if (wifi.registedCount - 1 === index && wifi.onlineCount === 0 )
                                               Qt.AlignLeft | Qt.AlignRight |  Qt.AlignBottom
                                           else 0

                                       else if (wifi.unknownCount === 1 && wifiState === AWifi.UnknownNotRegistedState)
                                           Qt.AlignLeft | Qt.AlignRight | Qt.AlignTop | Qt.AlignBottom
                                       else if (wifi.unknownCount == 2 && wifiState === AWifi.UnknownNotRegistedState)
                                           if (wifi.onlineCount === 0 && wifi.registedCount === 0)
                                               if (0 === index)
                                                   Qt.AlignLeft | Qt.AlignRight |  Qt.AlignTop
                                               else
                                                   Qt.AlignLeft | Qt.AlignRight |  Qt.AlignBottom
                                           else if  (wifi.onlineCount === 1 && wifi.registedCount === 0)
                                               if (1 === index)
                                                   Qt.AlignLeft | Qt.AlignRight |  Qt.AlignTop
                                               else
                                                   Qt.AlignLeft | Qt.AlignRight |  Qt.AlignBottom
                                           else if  (wifi.onlineCount === 1 && wifi.registedCount !== 0)
                                               if (2 === index)
                                                   Qt.AlignLeft | Qt.AlignRight |  Qt.AlignTop
                                               else
                                                   Qt.AlignLeft | Qt.AlignRight |  Qt.AlignBottom
                                           else 0
                                       else if (wifi.unknownCount >= 3 && wifi.onlineCount !== 0 && wifi.registedCount !== 0)
                                           if (wifi.registedCount + 1 === index)
                                               Qt.AlignLeft | Qt.AlignRight |  Qt.AlignTop
                                           else if (wifi.registedCount + wifi.unknownCount === index)
                                               Qt.AlignLeft | Qt.AlignRight |  Qt.AlignBottom
                                           else 0
                                       else if (wifi.unknownCount >= 3 && wifi.onlineCount === 0 && wifi.registedCount === 0)
                                           if (0 === index)
                                               Qt.AlignLeft | Qt.AlignRight |  Qt.AlignTop
                                           else if (wifi.unknownCount - 1 == index)
                                               Qt.AlignLeft | Qt.AlignRight |  Qt.AlignBottom
                                           else 0

                                       else if (wifi.unknownCount >= 3 && wifi.onlineCount === 1 && wifi.registedCount === 0)
                                           if (1 === index)
                                               Qt.AlignLeft | Qt.AlignRight |  Qt.AlignTop
                                           else if (wifi.unknownCount  === index)
                                               Qt.AlignLeft | Qt.AlignRight |  Qt.AlignBottom
                                           else 0

                                       else if (wifi.unknownCount >= 3 && wifi.onlineCount === 1 && wifi.registedCount !== 0)
                                           if (wifi.registedCount + 1 === index)
                                               Qt.AlignLeft | Qt.AlignRight |  Qt.AlignTop
                                           else if (wifi.registedCount + wifi.unknownCount - 1 === index)
                                               Qt.AlignLeft | Qt.AlignRight |  Qt.AlignBottom
                                           else 0

                                       else if (wifi.unknownCount >= 3 && wifi.onlineCount === 0 && wifi.registedCount !== 0)
                                           if (wifi.registedCount  === index)
                                               Qt.AlignLeft | Qt.AlignRight |  Qt.AlignTop
                                           else if (wifi.registedCount + wifi.unknownCount - 1 === index)
                                               Qt.AlignLeft | Qt.AlignRight |  Qt.AlignBottom
                                           else 0
                                       else 0
                        height: scaleFfactor * 80
                        radius: scaleFfactor * 25
                        width: parent.width
                        anchors.bottom: parent.bottom
                        anchors.left: parent.left
                        clip: true
                        color: mouseArea.pressed ? "#DCDCDC" : "white"
                        Behavior on color { PropertyAnimation { duration: 200; easing.type: Easing.Linear } }
                        Behavior on height { PropertyAnimation { duration: 200; easing.type: Easing.Linear } }
                        MouseArea {
                            id: mouseArea
                            anchors.fill: parent
                            onClicked: {
                                wifiListView.currentIndex = index
                                wifi.currentIndex  = index
                                if (wifi.getcurrentWifiSate() !== AWifi.RegistedNotOnlineState
                                        && wifi.getcurrentWifiSate() !== AWifi.OnlineState
                                        && wifi.getcurrentEncryMode() !== AWifi.None)
                                    actionSheet.open()
                                else
                                    wifi.startConnectWifi("")
                            }
                        }

                        Rectangle {
                            anchors.top: parent.top
                            width: parent.width - scaleFfactor * 84
                            anchors.right: parent.right
                            height: 1
                            color: "#c6c6c8"
                            visible: !inhomogeneous | wifiState === AWifi.OnlineState
                        }

                        Image {
                            id: connected_icon
                            visible: wifiState === 0
                            source: "qrc:/qwifi/icons/wifi_connected_icon.png"
                            anchors.left: parent.left
                            anchors.leftMargin: scaleFfactor * 24
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Image {
                            id: connect_process_icon
                            visible: wifiState !== 0 && wifiListView.currentIndex === index && !wifi.scanState
                            source: "qrc:/qwifi/icons/wifi_process_icon.png"
                            anchors.left: parent.left
                            anchors.leftMargin: scaleFfactor * 24
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        RotationAnimator {
                            id: animator_connect_process
                            target: connect_process_icon
                            from: 0
                            to: 360
                            duration: 1000
                            loops: Animation.Infinite
                            running: connect_process_icon.visible
                            onRunningChanged: {
                                if (running === false) {
                                    from = connect_process_icon.rotation
                                    to = from + 360
                                }
                            }
                            onStopped: connect_process_icon.rotation = 0
                        }

                        Row {
                            anchors.right: parent.right
                            anchors.rightMargin: 32
                            anchors.verticalCenter: parent.verticalCenter
                            Item {
                                width: scaleFfactor * 80
                                height: scaleFfactor * 64
                                Image {
                                    id: lock_icon
                                    visible: encryMode !== AWifi.None
                                    width: scaleFfactor * 24
                                    height: width
                                    source: "qrc:/qwifi/icons/wifi_lock_icon.png"
                                    anchors.centerIn: parent
                                }
                            }
                            Item {
                                width: scaleFfactor * 80
                                height: scaleFfactor * 64
                                visible:  strength !== AWifi.UnknownLevel
                                Image {
                                    id: signal_icon
                                    width: scaleFfactor * 40
                                    height: width
                                    source: if (strength === AWifi.WeakLevel)
                                                "qrc:/qwifi/icons/wifi_singal_weak.png"
                                            else if (strength === AWifi.MediumLevel)
                                                "qrc:/qwifi/icons/wifi_singal_medium.png"
                                            else if (strength === AWifi.StrengthLevel)
                                                "qrc:/qwifi/icons/wifi_singal_strong.png"
                                            else
                                                ""
                                    anchors.centerIn: parent
                                }
                            }

                            Button {
                                id: info_icon
                                width: scaleFfactor * 80
                                focus: Qt.NoFocus
                                height: parent.height
                                opacity: info_icon.pressed ? 0.8 : 1.0
                                anchors.verticalCenter: parent.verticalCenter
                                background: Image {
                                    source: "qrc:/qwifi/icons/wifi_info_icon.png"
                                    anchors.centerIn: parent
                                }
                                onClicked:  {
                                    wifiListView.currentIndex = index
                                    wifi.currentIndex  = index
                                    wifi_swipeView.currentIndex = 1
                                }
                            }
                        }

                        Text {
                            id: wifi_name
                            width: parent.width / 2
                            text:  name
                            elide: Text.ElideRight
                            font.pixelSize: scaleFfactor * 30
                            anchors.left: parent.left
                            anchors.leftMargin: scaleFfactor * 96
                            anchors.verticalCenter: parent.verticalCenter
                            color: "black"
                        }
                    }
                }
            }

            CustomRectangle {
                color: "white"
                height: scaleFfactor * 80
                radius: scaleFfactor * 25
                width: wifiListView.width
                anchors.bottom: wifiListView.top
                anchors.bottomMargin: - scaleFfactor * 80
                anchors.horizontalCenter: parent.horizontalCenter
                radiusCorners:  if (wifi.connectionState === AWifi.OnlineState)
                                    Qt.AlignLeft | Qt.AlignRight |  Qt.AlignTop
                                else
                                    Qt.AlignLeft | Qt.AlignRight |  Qt.AlignTop | Qt.AlignBottom
                clip: true
                CustomSwitch {
                    id: wlanSwitch
                    anchors.right: parent.right
                    anchors.rightMargin: scaleFfactor * 40
                    anchors.verticalCenter: parent.verticalCenter
                    checked: false
                    width: scaleFfactor * 100
                    height: scaleFfactor * 60
                    Component.onCompleted: wifi.checkWifiState()
                    Connections {
                        target: wifi
                        function onPreviousWifiState(on) {
                            wlanSwitch.checked = on
                        }
                    }
                    onCheckedChanged: {
                        if(checked) {
                            reflashListFlag = true
                            wifi.reflashWifiList()
                        } else
                            wifiListView.model.clear()
                        wifi.setWifiEnable(checked)
                        wifi.saveWifiState(checked)
                    }
                }
                Text {
                    id: wlanText
                    text: qsTr("无线局域网")
                    anchors.left: parent.left
                    anchors.leftMargin: scaleFfactor * 96
                    anchors.verticalCenter: parent.verticalCenter
                    elide: Text.ElideRight
                    font.pixelSize: scaleFfactor * 30
                }

                Image {
                    id: connect_process_icon1
                    visible: !wifi.scanState && wlanSwitch.checked
                    source: "qrc:/qwifi/icons/wifi_process_icon.png"
                    anchors.left: parent.left
                    anchors.leftMargin: scaleFfactor * 24
                    anchors.verticalCenter: parent.verticalCenter
                }

                RotationAnimator {
                    id: animator_connect_process1
                    target: connect_process_icon1
                    from: 0
                    to: 360
                    duration: 1000
                    loops: Animation.Infinite
                    running: connect_process_icon1.visible
                    onRunningChanged: {
                        if (running === false) {
                            from = connect_process_icon1.rotation
                            to = from + 360
                        }
                    }
                    onStopped: connect_process_icon1.rotation = 0
                }
            }
        }
    }
}
