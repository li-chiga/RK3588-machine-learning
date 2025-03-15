import QtQuick 2.0
import QtQuick.Controls 2.5
import AQuickPlugin 1.0

Item {
    id: settingsLayout
    anchors.fill: parent
    property real scaleFfactor: settingsLayout.width / 720
    signal reduceScanFrequency(int time)
    signal wifiConnectionStateChanged(bool online, int level) // true: online false: offline; level 0/1/2

    onVisibleChanged:  {
        if (!visible)
            reduceScanFrequency(0) // 0, stop scan
        else
            reduceScanFrequency(23000)
    }
    Rectangle {
        anchors.fill: parent
        color: "#eff2f7"
    }

    onWidthChanged: {
        if (settings_swipeView.currentIndex != 0 && settings_swipeView.contentItem.highlightMoveDuration !== 0)
            settings_swipeView.contentItem.highlightMoveDuration = 0
    }

    SwipeView {
        id: settings_swipeView
        visible: true
        anchors.fill: parent
        clip: true
        interactive: false
        MainPage {id: mainPage }
        AppleID { }
        Wifi { }
        onCurrentIndexChanged: {
            if (currentIndex === 2)
                reduceScanFrequency(23000)
            else
                reduceScanFrequency(43000)
        }
    }
    // BackButton {
    //     id: backButton
    //     visible: settings_swipeView.currentIndex != 0
    // }
}
