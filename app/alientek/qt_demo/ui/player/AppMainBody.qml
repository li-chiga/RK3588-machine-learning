/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @brief         AppMainBody.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @date          2024-04-12
* @link          http://www.openedv.com/forum.php
*******************************************************************/
import QtQuick 2.12
import AQuickPlugin 1.0
Item {
    anchors.fill: parent
    property int control_duration: 0
    property QtObject mediaModel
    Rectangle {
        anchors.fill: parent
        color: "black"
    }

    onVisibleChanged:  {
        if (visible)
            control_duration = 0
    }

    Loader {
        id: loader
        anchors.fill: parent
        asynchronous: true
        Component.onCompleted:  {
            loader.sourceComponent = component
        }
    }

    Component {
        id: component
        Item {
            anchors.fill: parent
            AMediaList {
                id: m_mediaModel
                onCurrentIndexChanged: {
                    //  mediaPlayer.source = getcurrentPath()
                }
                Component.onCompleted: m_mediaModel.currentIndex = -1
            }

            Component.onCompleted: {
                m_mediaModel.add(appCurrtentDir +  "/resource/media/movies")
                mediaModel = m_mediaModel
            }
        }
    }

    PlayerLayout {
        anchors.fill: parent
    }
}
