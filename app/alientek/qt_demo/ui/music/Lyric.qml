/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @projectName   desktop
* @brief         Lyric.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @link          www.openedv.com
* @date          2021-09-13
*******************************************************************/

import QtQuick 2.0
import QtQuick.Controls 2.5
import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import QtQuick.Dialogs 1.1
import QtMultimedia 5.0
import QtQuick 2.4
import com.alientek.qmlcomponents 1.0

Item {
    id: lyric_item
    property int currentIndex: -1
    signal lyricClicked()
    onCurrentIndexChanged: {
        music_lyric.currentIndex = currentIndex
    }
    ListView {
        anchors.top: parent.top
        anchors.topMargin: scaleFfactor * 50
        anchors.bottom: parent.bottom
        anchors.bottomMargin: scaleFfactor * 50
        width: parent.width
        id: music_lyric
        spacing: scaleFfactor * 10
        highlightRangeMode: ListView.StrictlyEnforceRange

        preferredHighlightBegin: (parent.height - 100) / 2
        preferredHighlightEnd: (parent.height - 100) / 2 + 1
        highlight: Rectangle {
            color: Qt.rgba(0, 0, 0, 0)
            Behavior on y {
                SmoothedAnimation {
                    duration: 300
                }
            }
        }
        model: music_lyricModel
        delegate: Rectangle {
            width: lyric_item.width
            height: scaleFfactor * 40
            color: Qt.rgba(0,0,0,0)
            Text {
                anchors.centerIn: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: "   " + textLine
                color: parent.ListView.isCurrentItem ? "white" : "#eedddddd"
                font.pixelSize: parent.ListView.isCurrentItem ? scaleFfactor * 35 : scaleFfactor * 30
                Behavior on font.pixelSize { PropertyAnimation { duration: 200; easing.type: Easing.Linear } }
                font.bold: parent.ListView.isCurrentItem
                font.family: "Montserrat Light"
            }
            MouseArea {
                anchors.fill: parent
                onClicked: lyricClicked()
            }
        }
    }
}
