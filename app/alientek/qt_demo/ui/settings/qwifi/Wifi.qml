/******************************************************************
Copyright 2022 Guangzhou ALIENTEK Electronincs Co.,Ltd. All rights reserved
Copyright © Deng Zhimao Co., Ltd. 1990-2030. All rights reserved.
* @projectName   qwifi
* @brief         Wifi.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @date          2022-11-29
* @link          http://www.openedv.com/forum.php
*******************************************************************/
import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.VirtualKeyboard 2.2
import QtQuick.VirtualKeyboard.Settings 2.2
import QtQuick.Controls 2.5

import AQuickPlugin 1.0
Item {
    id: app_qwifi
    signal inputPanelReadyOpen()
    signal inputPanelReadyClose()
    signal wlanStateChanged(var wlanState)

    onVisibleChanged: {
        if (visible)
            actionSheet.visible = false
    }

    Rectangle {
        anchors.fill: parent
        color: "#f0f0f0"
    }

    InputPanel {
        id: inputPanel
        z: 99
        x: 0
        y: app_qwifi.height
        width: app_qwifi.width

        states: State {
            name: "visible"
            when: inputPanel.active
            PropertyChanges {
                target: inputPanel
                y: app_qwifi.height - inputPanel.height - 50
            }
        }
        transitions: Transition {
            from: ""
            to: "visible"
            reversible: true
            ParallelAnimation {
                NumberAnimation {
                    properties: "y"
                    duration: 50
                    easing.type: Easing.InOutQuad
                }
            }
        }
    }

    Binding {
        target: VirtualKeyboardSettings
        property: "activeLocales"
        value: ["zh_CN", "en_US"]
    }

    Connections {
        target: settingsLayout
        function onReduceScanFrequency(time) {
            wifi.scanInterval = time
        }
    }

    AWifi {
        id: wifi
        scanInterval: 23000 //13000ms is scan timer. 10s is a period
        onCurrentIndexChanged: {
            currentIndex = -1
        }
        onScanStateChanged: {
            if (wifi.connectionState === AWifi.OnlineState)
                wifiConnectionStateChanged(true, wifi.getWifiStrength(0))
            else
                wifiConnectionStateChanged(false, 0)
        }
    }

    SwipeView {
        id: wifi_swipeView
        visible: true
        anchors.fill: parent
        clip: true
        interactive: false
        Item {
            WifiListView {
                id: wifiListView
                anchors.fill: parent
            }
            ActionSheet {
                id: actionSheet
            }
        }
        WifiInofoPage{ }
        onCurrentIndexChanged: {
            if (wifi_swipeView .currentIndex === 1) {
                wifi.setModal(true)
            }
            if (wifi_swipeView .currentIndex === 0) {
                wifi.setModal(false)
            }
        }
    }


    /*Button {
        id: back_button
        anchors.top: parent.top
        anchors.topMargin: scaleFfactor * 60
        visible: wifi_swipeView.currentIndex != 0
        width: scaleFfactor * 200
        height: scaleFfactor * 60
        opacity: back_button.pressed ? 0.5 : 1.0
        background: Image {
            id: back_image
            source: "qrc:/qwifi/icons/back.png"
            width: scaleFfactor * 32
            height: width
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: scaleFfactor * 25
        }
        onClicked: wifi_swipeView.currentIndex = 0
    }*/

    CenterChoseStyleDialog {
        id: centerChoseStyleDialog
        textTitle: "要移除无线局域网\n\"" + (wifi.currentIndex !== -1 ? wifi.getcurrentName() : "" ) + "\"吗？"
        textSubTitle: "您的设备将不再加入此无线局域网络。"
        onAccepted: {
            wifi_swipeView.currentIndex = 0
            wifi.ignoreDevice()
            centerChoseStyleDialog.close()
            wifi.setModal(false)
        }
        onDiscarded: centerChoseStyleDialog.close()
    }

    CenterChoseStyleDialog {
        id: centerChoseStyleDialog1
        textTitle: "Wifi初始化失败"
        textSubTitle: "请您确认Wifi设备是否正常运行"
        onAccepted: {
            centerChoseStyleDialog1.close()
        }
        onDiscarded: centerChoseStyleDialog1.close()
    }
}
