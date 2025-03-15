/******************************************************************
Copyright 2022 Guangzhou ALIENTEK Electronincs Co.,Ltd. All rights reserved
Copyright © Deng Zhimao Co., Ltd. 1990-2030. All rights reserved.
* @projectName   qwifi
* @brief         ActionSheet.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @date          2022-12-06
* @link          http://www.openedv.com/forum.php
*******************************************************************/
import QtQuick 2.0

Rectangle {
    id: sheet
    width: parent.width
    height: parent.height
    color: "#22101010"
    MouseArea { anchors.fill: parent }
    x: 0
    y: height
    Behavior on y { PropertyAnimation { duration: 250; easing.type: Easing.OutQuad } }

    MouseArea {
        anchors.fill: parent
        drag.target: parent
        drag.minimumX: 0
        drag.minimumY: 0
        drag.maximumX: 0
        drag.maximumY: parent.height
        property int dragY
        onPressed: {
            dragY = parent.y
        }
        onReleased: {
            if (parent.y - dragY >= 100)
                sheet.close()
            else
                sheet.open()
        }
    }

    function open() {
        actionSheet.visible = true
        app_qwifi.inputPanelReadyOpen()
        sheet.y = 0
        wifi.setModal(true)
    }

    function close() {
        app_qwifi.inputPanelReadyClose()
        sheet.y = height
        wifi.setModal(false)
    }

    PasswordPanel {
    }
}
