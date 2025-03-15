/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 1990-2030. All rights reserved.
* @projectName   photoview
* @brief         DisplayPhoto.qml
* @author        Deng Zhimao
* @email         1252699831@qq.com
* @date          2020-07-16
*******************************************************************/
import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtQuick.Controls 2.5
import QtQml 2.12

Item {
    id: displayView
    property bool dobuleClickedFlag: false
    property bool dragYFlag: false
    Connections {
        target: photoListModel
        function onCurrentIndexChanged() {
            dobuleClickedFlag = false
            dragYFlag = false
            listView1.currentIndex = photoListModel.currentIndex
        }
    }

    Timer {
        id: delayToEnableDoubleClickedTimer
        repeat: false
        running: false
        interval: 150
    }

    Timer {
        id: delayToDetectAction
        repeat: false
        running: false
        interval: 50
    }

    Rectangle {
        anchors.centerIn: parent
        width: parent.width
        height: app_photoview.height
        id: coverflowBg
        color: "white"
    }

    function minSize() {
        displayView.visible = false
        coverflowBg.opacity = 1.0
        photoPropertyChanged()
    }

    ListView {
        id: listView1
        height: photoViewLayout.height
        width: photoViewLayout.width
        anchors.centerIn: parent
        orientation: ListView.Horizontal
        visible: true
        clip: true
        model: photoListModel
        snapMode: ListView.SnapOneItem
        highlightMoveDuration: displayPhotoHighlightMoveDuration
        onCurrentIndexChanged: {
            if (Qt.isQtObject(photoListModel))
                photoListModel.currentIndex = listView1.currentIndex
        }
        onCountChanged: {
        }

        delegate: Item {
            id: itemParent
            width: listView1.width
            height: listView1.height
            Image {
                id: image
                width: parent.width
                height: parent.height
                Behavior on scale { PropertyAnimation { duration: 150; easing.type: Easing.Linear } }
                source: path
                fillMode: Image.PreserveAspectFit
                visible: true
                MouseArea {
                    id: mapDragArea
                    width: listView1.width
                    height: listView1.height
                    anchors.centerIn: parent
                    property int imageWidth
                    property int imageHeight
                    property real preadY
                    property real preadX
                    drag.target: image
                    onReleased: {
                        if (Math.abs(image.x) <= 100 || drag.minimumY === -1000) {
                            if (image.width < imageWidth) {
                                image.width = imageWidth
                                image.height = imageHeight
                                minSize()
                            }
                            image.y = 0
                            image.x = 0
                            return
                        }

                        if (image.x > 0) {
                            if (photoListModel.currentIndex !== 0)
                                photoListModel.currentIndex--
                        } else {
                            if (photoListModel.currentIndex !== photoListModel.count() - 1)
                                photoListModel.currentIndex++
                        }
                        image.y = 0
                        image.x = 0
                        image.width = imageWidth
                        image.height = imageHeight
                    }
                    onPressed: {
                        imageWidth = image.width
                        imageHeight = image.height
                        dragYFlag = true
                        drag.minimumY = 0
                        drag.maximumY = 0
                        preadY = mouseY
                        preadX = mouseX
                        displayPhotoHighlightMoveDuration = 300
                        delayToDetectAction.start()
                    }
                    onPositionChanged: {
                        if (!delayToDetectAction.running && mapDragArea.pressed && dragYFlag) {
                            dragYFlag = false
                            //if (Math.abs(image.y) >= Math.abs(image.x)) {
                            var farY = mouseY - preadY
                            if (Math.abs(farY) > Math.abs(mouseX - preadX)) {
                                if (farY < 0)
                                    return
                                drag.minimumY = -1000
                                drag.maximumY = 1000
                            }
                        }
                        if (drag.minimumY !== -1000)
                            return
                        if (image.y > 0 && drag.minimumY == -1000) {
                            var tmpWidth = imageWidth - Math.abs(image.y)
                            image.width =  tmpWidth > 500 ? tmpWidth : 500
                            var heigtFactor = image.width / imageWidth
                            coverflowBg.opacity = heigtFactor
                            image.height = imageHeight * heigtFactor
                        }  else {
                            image.width = imageWidth
                            image.height = imageHeight
                        }

                    }
                    onWheel: {
                        var datla = wheel.angleDelta.y / 120
                        if (datla > 0){
                            image.scale = image.scale / 0.9
                        } else {
                            image.scale = image.scale * 0.9
                        }
                    }
                    onDoubleClicked:  {
                        if (delayToEnableDoubleClickedTimer.running)
                            return
                        delayToEnableDoubleClickedTimer.start()
                        if (!dobuleClickedFlag)
                            image.scale = image.scale * 1.5
                        else
                            image.scale = image.scale / 1.5
                        dobuleClickedFlag = !dobuleClickedFlag
                    }
                }
            }
        }
    }

    Row {
        anchors.bottom: parent.bottom
        anchors.bottomMargin: scaleFfactor * 80
        anchors.horizontalCenter: parent.horizontalCenter
        height: scaleFfactor * 80
        spacing:  scaleFfactor * 120
        Button {
            id: shareBt
            width: parent.height
            height: width
            background: Image {
                width: scaleFfactor * 48
                height: width
                anchors.centerIn: parent
                source: "qrc:/icons/share.png"
            }
        }

        Button {
            id: favariteBt
            width: parent.height
            height: width
            background: Image {
                width: scaleFfactor * 48
                height: width
                anchors.centerIn: parent
                source: "qrc:/icons/favorite.png"
            }
        }

        Button {
            id: infoBt
            width: parent.height
            height: width
            background: Image {
                width: scaleFfactor * 48
                height: width
                anchors.centerIn: parent
                source: "qrc:/icons/info.png"
            }
        }

        Button {
            id: deleteBt
            width: parent.height
            height: width
            opacity: deleteBt.pressed ? 0.8 : 1.0
            background: Image {
                width: scaleFfactor * 48
                height: width
                anchors.centerIn: parent
                source: "qrc:/icons/delete.png"
            }
            onClicked: {
                deletePage.visible = true
            }
        }
    }

    DeletePage {
        visible: false
        id: deletePage
    }

    Connections {
        target: photoViewLayout
        function onDeleteButtonClicked() {
            photoListModel.removeOne(listView1.currentIndex)
            if (listView1.count === 0) {
                minSize()
            }
        }
    }
}
