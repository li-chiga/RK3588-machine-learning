/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @brief         AppMainBody.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @date          2024-04-12
* @link          http://www.openedv.com/forum.php
*******************************************************************/
import QtQuick 2.12
Item {
    anchors.fill: parent
    Rectangle {
        anchors.fill: parent
        color: "white"
    }

    Text {
        anchors.centerIn: parent
        text: qsTr("此App未开发\n您可基于此页面\n添加App内容")
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 30
        color: "black"
        font.bold: true
    }
}
