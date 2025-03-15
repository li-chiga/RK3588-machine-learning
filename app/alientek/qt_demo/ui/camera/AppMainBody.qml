/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @brief         AppMainBody.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @date          2024-04-12
* @link          http://www.openedv.com/forum.php
*******************************************************************/
import QtQuick 2.12
import QtQuick.Controls 2.5
import AQuickPlugin 1.0
Item {
    anchors.fill: parent
    property QtObject photoListModel
    Rectangle {
        anchors.fill: parent
        color: "black"
    }

    Loader {
        id: loader
        anchors.fill: parent
        asynchronous: true
        Component.onCompleted:  loader.sourceComponent = component
    }

    Component {
        id: component
        Item {
            anchors.fill: parent
            PhotoListModel {
                id: m_photoListModel
                Component.onCompleted:  {
                    m_photoListModel.add(appCurrtentDir + "/resource/images/");
                    photoListModel = m_photoListModel
                }
            }
        }
    }

    CameraLayout {
        anchors.fill: parent
    }
}
