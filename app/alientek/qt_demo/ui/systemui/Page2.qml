/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @brief         Page2.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @date          2024-04-07
* @link          http://www.openedv.com/forum.php
*******************************************************************/
import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.12
import com.alientek.qmlcomponents 1.0
Item {
    id: page2
    ApkListModel {
        id: apkListModel
        Component.onCompleted: apkListModel.add(appCurrtentDir + "/src/"+ hostName +"/apk2.cfg")
    }

    ColumnLayout {
        width: control_item.width
        height: control_item.height - control_item.width / 14.4
        anchors.top: parent.top
        anchors.topMargin: control_item.width / 28.8
        GridView {
            Layout.alignment: Qt.AlignHCenter
            Layout.fillHeight: true
            width:  control_item.width - control_item.width / 13
            height: control_item.width / 4 * 5  // three column
            id: item_gridView
            visible: true
            interactive: false
            clip: false
            snapMode: ListView.SnapOneItem
            cellWidth: item_gridView.width / 4
            cellHeight: cellWidth * 1.2
            model: apkListModel
            delegate: item_gridView_delegate
        }

    }

    Component {
        id: item_gridView_delegate
        Button {
            id: appButton
            width: item_gridView.cellWidth
            height: item_gridView.cellHeight
            enabled: installed
            onClicked: {
                callApp(programName, mapToGlobal(appIcon.x, appIcon.y).x, mapToGlobal(appIcon.x, appIcon.y).y, appIcon, apkIconPath, 0, main_swipeView.currentIndex)
            }

            background: Image {
                id: appIcon
                anchors.centerIn: parent
                width: desktop.width / 6.5
                height: width
                source: apkIconPath
                visible: systemUICommonApiServer.currtentLauchAppName !== programName
            }

            Image {
                id: appIcon2
                anchors.centerIn: parent
                width: appIcon.width
                height: width
                source: apkIconPath
                visible: systemUICommonApiServer.firstTimeStart
            }

            Text {
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                text: apkName
                color: "white"
                font.pixelSize: desktop.width / 720 * 20
                font.bold: true
            }

            Colorize {
                id: colorize1
                anchors.fill: appIcon2
                source: appIcon2
                saturation: 0.0
                lightness: -1.0
                opacity: 0.2
                cached: true
                visible: appButton.pressed
            }
        }
    }
}
