/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @brief         main.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @date          2024-04-07
* @link          http://www.openedv.com/forum.php
*******************************************************************/
import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.12
import QtQuick.Layouts 1.12
import com.alientek.qmlcomponents 1.0
Window {
    //  The rk3568 scales 1080P to 720p for smoothness
    width: Screen.desktopAvailableWidth === 1080 && hostName === "ATK-DLRK3568" ? 720 : Screen.desktopAvailableWidth
    height: Screen.desktopAvailableHeight  === 1920 && hostName === "ATK-DLRK3568" ? 1280 : Screen.desktopAvailableHeight
    visible: true
    property real scaleFfactor: desktop.width / 720
    flags: Qt.FramelessWindowHint
    x: 0
    y: 0
    id: desktop

    SystemUICommonApiServer {
        id: systemUICommonApiServer
        onAppAsktoHideOrShow: function(action) {
            if (action === SystemUICommonApiServer.Hide) {
                phonebg_scale.xScale = 1.2
                fastBlur.radius = 64
                control_item_scale.xScale = 0.95
                brightness_Mask.opacity = 0.3
            }
            if (action === SystemUICommonApiServer.Show) {
                phonebg_scale.xScale = 1.0
                delayRequestActivateTimer.restart()
                systemUICommonApiServer.currtentLauchAppName = ""
                fastBlur.radius = 0
                control_item_scale.xScale = 1.0
                brightness_Mask.opacity = 0

            }
        }
        onCurrtentLauchAppNameChanged: {
            if (systemUICommonApiServer.currtentLauchAppName === "null")
                systemUICommonApiServer.appAsktoHideOrShow(SystemUICommonApiServer.Show)
        }
    }

    Timer {
        id: delayRequestActivateTimer
        repeat: false
        running: false
        interval: 300 // at least 200, unless the icon will blink
        onTriggered: {
            desktop.requestActivate()
            desktop.flags = Qt.FramelessWindowHint
        }
    }

    Item {
        id: rootItem
        anchors.fill: parent
        Image {
            id: phonebg
            anchors.centerIn: parent
            height: parent.height
            width: parent.width
            fillMode: Image.PreserveAspectCrop
            smooth: true
            source: "file://" + appCurrtentDir + "/src/iphone/iphonebg/iphone15bg.jpg"
            transform: Scale {
                id: phonebg_scale
                origin.x: phonebg.width / 2
                origin.y: phonebg.height / 2
                Behavior on xScale { PropertyAnimation { duration: 350; easing.type: Easing.Linear } }
                xScale: 1.0
                yScale: xScale
            }
            Rectangle {
                anchors.fill: parent
                color: "#55404040"
            }
        }
        Item {
            id: control_item
            width: desktop.width
            height: desktop.height

            transform: Scale {
                id: control_item_scale
                origin.x: control_item.width / 2
                origin.y: control_item.height / 2
                Behavior on xScale { PropertyAnimation { duration: 50; easing.type: Easing.Linear } }
                xScale: 1.0
                yScale: xScale
            }

            SwipeView {
                id: main_swipeView
                visible: true
                anchors.fill: parent
                clip: true
                Page1 {}
                Page2 {}
            }
            BottomApp {}
            SearchBox{}
        }
    }

    PageIndicator {
        id: indicator
        count: main_swipeView.count
        visible: true
        currentIndex: main_swipeView.currentIndex
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: desktop.height / 5
        delegate: indicator_delegate
        Component {
            id: indicator_delegate
            Rectangle {
                width: 6
                height: 6
                color: main_swipeView.currentIndex !== index  ? "#dddddd" : "white"
                radius: 3
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }

    function callApp(name, x, y, item, iconPath, type, currtentPage) {
        desktop.flags = Qt.FramelessWindowHint |  Qt.WindowTransparentForInput
        systemUICommonApiServer.setAppProperty(x, y, item.width, item.height, iconPath, type, currtentPage)
        systemUICommonApiServer.currtentLauchAppName = name
        systemUICommonApiServer.serverSendVariant(name, SystemUICommonApiServer.ActivateControl, SystemUICommonApiServer.IsRunningInBackground, "")
    }

    FastBlur {
        id: fastBlur
        source: rootItem
        width: source.width
        height: source.height
        radius: 0
        Behavior on radius { PropertyAnimation { duration: 200; easing.type: Easing.OutCubic } }
    }

    SystemTime {
        id: systemTime
    }

    RowLayout {
        visible: false
        height: desktop.width / 720 * 60
        anchors.left: parent.left
        anchors.leftMargin: desktop.width / 720 * 55
        anchors.right: parent.right
        anchors.rightMargin: desktop.width / 720 * 55
        Text {
            id: timeText
            text: systemTime.system_time
            font.bold: false
            color: "white"
            font.pixelSize: desktop.width / 720 * 30
            font.letterSpacing: 3
            Layout.alignment: Qt.AlignVCenter
        }
    }

    MouseArea {
        enabled: true
        id: mouseArea_bottom
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        height: 40 * scaleFfactor
        width: parent.width
        property real yPostion: 0
        onPressed: {
            yPostion = mapToItem(parent, mouse.x, mouse.y).y
        }

        onPositionChanged: {
            var point = mapToItem(parent, mouse.x, mouse.y)
            if (point.y > desktop.height / 10 * 9) {
                var xScale = point.y / desktop.height
                control_item_scale.xScale = xScale
                fastBlur.radius = (desktop.height - point.y) / 1.45
                control_item_scale.xScale = point.y / desktop.height
                phonebg_scale.xScale = 1.0 + 1.0 - xScale
                brightness_Mask.opacity = (1.0 - xScale) * 3
            }
            yPostion = point.y
        }
        onReleased: {
            if (yPostion < desktop.height / 10 * 9) {
                if (viewcontroller.appCounts >= 1) {
                    viewcontroller.visible = true
                    phonebg_scale.xScale = 1.2
                    fastBlur.radius = 64
                    control_item_scale.xScale = 0.95
                    brightness_Mask.opacity = 0.3
                }
            }
            if (!viewcontroller.visible) {
                control_item_scale.xScale = 1.0
                fastBlur.radius = 0
                phonebg_scale.xScale = 1.0
                brightness_Mask.opacity = 0
            }
        }
    }

    Rectangle {
        id: brightness_Mask
        anchors.fill: parent
        color: "#404040"
        opacity: 0
        Behavior on opacity { PropertyAnimation { duration: 200; easing.type: Easing.OutCubic } }
    }

    Viewcontroller {
        id: viewcontroller
        visible: false
        width: parent.width
        height: parent.height
        anchors.centerIn: parent
        transform: Scale {
            id: viewcontroller_item_scale
            origin.x: viewcontroller.width / 2
            origin.y: viewcontroller.height / 2
            Behavior on xScale { PropertyAnimation { duration: 300; easing.type: Easing.OutCubic } }
            xScale: viewcontroller.visible ? 1.0 : 1.5
            yScale: xScale
        }
        onGoBackToDesktop: {
            if (normal) {
                viewcontroller.visible = false
                control_item_scale.xScale = 1.0
                fastBlur.radius = 0
                phonebg_scale.xScale = 1.0
                brightness_Mask.opacity = 0
            } else
                delaytoHide_viewcontroller_timer.restart()
        }
        onNoAppIsRunning: {
            viewcontroller.visible = false
            control_item_scale.xScale = 1.0
            fastBlur.radius = 0
            phonebg_scale.xScale = 1.0
            brightness_Mask.opacity = 0
        }
    }

    Timer {
        id: delaytoHide_viewcontroller_timer
        repeat: false
        interval: 250 // at least 250, unless the viewcontroller will blink
        onTriggered: viewcontroller.visible = false
    }
}
