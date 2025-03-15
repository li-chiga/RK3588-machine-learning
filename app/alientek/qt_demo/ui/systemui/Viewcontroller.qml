/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @brief         Viewcontroller.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @date          2024-04-18
* @link          http://www.openedv.com/forum.php
*******************************************************************/
import QtQuick 2.12
import QtGraphicalEffects 1.12
import QtQuick.Controls 2.15
import com.alientek.qmlcomponents 1.0
Item {
    property int appCounts: listView.count
    signal goBackToDesktop(bool normal)
    signal noAppIsRunning()
    property int removeIndex: -1
    Connections {
        target: systemUICommonApiServer
        function onAppStateImageChanged(appName, image) {
            console.log("reviceve Image from client")
            appListModel.addApp(image, appName)
        }
    }
    AppListModel {
        id: appListModel
        onAppModelUpdate: {
            listView.currentIndex = listView.count / 2
        }
    }

    Timer {
        id: delayToRemovItemTimer
        repeat: false
        running: false
        interval: 200
        onTriggered: {
            appListModel.removeOne(removeIndex)
        }
    }
    MouseArea {
        anchors.fill: parent
        onClicked: goBackToDesktop(true)
    }
    onRemoveIndexChanged: {
    }

    ListView {
        id: listView
        model: appListModel
        visible: true
        width: desktop.width / 1.5
        height: desktop.height / 1.5
        displayMarginBeginning: 1000
        displayMarginEnd: 1000
        anchors.centerIn: parent
        orientation: Qt.Horizontal
        spacing: 30
        snapMode: ListView.SnapToItem
        onCountChanged: {
            if (count == 0)
                goBackToDesktop(true)
        }

        delegate: Item {
            id: delegateItem
            width: listView.width
            height: listView.height
            ListView.onRemove: SequentialAnimation {
                PropertyAction { target: delegateItem; property: "ListView.delayRemove"; value: true }
                NumberAnimation { target: delegateItem; property: "width"; to: 0; duration: 200; easing.type: Easing.Linear }
                PropertyAction { target: delegateItem; property: "ListView.delayRemove"; value: false }
            }
            Row {
                anchors.bottom: appStateImage_mask_opacityMask.top
                anchors.bottomMargin: 15 * scaleFfactor
                anchors.left: appStateImage_mask_opacityMask.left
                anchors.leftMargin: 50 * scaleFfactor
                spacing: 15
                Image {
                    width: 60 * scaleFfactor
                    height: width
                    source: appName == "" ? "" : "file://" + appCurrtentDir + "/src/appicons/" + appName
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: qsTr(appName)
                    font.pixelSize: 30 * scaleFfactor
                    color: "white"
                }
            }
            Behavior on y { PropertyAnimation { duration: 200; easing.type: Easing.Linear } }
            Item {
                anchors.fill: parent
                Connections {
                    target: mouseArea
                    function onClicked() {
                        callApp(appName, mapToGlobal(appStateImage.x, appStateImage.y).x, mapToGlobal(appStateImage.x, appStateImage.y).y, appStateImage, "", 1, main_swipeView.currentIndex)
                        goBackToDesktop(false)
                    }
                }
                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    drag.target: delegateItem
                    drag.maximumX: delegateItem.x
                    drag.minimumX: delegateItem.x
                    onReleased: function(mouse) {
                        if (delegateItem.y < -200) {
                            delegateItem.y = -desktop.height
                            removeIndex = index
                            systemUICommonApiServer.quitNotification(appName)
                            delayToRemovItemTimer.start()
                        } else {
                            delegateItem.y = 0
                        }
                    }
                }
            }

            AppStateImage {
                id: appStateImage
                width: desktop.width / 1.5
                height: desktop.height /1.5
                anchors.centerIn: parent
                source: image
                visible: false
            }

            Rectangle {
                id: appStateImage_mask
                anchors.fill: appStateImage
                visible: false
                radius: 55 * scaleFfactor
            }

            OpacityMask {
                id: appStateImage_mask_opacityMask
                source: appStateImage
                maskSource: appStateImage_mask
                anchors.fill: appStateImage
                visible: true
            }
        }
    }
}
