/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @brief         main.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @date          2024-04-12
* @link          http://www.openedv.com/forum.php
*******************************************************************/
import QtQuick 2.12
import QtQuick.Window 2.12
import com.alientek.qmlcomponents 1.0
Window {
    visible: true
    width: Screen.desktopAvailableWidth
    height: Screen.desktopAvailableHeight
    id: app_fileview
    flags: Qt.FramelessWindowHint
    x: 0
    y: 0
    color: "transparent"

    SystemUICommonApiClient {
        id: systemUICommonApiClient
        appName: "fileview"
        onActionCommand: {
            if (cmd == SystemUICommonApiClient.Show) {
                app_fileview.flags = Qt.FramelessWindowHint
                appMainBody.visible = false
                app_fileview.requestActivate()
                systemUICommonApiClient.askSystemUItohideOrShow(SystemUICommonApiClient.Hide)
            }
            if (cmd == SystemUICommonApiClient.Quit)
                Qt.quit()
        }
    }

    AppMainBody {
        anchors.fill: parent
        id: appMainBody
        visible: false
        Dock {}
    }

    Common {
        id: common
        m_appMainBody: appMainBody
        window: app_fileview
        Connections {
            target: systemUICommonApiClient
            function onAppAppPropertyChanged(iconX, iconY, iconWidth, iconHeight, iconPath, callType, currentPage)  {
                appMainBody.grabToImage(function(result) {
                    common.whenAppIsActive(iconX, iconY, iconWidth, iconHeight, iconPath, result.url, callType, currentPage)
                })
            }
        }
        onShowAppMainBody: {
            if (show) {
                appMainBody.visible = true
            }
        }
        onBackToSystemUi: {
            systemUICommonApiClient.askSystemUItohideOrShow(SystemUICommonApiClient.Show)
        }
        onAppStateImageChange: {
            systemUICommonApiClient.sendVariantToServer(SystemUICommonApiClient.Image, image)
        }
    }
}
