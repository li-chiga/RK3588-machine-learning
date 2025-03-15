/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @projectName   music
* @brief         AlbumArt.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @link          www.openedv.com
* @date          2023-02-28
*******************************************************************/
import QtQuick 2.0
import QtGraphicalEffects 1.14
import QtQuick 2.14
import QtQuick.Controls 2.14
import QtMultimedia 5.0
import QtGraphicalEffects 1.12
import com.alientek.qmlcomponents 1.0

Item {
    property bool progress_pressed:  false
    property int progress_maximumValue: 0
    property int progress_value: 0
    property int music_loopMode: 2
    property bool centerShowTextTitle: true
    anchors.fill: parent
    clip: true

    function currentMusicTime(time){
        if (!app_music.active && !appActive) // fix a bug ?
            return ""
        var sec = Math.floor(time / 1000);
        var hours = Math.floor(sec / 3600);
        var minutes = Math.floor((sec - hours * 3600) / 60);
        var seconds = sec - hours * 3600 - minutes * 60;
        var hh, mm, ss;
        if(hours.toString().length < 2)
            hh = "0" + hours.toString();
        else
            hh = hours.toString();
        if(minutes.toString().length < 2)
            mm="0" + minutes.toString();
        else
            mm = minutes.toString();
        if(seconds.toString().length < 2)
            ss = "0" + seconds.toString();
        else
            ss = seconds.toString();
        return /*hh+":"*/ + mm + ":" + ss
    }

    onProgress_maximumValueChanged:  {
        progress_control.to = progress_maximumValue
    }

    onProgress_valueChanged: {
        if (app_music.active && appActive) // fix a bug?
            progress_control.value = progress_value
    }

    AudioSpectrumAnalyzer {
        id: audioSpectrumAnalyzer
        onBarValueChanged: {
            fastBlur.radius = 80 + 40 * value
            fastBlur.scale = 1 + 0.1 * value
            //console.log(value)
        }
    }

    Connections {
        target: musicPlayer
        function onSourceChanged()  {
            audioSpectrumAnalyzer.reset()
        }
    }

    Timer{
        id: myTimer
        running: true
        interval: 2000
        repeat: false
        onTriggered: {
            audioSpectrumAnalyzer.setMediaPlayer(myplayer)
            // releaseResources
            myTimer.destroy()
        }
    }

    Image {
        id: artBg
        visible: false
        fillMode: Image.PreserveAspectCrop
        anchors.fill: parent
        source: musicPlayer.hasAudio ?
                    "file:///" + appCurrtentDir + "/resource/artist/" + playList.musicName +".jpg" : "qrc:/images/albumart_bg.jpg"
        Rectangle {
            opacity: 0.3
            anchors.fill: parent
            color: "black"
            /*gradient: Gradient {
                GradientStop { position: 0.0; color: "black" }
                GradientStop { position: 0.2; color: "black" }
                GradientStop { position: 0.5; color: "transparent" }
                GradientStop { position: 0.8; color: "black" }
                GradientStop { position: 1.0; color: "black" }
            }*/
        }
        Connections {
            target: playList
            function onMusicNameChanged() {
                artBg.source = playList.musicName ?
                            "file:///" + appCurrtentDir + "/resource/artist/" + playList.musicName +".jpg" : "qrc:/images/albumart_bg.jpg"
            }
        }

        onSourceChanged: {
            if (!music_playlistModel.checkTheAlbumImageIsExists(artBg.source))
                artBg.source = "qrc:/images/albumart_bg.jpg"
        }

        onStatusChanged: {
            if (artBg.status === Image.Ready) {
                imageAnalyzer.analyzeImage(artBg.source);
                colorize.hue = imageAnalyzer.dominantHue
                //console.log("Dominant hue: " + imageAnalyzer.dominantHue);
            }
        }
    }

    FastBlur {
        id: fastBlur
        anchors.fill: artBg
        source: artBg
        radius: 120
    }

    Connections {
        target: music_playlistModel
        function onCurrentIndexChanged() {
            cd_outside.x = parent.width / 5 + art_album.width / 4
            art_album.x =  parent.width / 5 + art_album.width / 4
            delayToshowAnimationTimer.restart()
        }
    }

    Timer {
        id: delayToshowAnimationTimer
        repeat: false
        running: app_music.active && appActive
        interval: 250
        onTriggered:  {
            cd_outside.x = parent.width / 5 + art_album.width / 2
            art_album.x =  parent.width / 5
        }
    }

    ImageAnalyzer {
        id: imageAnalyzer
    }

    /* 注释: CD外边缘 */
    Image {
        id: cd_outside
        width: art_album.width
        height: art_album.height
        anchors.verticalCenter: art_album.verticalCenter
        //x:  musicPlayer.playbackState === Audio.PlayingState ? parent.width / 5 + art_album.width / 2 : parent.width / 5 + art_album.width / 4
        x:   parent.width / 5 + art_album.width / 2
        Behavior on x { PropertyAnimation { duration: 250; easing.type: Easing.Linear } }
        source: "qrc:/images/cd_outside.png"

        Colorize {
            id: colorize
            anchors.fill: cd_outside
            source: cd_outside
            saturation: 0.5
            lightness: 0 // < 0 bug?
            opacity: 0.8
            cached: true
        }

        /* 注释: CD */
        Image {
            id: cd_inside
            width: cd_outside.width / 1.8
            height: cd_outside.height / 1.8
            anchors.centerIn: cd_outside
            source: artBg.source
            visible: false
        }

        Image {
            id: cd_inside_mask
            visible: false
            width: cd_inside.width
            height: cd_inside.height
            source: "qrc:/images/cd_inside_mask.png"
        }

        OpacityMask {
            id: cd_inside_mask_opacity
            source: cd_inside
            anchors.fill: cd_inside
            maskSource: cd_inside_mask
        }
    }

    /* 注释: 专辑封面 */
    Image {
        id: art_album
        y: parent.height / 5
        //x:  musicPlayer.playbackState === Audio.PlayingState ? parent.width / 5 : parent.width / 5 + art_album.width / 4
        x:  parent.width / 5
        Behavior on x { PropertyAnimation { duration: 250; easing.type: Easing.Linear } }
        width: parent.width / 2.5
        height: width
        source: artBg.source
        visible: false
    }

    DropShadow {
        anchors.fill: art_album
        horizontalOffset: 3
        radius: 8.0
        samples: 16
        color: "#dd000000"
        source: art_album_mask
        visible: art_album_mask_opacityMask.visible
    }

    Image {
        id: art_album_mask
        visible: false
        width: art_album.width
        height: art_album.height
        source: "qrc:/images/art_album_mask.png"
    }

    OpacityMask {
        id: art_album_mask_opacityMask
        source: art_album
        anchors.fill: art_album
        maskSource: art_album_mask
        MouseArea {
            anchors.fill: parent
            onClicked:{
                art_album_mask_opacityMask.visible = !art_album_mask_opacityMask.visible
                cd_outside.visible = !cd_outside.visible
                centerShowTextTitle = !centerShowTextTitle
            }
        }
    }

    RotationAnimator {
        id: cd_outside_rotationAnimator
        target: cd_outside
        from: 0
        to: 360
        duration: 50000
        loops: Animation.Infinite
        running: musicPlayer.playbackState === Audio.PlayingState && app_music.active && appActive
        onRunningChanged: {
            if (running === false) {
                from = cd_outside.rotation
                to = from + 360
            }
        }
        onStopped: {
            if (musicPlayer.playbackState === Audio.StoppedState)
                cd_outside.rotation = 0
        }
    }

    Lyric {
        id: lyric
        width: parent.width
        height: centerShowTextTitle ? parent.height / 6 : parent.height / 3
        anchors.centerIn: parent
        currentIndex: lyric_CurrtentIndex
        onLyricClicked: {
            art_album_mask_opacityMask.visible = !art_album_mask_opacityMask.visible
            cd_outside.visible = !cd_outside.visible
            centerShowTextTitle = !centerShowTextTitle
        }
    }

    Text{
        id: playPanel_play_left_time
        anchors.right: progress_control.left
        anchors.rightMargin: scaleFfactor * 5
        visible: true
        anchors.verticalCenter: progress_control.verticalCenter
        text: currentMusicTime(progress_value)
        color: "#DCDCDC"
        font.pixelSize: scaleFfactor * 20
    }

    Text{
        id: playPanel_play_right_time
        anchors.left: progress_control.right
        anchors.leftMargin: scaleFfactor * 5
        visible: true
        anchors.verticalCenter: progress_control.verticalCenter
        text: currentMusicTime(progress_maximumValue)
        color: "#DCDCDC"
        font.pixelSize: scaleFfactor * 20
    }

    Slider {
        id: progress_control
        anchors.bottom: parent.bottom
        anchors.bottomMargin: scaleFfactor * 250
        width: parent.width / 1.5
        anchors.horizontalCenter: parent.horizontalCenter
        height: scaleFfactor * 80
        stepSize: 100
        property bool handled: false
        from: 0
        live: false
        to: 1000
        value: 0
        onPressedChanged: {
            handled = true
            progress_pressed = progress_control.pressed
            //progress_control.enabled = !progress_control.pressed
        }

        onValueChanged: {
            if (handled && musicPlayer.seekable) {
                music_lyricModel.findIndex(value)
                musicPlayer.seek(value)
                musicPlayer.play()
                handled = false
            } else {
                music_lyricModel.getIndex(value)
            }
        }
        background: Rectangle {
            x: progress_control.leftPadding
            y: progress_control.topPadding + progress_control.availableHeight / 2 - height / 2
            implicitWidth: scaleFfactor * 200
            implicitHeight: scaleFfactor * 8
            width: progress_control.availableWidth
            height: scaleFfactor * 3
            radius: height / 2
            color: "#55DCDCDC"

            Rectangle {
                width: progress_control.visualPosition * parent.width
                height: parent.height
                color: "white"
                radius: scaleFfactor * 4
            }
        }

        handle: Rectangle {
            x: progress_control.leftPadding + progress_control.visualPosition * (progress_control.availableWidth - width)
            y: progress_control.topPadding + progress_control.availableHeight / 2 - height / 2
            implicitWidth: scaleFfactor * 30
            implicitHeight: scaleFfactor * 30
            color: "transparent"
            Rectangle {
                anchors.centerIn: parent
                width: parent.width
                height: parent.height
                color: "white"
                radius: height / 2
            }
        }
    }

    Text {
        id: text_Title
        width: progress_control.width
        anchors.bottom: centerShowTextTitle ? progress_control.top : art_album_mask_opacityMask.top
        anchors.bottomMargin: centerShowTextTitle ? scaleFfactor * 80 : scaleFfactor * 20
        anchors.left: centerShowTextTitle ? playPanel_play_left_time.left : undefined
        anchors.horizontalCenter: parent.horizontalCenter
        horizontalAlignment: !centerShowTextTitle ? Text.AlignHCenter : Text.AlignLeft
        text: musicPlayer.status === Audio.Buffered ? music_playlistModel.getcurrentTitle(): ""
        elide: Text.ElideRight
        font.pixelSize: scaleFfactor * 45
        font.bold: true
        color: "white"
    }

    Text {
        id: text_author
        width: progress_control.width
        anchors.top: text_Title.bottom
        anchors.topMargin: scaleFfactor * 25
        anchors.left: centerShowTextTitle ? playPanel_play_left_time.left : undefined
        anchors.horizontalCenter: text_Title.horizontalCenter
        horizontalAlignment: text_Title.horizontalAlignment
        text: musicPlayer.status === Audio.Buffered ? music_playlistModel.getcurrentAuthor() : ""
        elide: Text.ElideRight
        font.pixelSize: scaleFfactor * 25
        color: "#DCDCDC"
    }

    Button {
        id: btn_play
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: progress_control.bottom
        anchors.topMargin: scaleFfactor * 40
        width: scaleFfactor * 120
        height: scaleFfactor * 120
        background: Rectangle {
            anchors.fill: parent
            color: "#55808080"
            radius: height / 2
            Image {
                source: musicPlayer.playbackState === Audio.PlayingState ? "qrc:/icons/btn_style1/btn_pause.png" : "qrc:/icons/btn_style1/btn_play.png"
                width: parent.width / 2
                height: width
                anchors.centerIn: parent
            }
        }
        onClicked: playBtnSignal()
    }

    Button {
        id: btn_next
        anchors.left: btn_play.right
        anchors.leftMargin: scaleFfactor * 50
        anchors.verticalCenter: btn_play.verticalCenter
        width: scaleFfactor * 64
        height: width
        background: Item {
            anchors.fill: parent
            Image {
                source: "qrc:/icons/btn_style1/btn_next.png"
                anchors.fill: parent
            }
            opacity: btn_next.pressed ? 1.0 : 0.5
        }
        onClicked: nextBtnSignal()
    }


    Button {
        id: btn_previous
        anchors.right: btn_play.left
        anchors.rightMargin: scaleFfactor * 50
        anchors.verticalCenter: btn_play.verticalCenter
        width: scaleFfactor * 64
        height: width
        background: Item {
            anchors.fill: parent
            Image {
                source: "qrc:/icons/btn_style1/btn_previous.png"
                anchors.fill: parent
            }
            opacity: btn_previous.pressed ? 1.0 : 0.5
        }
        onClicked: previousBtnSignal()
    }

    Button {
        id: btn_playList
        anchors.left: btn_next.right
        anchors.leftMargin: scaleFfactor * 50
        anchors.verticalCenter: btn_play.verticalCenter
        width: scaleFfactor * 64
        height: width
        background: Item {
            anchors.fill: parent
            Image {
                source: "qrc:/icons/btn_style1/btn_playlist.png"
                anchors.fill: parent
            }
            opacity: btn_playList.pressed ? 1.0 : 0.5
        }
        onClicked: music_playlist_dawer_bottom.open()
    }

    Button {
        id: btn_down
        anchors.leftMargin: scaleFfactor * 25
        anchors.left: parent.left
        anchors.topMargin: scaleFfactor * 60
        anchors.top: parent.top
        width: scaleFfactor * 120
        height: width
        background: Item {
            anchors.fill: parent
            Image {
                anchors.centerIn: parent
                source: "qrc:/icons/btn_style1/btn_down.png"
            }
        }
        opacity: btn_down.pressed ? 0.5 : 0.8
        onClicked: music_cd_dawer_bottom.close()
    }

    Button {
        id: btn_loopMode
        height: scaleFfactor * 64
        width: height
        anchors.right: btn_previous.left
        anchors.rightMargin: scaleFfactor * 50
        anchors.verticalCenter: btn_play.verticalCenter
        property int loopMode: 2
        onClicked: {
            loopMode++
            if (loopMode >= 4)
                loopMode = 0
            music_loopMode = loopMode
        }
        opacity: btn_loopMode.pressed ? 1.0 : 0.5
        background: Image {
            id: imgloopMode
            anchors.centerIn: parent
            source: {
                switch (btn_loopMode.loopMode) {
                case 1:
                    return "qrc:/icons/btn_style1/btn_listscircle_single.png"
                case 2:
                    return "qrc:/icons/btn_style1/btn_listjump.png"
                case 3:
                    return "qrc:/icons/btn_style1/btn_listrandom.png"
                default:
                    return "qrc:/icons/btn_style1/btn_listsingle.png"
                }
            }
        }
    }

    Row {
        id: row1
        anchors.verticalCenter: btn_down.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: scaleFfactor * 40
        Text {
            text: qsTr("歌曲")
            color: "white"
            font.pixelSize: scaleFfactor * 30
        }

        Text {
            text: qsTr("视频")
            color: "#DCDCDC"
            font.pixelSize: scaleFfactor * 30
        }

        Text {
            text: qsTr("相关")
            color: "#DCDCDC"
            font.pixelSize: scaleFfactor * 30
        }
    }

    Button {
        id: sharedBt
        anchors.verticalCenter: row1.verticalCenter
        anchors.left: row1.right
        anchors.leftMargin: scaleFfactor * 50
        width: scaleFfactor * 50
        height: width
        opacity: sharedBt.pressed ? 1.0 :  0.6
        background: Image {
            source: "qrc:/images/share.png"
            anchors.fill: parent
        }
    }
}
