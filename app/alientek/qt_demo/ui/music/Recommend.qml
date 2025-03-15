import QtQuick 2.0

Rectangle {
    id: recommend
    width: parent.width - scaleFfactor * 50
    height: scaleFfactor * 200
    // anchors.horizontalCenter: parent.horizontalCenter
    radius: scaleFfactor * 25
    color: "white"

    Row {
        id: row1
        anchors.horizontalCenter: parent.horizontalCenter
        Item {
            width: recommend.width / 5
            height: width
            Rectangle {
                width: parent.width / 1.5
                color: "#f19ec2"
                height: width
                radius: height  / 2
                anchors.centerIn: parent
                Image {
                    anchors.centerIn: parent
                    source: "qrc:/icons/music_album_icon.png"
                }
            }
        }

        Item {
            width: recommend.width / 5
            height: width
            Rectangle {
                width: parent.width / 1.5
                color: "#f19ec2"
                height: width
                radius: height  / 2
                anchors.centerIn: parent
                Image {
                    anchors.centerIn: parent
                    source: "qrc:/icons/favorite_icon.png"
                }
            }
        }

        Item {
            width: recommend.width / 5
            height: width
            Rectangle {
                width: parent.width / 1.5
                color: "#f19ec2"
                height: width
                radius: height  / 2
                anchors.centerIn: parent
                Image {
                    anchors.centerIn: parent
                    source: "qrc:/icons/recommend_icon.png"
                }
            }
        }

        Item {
            width: recommend.width / 5
            height: width
            Rectangle {
                width: parent.width / 1.5
                color: "#f19ec2"
                height: width
                radius: height  / 2
                anchors.centerIn: parent
                Image {
                    anchors.centerIn: parent
                    source: "qrc:/icons/trophy_icon.png"
                }
            }
        }

        Item {
            width: recommend.width / 5
            height: width
            Rectangle {
                width: parent.width / 1.5
                color: "#f19ec2"
                height: width
                radius: height  / 2
                anchors.centerIn: parent
                Image {
                    anchors.centerIn: parent
                    source: "qrc:/icons/more_icon.png"
                }
            }
        }
    }

    Row {
        id: row2
        anchors.top: row1.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        Text {
            width: recommend.width / 5
            font.pixelSize: scaleFfactor * 25
            height: scaleFfactor * 40
            text: "乐库"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }
        Text {
            width: recommend.width / 5
            font.pixelSize: scaleFfactor * 25
            height: scaleFfactor * 40
            text: "猜你喜欢"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }
        Text {
            width: recommend.width / 5
            font.pixelSize: scaleFfactor * 25
            height: scaleFfactor * 40
            text: "每日推荐"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }
        Text {
            width: recommend.width / 5
            font.pixelSize: scaleFfactor * 25
            height: scaleFfactor * 40
            text: "排行榜"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }
        Text {
            width: recommend.width / 5
            font.pixelSize: scaleFfactor * 25
            height: scaleFfactor * 40
            text: "更多"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }
    }
}
