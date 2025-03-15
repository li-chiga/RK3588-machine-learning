/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @projectName   camera
* @brief         CameraLayout.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @link          www.openedv.com
* @date          2023-03-15
* @link          http://www.openedv.com/forum.php
*******************************************************************/
import QtQuick 2.0
import QtQuick.Controls 2.14
import QtGraphicalEffects 1.14
import AQuickPlugin 1.0

Item {
    id: cameraLayout
    property bool dobuleClickedFlag: false
    property bool dragYFlag: false
    property int displayPhotoHighlightMoveDuration: 0
    property real scaleFfactor: app_camera.width / 720
    ACamera {
        id: camera
        anchors.fill: parent
        visible: true
        path: appCurrtentDir + "/resource/images/"  // Where the album is stored
        onNoCameraAvailable: { // When there's no camera to do
        }
        Component.onCompleted: camera.startCamera() // init and start
        onImageSaved : {
            console.log("IMG has been saved in " + fileName)
            photoListModel.addPhoto(fileName)
        }
    }

    function setVisable(visible) {
        camera.visible = visible
    }

    onVisibleChanged: {
        delaytoStartAndStopCameraTimer.setTimeout(function() {setVisable(visible)}, 100)
        if (visible)
            delaytoStartAndStopCameraTimer.setTimeout(function() {camera.start(visible)}, 100)
        else
            camera.start(false)
        if (visible)
            background_control_timer.restart()
        else
            background_control_timer.stop()
    }

    Timer {
        id: delaytoStartAndStopCameraTimer
        function setTimeout(ft, delayTime) {
            delaytoStartAndStopCameraTimer.interval = delayTime;
            delaytoStartAndStopCameraTimer.repeat = false
            delaytoStartAndStopCameraTimer.triggered.connect(ft);
            delaytoStartAndStopCameraTimer.triggered.connect(function release () {
                delaytoStartAndStopCameraTimer.triggered.disconnect(ft)
                delaytoStartAndStopCameraTimer.triggered.disconnect(release)
            })
            delaytoStartAndStopCameraTimer.start()
        }
    }

    Timer {
        id: background_control_timer
        running: true
        repeat: true
        interval: 10000
        onTriggered: {
            if (topPannelRect.color == "#33000000") {
                topPannelRect.color = "black"
                bottomPanelRect.color = "black"
            } else {
                topPannelRect.color = "#33000000"
                bottomPanelRect.color = "#33000000"
            }
        }
    }

    Rectangle {
        id: topPannelRect
        height: scaleFfactor * 100
        color: "black"
        Behavior on color { PropertyAnimation { duration: 3000; easing.type: Easing.Linear } }
        width: parent.width

        Image {
            source: "qrc:/icons/flash_light_auto.png"
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: scaleFfactor * 25
            width: scaleFfactor * 64
            height: width
            opacity: 0.8
        }

        Image {
            source: "qrc:/icons/camera_live.png"
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: scaleFfactor * 25
            width: scaleFfactor * 64
            height: width
            opacity: 0.8
        }
    }

    Rectangle {
        id: bottomPanelRect
        height: scaleFfactor * 260
        width: parent.width
        Behavior on color { PropertyAnimation { duration: 3000; easing.type: Easing.Linear } }
        color: "black"
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        ModelSelect {
            anchors.top: parent.top
        }
        Row {
            anchors.top: parent.top
            anchors.topMargin: scaleFfactor * 60
            anchors.horizontalCenter:  parent.horizontalCenter
            spacing: scaleFfactor * 150
            Item {
                id: roundButton3
                anchors.verticalCenter: parent.verticalCenter
                width: scaleFfactor * 100
                height: width
            }

            Item {
                id: item1
                width: scaleFfactor * 150
                height: width
                anchors.verticalCenter:  parent.verticalCenter
                RoundButton {
                    id: roundButton1
                    anchors.centerIn: parent
                    width:  scaleFfactor * 140
                    height: width
                    background: Rectangle {
                        anchors.fill: parent
                        radius:  height / 2
                        border.color: "white"
                        border.width: scaleFfactor * 6
                        color: "transparent"
                        Rectangle {
                            width: roundButton1.pressed ? scaleFfactor * 110 : scaleFfactor * 120
                            height: roundButton1.pressed ? scaleFfactor * 110 : scaleFfactor * 120
                            Behavior on width { PropertyAnimation { duration: 100; easing.type: Easing.Linear } }
                            Behavior on height { PropertyAnimation { duration: 100; easing.type: Easing.Linear } }
                            color: "white"
                            radius: height / 2
                            anchors.centerIn: parent
                        }
                    }

                    onClicked: {
                        camera.takeImage()
                    }
                }
            }

            RoundButton {
                id: roundButton2
                anchors.verticalCenter: parent.verticalCenter
                width: scaleFfactor * 100
                height: width
                background: Rectangle {
                    anchors.fill: parent
                    radius: height / 2
                    opacity: 0.1
                }

                Image {
                    anchors.centerIn: parent
                    width: parent.width - scaleFfactor * 40
                    height: width
                    source: "qrc:/icons/switch.png"
                    opacity: roundButton2.pressed ? 0.8 : 1.0
                }
            }
        }
    }

    Rectangle {
        anchors.bottom: bottomPanelRect.top
        anchors.bottomMargin: scaleFfactor * 25
        anchors.horizontalCenter: parent.horizontalCenter
        width: scaleFfactor * 200
        height: scaleFfactor * 100
        radius: height / 2
        color: "#33000000"

        RadioButton {
            id: rabt1
            width: parent.width / 2
            height: parent.height
            anchors.left: parent.left
            checked: false
            indicator: Item { }
            background: Rectangle {
                anchors.centerIn: parent
                color: "#33000000"
                width: parent.checked ? parent.width - scaleFfactor * 10 : parent.width - scaleFfactor * 30
                height: parent.checked ? parent.width - scaleFfactor * 10 : parent.width - scaleFfactor * 30
                Behavior on width { PropertyAnimation { duration: 100; easing.type: Easing.Linear } }
                Behavior on height { PropertyAnimation { duration: 100; easing.type: Easing.Linear } }
                radius: height / 2
                Text {
                    text: rabt1.checked ? "0.5x" : "0.5"
                    color: rabt1.checked ? "#E3CF57" : "white"
                    font.pixelSize: rabt1.checked ? scaleFfactor * 25 : scaleFfactor * 20
                    anchors.centerIn: parent
                    Behavior on font.pixelSize { PropertyAnimation { duration: 100; easing.type: Easing.Linear } }
                }
            }
        }

        RadioButton {
            id: rabt2
            width: parent.width / 2
            height: parent.height
            checked: true
            anchors.right: parent.right
            indicator: Item { }
            background: Rectangle {
                anchors.centerIn: parent
                color: "#33000000"
                width: parent.checked ? parent.width - scaleFfactor * 10 : parent.width - scaleFfactor * 30
                height: parent.checked ? parent.width - scaleFfactor * 10 : parent.width - scaleFfactor * 30
                Behavior on width { PropertyAnimation { duration: 100; easing.type: Easing.Linear } }
                Behavior on height { PropertyAnimation { duration: 100; easing.type: Easing.Linear } }
                radius: height / 2
                Text {
                    text: rabt2.checked ? "1x" : "1"
                    color: rabt2.checked ? "#E3CF57" : "white"
                    font.pixelSize: rabt2.checked ? scaleFfactor * 25 : scaleFfactor * 20
                    anchors.centerIn: parent
                    Behavior on font.pixelSize { PropertyAnimation { duration: 100; easing.type: Easing.Linear } }
                }
            }
        }
    }

    Rectangle {
        id: imageBg
        anchors.fill: parent
        color: "black"
        visible: listView1.width > parent.width / 2
        opacity: 0.0
    }

    Connections {
        target: photoListModel
        function onCurrentIndexChanged() {
            listView1.currentIndex = photoListModel.currentIndex
            listView2.currentIndex = photoListModel.currentIndex
            dobuleClickedFlag = false
            dragYFlag = false
        }
    }

    Timer {
        id: delayTimer
        repeat: false
        interval: 100
        onTriggered: {
            imageBg.opacity = 1.0
        }
    }

    Timer {
        id: delayToDetectAction
        repeat: false
        running: false
        interval: 50
    }

    Timer {
        id: delayToEnableDoubleClickedTimer
        repeat: false
        running: false
        interval: 350
    }

    ListView {
        id: listView1
        height: width
        width: scaleFfactor * 100
        x: scaleFfactor * 35
        y: bottomPanelRect.y + (bottomPanelRect.height - scaleFfactor * 100) / 2 + scaleFfactor * 5
        orientation: ListView.Horizontal
        visible: false
        clip: true
        Behavior on width { PropertyAnimation { duration: 100; easing.type: Easing.Linear } }
        Behavior on height { PropertyAnimation { duration: 100; easing.type: Easing.Linear } }
        Behavior on x { PropertyAnimation { duration: 100; easing.type: Easing.Linear } }
        Behavior on y { PropertyAnimation { duration: 100; easing.type: Easing.Linear } }
        model: photoListModel
        snapMode: ListView.SnapOneItem
        highlightMoveDuration: displayPhotoHighlightMoveDuration
        onCurrentIndexChanged: {
            photoListModel.currentIndex = listView1.currentIndex
        }

        delegate: Item {
            id: itemParent
            width: listView1.width
            height: listView1.height
            Image {
                id: image
                width: parent.width
                height: parent.height
                fillMode: Image.PreserveAspectFit
                Behavior on scale { PropertyAnimation { duration: 350; easing.type: Easing.Linear } }
                source: path
                visible: true
                MouseArea {
                    id: mapDragArea
                    anchors.fill: image
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
                        delayToDetectAction.restart()
                    }
                    onPositionChanged: {
                        if (!delayToDetectAction.running && mapDragArea.pressed && dragYFlag) {
                            dragYFlag = false
                            //if (Math.abs(image.y) >= Math.abs(image.x)) {
                            var farY = mouseY - preadY
                            if (Math.abs(farY) > Math.abs(mouseX - preadX) + 5) {
                                if (farY < 0)
                                    return
                                drag.minimumY = -1000
                                drag.maximumY = 1000
                            }
                        }
                        if (drag.minimumY !== -1000)
                            return
                        topMenuRect.opacity = 0
                        if (image.y > 0 && drag.minimumY == -1000) {
                            var tmpWidth = imageWidth - Math.abs(image.y)
                            image.width =  tmpWidth > 500 ? tmpWidth : 500
                            var heigtFactor = image.width / imageWidth
                            imageBg.opacity = heigtFactor
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
                    onClicked: topMenuRect.opacity = !topMenuRect.opacity
                }
            }
        }
    }

    Image {
        id: capturePhoto
        source: photoListModel.currentIndex !== -1  && listView2.count !== 0 ? photoListModel.getcurrentPath() : ""
        visible: false
        x: scaleFfactor * 35
        y: bottomPanelRect.y + (bottomPanelRect.height - scaleFfactor * 100) / 2 + scaleFfactor * 5
        width: scaleFfactor * 100
        height: width
        fillMode: Image.PreserveAspectCrop
        Behavior on width { PropertyAnimation { duration: 100; easing.type: Easing.OutQuart } }
        Behavior on height { PropertyAnimation { duration: 100; easing.type: Easing.OutQuart } }
        Behavior on x { PropertyAnimation { duration: 100; easing.type: Easing.OutQuart } }
        Behavior on y { PropertyAnimation { duration: 100; easing.type: Easing.OutQuart } }
    }
    Rectangle {
        id: capturePhoto_mask
        anchors.fill: listView1
        radius: scaleFfactor * 10
        visible: false
    }

    function minSize() {
        listView1.width = capturePhoto.width
        listView1.height = capturePhoto.height
        listView1.x = capturePhoto.x
        listView1.y = capturePhoto.y
        topMenuRect.opacity = 0
    }

    function maxSize() {
        if (listView2.count === 0)
            return
        listView1.visible = true
        listView1.width = cameraLayout.width
        listView1.height = cameraLayout.height
        listView1.x = 0
        listView1.y = 0
        dobuleClickedFlag = false
        dragYFlag = false
        delayTimer.start()
    }

    OpacityMask {
        id: capturePhoto_opacitymask
        source: capturePhoto
        maskSource: capturePhoto_mask
        visible: listView1.width <= scaleFfactor * 100
        anchors.fill: capturePhoto
        MouseArea {
            anchors.fill: parent
            onClicked: {
                maxSize()
            }
        }
    }

    Rectangle {
        id: topMenuRect
        color: "white"
        anchors.top: parent.top
        height: scaleFfactor * 140
        opacity: 0
        Behavior on opacity { PropertyAnimation { duration: 100; easing.type: Easing.OutQuart } }
        width: parent.width
        Button {
            id: backBt
            width: scaleFfactor * 80
            height: width
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            background: Item {
                anchors.fill: parent
                Image {
                    width: scaleFfactor * 48
                    height: width
                    anchors.centerIn: parent
                    source: "qrc:/icons/back.png"
                }
            }
            onClicked: minSize()
        }
    }

    Rectangle {
        id: bottomMenuRect
        enabled: bottomMenuRect.opacity === 1.0
        color: "white"
        anchors.bottom: parent.bottom
        height: scaleFfactor *  230
        opacity: topMenuRect.opacity
        width: parent.width
        MouseArea {
            enabled: bottomMenuRect.opacity === 1.0
            anchors.fill: parent
        }

        ListView {
            id: listView2
            height: parent.height / 3
            width: parent.width
            anchors.top: parent.top
            anchors.topMargin: 2
            orientation: ListView.Horizontal
            clip: true
            visible: bottomMenuRect.opacity === 1.0
            model: photoListModel
            snapMode: ListView.SnapOneItem
            delegate:  Rectangle {
                width: photoListModel.currentIndex === index ?  height : height / 2 + 5
                height: listView2.height
                Image {
                    width: photoListModel.currentIndex === index ?  height : height / 2
                    height: listView2.height
                    fillMode: Image.PreserveAspectCrop
                    source: path
                    anchors.centerIn: parent
                    opacity: mouseArea2.pressed ? 0.8 : 1.0
                    Behavior on width { PropertyAnimation { duration: 100; easing.type: Easing.OutQuart } }
                }
                MouseArea {
                    id: mouseArea2
                    anchors.fill: parent
                    onClicked: {
                        photoListModel.currentIndex = index
                    }
                }
            }
        }

        Row {
            anchors.top: listView2.bottom
            anchors.topMargin: scaleFfactor * 25
            anchors.horizontalCenter: parent.horizontalCenter
            height: scaleFfactor * 80
            spacing: scaleFfactor *  120
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
    }

    DeletePage {
        visible: false
        id: deletePage
        onDeleteButtonClicked: {
            photoListModel.removeOne(listView1.currentIndex)
            if (listView2.count === 0) {
                minSize()
            }
        }
    }
}
