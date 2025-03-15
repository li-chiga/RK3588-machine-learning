/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @brief         Common.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @date          2024-04-07
* @link          http://www.openedv.com/forum.php
*******************************************************************/
import QtQuick 2.12
import QtGraphicalEffects 1.12
import QtQuick.Window 2.12
Item {
    property string imageIconPath: ""
    property real applicationX: 0.0
    property real applicationY: 0.0
    property real appIconWidth: 0.0
    property real appIconHeight: 0.0
    property real appDuration: 200
    property int appStateImageScaleY : parent.height / 3
    property int appStateImageScaleX : parent.width / 3
    property QtObject m_appMainBody
    property Window window
    property bool bornOnTheSamePageFlag: true
    property int m_currtentPage: -1
    property bool appStateImageourceIsReady: false
    signal whenAppIsActive(real iconX, real iconY, real iconWidth, real iconHeight, string iconPath, url m_url, int callType, int currentPage)
    signal showAppMainBody(bool show)
    signal backToSystemUi()
    signal appStateImageChange(var image)
    anchors.fill: parent

    onWhenAppIsActive: {
        if (currentPage != -2) {
            if (m_currtentPage == -1) {
                m_currtentPage = currentPage
                bornOnTheSamePageFlag = true
            }
            if (m_currtentPage != currentPage)
                bornOnTheSamePageFlag = false
            else
                bornOnTheSamePageFlag = true
        } else {
            bornOnTheSamePageFlag = true
        }
        if (callType) {
            appDuration = 0
            appImage.opacity = 1.0
            appStateImage.x = iconX
            appStateImage.y = iconY
            appStateImage.width = iconWidth
            appStateImage.height = iconHeight
            appImage.source = m_url
            appStateImage_mask_opacityMask.visible = true

            appDuration = 200
            appStateImage.x = 0
            appStateImage.y = 0
            appImage.opacity = 1.0
            appStateImage.width = parent.width
            appStateImage.height = parent.height
            return
        }
        iconImage.visible = true
        appDuration = 0
        applicationX = iconX
        applicationY = iconY
        appStateImage.x = iconX
        appStateImage.y = iconY
        appIconWidth = iconWidth
        appIconHeight = iconHeight
        appStateImage.width = iconWidth
        appStateImage.height = iconHeight
        appImage.source = m_url
        imageIconPath = iconPath
        appImage.opacity = 0.0
        appStateImage_mask_opacityMask.visible = true

        appDuration = 200
        appStateImage.x = 0
        appStateImage.y = 0
        appImage.opacity = 1.0
        appStateImage.width = parent.width
        appStateImage.height = parent.height
    }

    Item {
        id: appStateImage
        visible: false
        width: parent.width
        height: parent.height
        Behavior on width { PropertyAnimation { duration: appDuration; easing.type: Easing.Linear } }
        Behavior on height { PropertyAnimation { duration: appDuration; easing.type: Easing.Linear } }
        Behavior on x { PropertyAnimation { duration: appDuration; easing.type: Easing.Linear } }
        Behavior on y { PropertyAnimation { duration: appDuration; easing.type: Easing.Linear } }
        onWidthChanged: {
            if (width == window.width && !dragArea.pressed) {
                showAppMainBody(true)
                appStateImage_mask_opacityMask.visible = false
            }
        }
        Image {
            id: iconImage
            source: imageIconPath
            fillMode: Image.PreserveAspectFit
            anchors.fill: parent
            opacity: 1 - appImage.opacity
            //visible: appStateImage.width < window.width / 2
        }


        Image {
            id: appImage
            source: ""
            fillMode: Image.PreserveAspectFit
            anchors.fill: parent
            onSourceChanged: {
                if (appStateImageourceIsReady === false) {
                    appStateImageourceIsReady = true
                    appStateImage_mask_opacityMask.visible = true
                    m_appMainBody.visible = false
                }
            }
            Behavior on opacity { PropertyAnimation { duration: appDuration / 2; easing.type: Easing.Linear } }
        }
    }

    Rectangle {
        id: appStateImage_mask
        anchors.fill: appStateImage
        visible: false
        radius: appImage.width / window.width * 80
    }

    OpacityMask {
        id: appStateImage_mask_opacityMask
        source: appStateImage
        maskSource: appStateImage_mask
        anchors.fill: appStateImage
        visible: false
    }

    Timer {
        id: delayToHideAppMainBody
        repeat: false
        interval: 80 // atleast 80? // 控制按下及取APP状态，高性能的CPU可以减少这个时间
        running: false
        onTriggered: {
            if (appStateImageourceIsReady === true) {
                m_appMainBody.visible = true
                appStateImage_mask_opacityMask.visible = false
            }
        }
    }

    MouseArea {
        id: dragArea
        enabled: true
        y: parent.height - 30
        x: 0
        width: parent.width //- 200
        anchors.horizontalCenter: parent.horizontalCenter
        height:  parent.height / 10
        drag.target: appStateImage
        property int pressedX
        property int pressedY

        onPressed: function(mouse){
            appStateImageourceIsReady = false
            m_appMainBody.visible = true
            appStateImage_mask_opacityMask.visible = false
            appDuration = 0
            pressedX = mouse.x
            pressedY = mouse.y
            m_appMainBody.grabToImage(function(result) {
                appImage.source = result.url
                appStateImageChange(result.image)
            })
        }
        onPositionChanged: function(mouse){
            var scalefactor = (parent.height - Math.abs(appStateImage.y) ) / parent.height
            var scaleY = parent.height * scalefactor
            appStateImage.height = scaleY <= appStateImageScaleY ? appStateImageScaleY : scaleY
            var scaleX = parent.width * scalefactor
            appStateImage.width = scaleX <= appStateImageScaleX ? appStateImageScaleX : scaleX
            appStateImage.y = Math.abs(appStateImage.y) / 3
        }
        onReleased: {
            appDuration = 200
            delayToHideAppMainBody.stop()
            if (appStateImage.width === parent.width) {
                m_appMainBody.visible = true
                appStateImage_mask_opacityMask.visible = false
                delayToHideAppMainBody.restart()
                return
            }

            if (appStateImage.height > parent.height - parent.height / 10) {
                appStateImage.x = 0
                appStateImage.y = 0
                appStateImage.width = parent.width
                appStateImage.height = parent.height
            } else {
                if (bornOnTheSamePageFlag) {
                    appStateImage.x = applicationX
                    appStateImage.y = applicationY
                    appStateImage.width = appIconWidth
                    appStateImage.height = appIconHeight
                } else {
                    appStateImage.x = window.width / 2
                    appStateImage.y = window.height / 3
                    appStateImage.width = 0
                    appStateImage.height = 0
                }
                appImage.opacity = 0
                window.flags = Qt.WindowTransparentForInput  | Qt.FramelessWindowHint
                delayToCallSystemUiShow.restart()
                iconImage.visible = true
                delayTohideIconImage.restart()
            }
        }
    }

    Timer {
        repeat: false
        running: false
        id: delayToCallSystemUiShow
        interval: appDuration
        onTriggered:  { backToSystemUi()}
    }

    Timer {
        repeat: false
        running: false
        id: delayTohideIconImage
        interval: appDuration * 2
        onTriggered:  {iconImage.visible = false}
    }
}
