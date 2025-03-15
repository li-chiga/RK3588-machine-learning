/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @projectName   settings
* @brief         BackButton.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @link          www.openedv.com
* @date          2023-02-13
*******************************************************************/
import QtQuick 2.0
import QtQuick.Controls 2.14

Item {
    anchors.fill: parent
    property string backText: ""
    signal backButtonClick()
    property real textOpacityDuration: 0
    Button {
        anchors.top: parent.top
        anchors.topMargin: height
        anchors.left: parent.left
        anchors.leftMargin: height / 3
        height: scaleFfactor * 60
        width: backtext.contentWidth * 2
        background: Item {}

        Image {
            id: image
            source: "qrc:/icons/back.png"
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            width: settingsLayout.width / 20
            height: width
        }

        Text {
            id: backtext
            text: backText
            font.pixelSize: scaleFfactor * 30
            font.bold: true
            color: "#007aff"
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: image.right
        }

        onClicked: {
            //settings_swipeView.currentIndex = 0
            backButtonClick()
        }
    }
}
