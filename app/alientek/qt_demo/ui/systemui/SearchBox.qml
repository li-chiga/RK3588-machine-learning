/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @brief         SearchBox.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @date          2024-04-13
* @link          http://www.openedv.com/forum.php
*******************************************************************/
import QtQuick 2.12
import QtGraphicalEffects 1.12
import QtQuick.Controls 2.12
Item {
    anchors.fill: parent

    Timer {
        id: timer_Indicator
        repeat: false
        running: false
        interval: 2000
        onTriggered: {
            search.opacity = 1.0
            indicator.opacity = 0.0
        }
    }

    Rectangle {
        radius: height / 2
        width: scaleFfactor * 100
        height: scaleFfactor * 50
        opacity: 0.3
        color: "white"
        anchors.centerIn: indicator
    }

    Item {
        id: search
        anchors.fill: indicator
        Image {
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: -scaleFfactor * 10
            source: "file://" + appCurrtentDir + "/src/iphone/icons/search.png"
            width: scaleFfactor * 20
            height: width
        }
        Text {
            id: search_text
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: -scaleFfactor * 10
            text: qsTr("搜索")
            color: "white"
            font.pixelSize: scaleFfactor * 20
            font.bold: true
        }
        opacity: 1.0
        Behavior on opacity { PropertyAnimation { duration: 500; easing.type: Easing.Linear } }
    }

    PageIndicator {
        id: indicator
        opacity: 0.0
        count: main_swipeView.count
        visible: true
        currentIndex: main_swipeView.currentIndex
        Behavior on opacity { PropertyAnimation { duration: 1000; easing.type: Easing.Linear } }
        onCurrentIndexChanged: {
            opacity = 1.0
            timer_Indicator.stop()
            search.opacity = 0.0
            timer_Indicator.start()
        }
        anchors.bottom: parent.bottom
        anchors.bottomMargin: scaleFfactor * 210
        anchors.horizontalCenter: parent.horizontalCenter
        delegate: indicator_delegate
        Component {
            id: indicator_delegate
            Rectangle {
                width: scaleFfactor * 12
                height: scaleFfactor * 12
                color: main_swipeView.currentIndex !== index  ? "gray" : "#dddddd"
                radius: scaleFfactor * 6
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
}
