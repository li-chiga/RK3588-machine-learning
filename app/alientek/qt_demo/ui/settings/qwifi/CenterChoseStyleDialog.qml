import QtQuick 2.0
import QtQuick.Controls 2.5

Dialog {
    width: parent.width
    height: parent.height
    property string textTitle: ""
    property string textSubTitle: ""
    background: Rectangle {
        anchors.fill: parent
        color: "#55c7c7cc"
    }
    Rectangle {
        anchors.centerIn: parent
        width: subTitle.contentWidth + scaleFfactor * 50
        height: width / 2
        radius: scaleFfactor * 32
        Text {
            id: title
            text: qsTr(textTitle)
            anchors.top: parent.top
            anchors.topMargin: scaleFfactor * 10
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: scaleFfactor * 30
            font.weight: Font.Medium
            horizontalAlignment: Text.AlignHCenter
        }

        Text {
            id: subTitle
            text: qsTr(textSubTitle)
            anchors.top: title.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: scaleFfactor * 25
            font.weight: Font.Normal
        }
        Image {
            id: image
            width: parent.width
            height: width / 5
            source: if (cancel_bt.pressed)
                        "qrc:/qwifi/icons/user_chose_rect_left.png"
                    else if (ignore_bt.pressed)
                        "qrc:/qwifi/icons/user_chose_rect_right.png"
                    else
                        "qrc:/qwifi/icons/user_chose_rect_normal.png"
            anchors.bottom: parent.bottom
        }

        Button {
            id: cancel_bt
            anchors.left: parent.left
            height: image.height
            anchors.bottom: parent.bottom
            width: parent.width / 2
            background: Text {
                text: qsTr("取消")
                anchors.centerIn: parent
                font.pixelSize: scaleFfactor * 30
                color: "#007aff"
            }
            onClicked: discarded()
        }

        Button {
            id: ignore_bt
            anchors.right: parent.right
            height: image.height
            anchors.bottom: parent.bottom
            width: parent.width / 2
            background: Text {
                text: qsTr("忽略")
                anchors.centerIn: parent
                font.pixelSize: scaleFfactor * 30
                color: "#ff3b30"
            }
            onClicked: accepted()
        }
    }
}
