/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @projectName   weather
* @brief         WeatherLayout.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @link          www.openedv.com
* @date          2023-04-06
* @link          http://www.openedv.com/forum.php
*******************************************************************/
import QtQuick 2.0
import QtGraphicalEffects 1.14
import AQuickPlugin 1.0

Rectangle {
    id: weatherBg
    color: "#6391cf" // #232730
    property real scaleFfactor: app_weather.width / 720
    anchors.fill: parent

    NetworkPosition {
        id: networkPosition
        //Component.onCompleted: networkPosition.refreshPosition()
        interval: 30
    }

    WeatherForecast {
        id: weatherForecast
        //Component.onCompleted: weatherForecast.getWeatherForecast()
        interval: 30
    }

    Timer {
        repeat: false
        interval: 1000
        running: true
        onTriggered: {
            networkPosition.refreshPosition()
            weatherForecast.getWeatherForecast()
        }
    }

    function getDayName(day) {
        switch (day % 7){
        case 0:
            return "周日"
        case 1:
            return "周一"
        case 2:
            return "周二"
        case 3:
            return "周三"
        case 4:
            return "周四"
        case 5:
            return "周五"
        case 6:
            return "周六"
        }
    }


    Text {
        anchors.top: column.top
        anchors.topMargin: scaleFfactor * 90
        text: qsTr(weatherForecast.currentTemperature) + "° | " + weather.text
        font.pixelSize: scaleFfactor * 40
        color: "white"
        anchors.horizontalCenter: parent.horizontalCenter
        opacity: !temp.opacity
    }

    Column {
        id: column
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: flickable.top
        anchors.bottomMargin: flickable.contentY > scaleFfactor * 50  ? scaleFfactor * 50 : flickable.contentY
        spacing: scaleFfactor * 10

        Text {
            id: position
            text: qsTr(networkPosition.position)
            font.pixelSize: scaleFfactor * 60
            anchors.horizontalCenter: parent.horizontalCenter
            color: "white"
        }

        Text {
            id: temp
            text: qsTr(weatherForecast.currentTemperature) + "°"
            font.pixelSize: scaleFfactor * 150
            visible: false
            color: "white"
            anchors.horizontalCenter: parent.horizontalCenter
            opacity: ((scaleFfactor * 380 - flickable.contentY) / (scaleFfactor * 80)  - 1)
        }

        Text {
            id: weather
            text: qsTr("--")
            font.pixelSize: scaleFfactor * 40
            color: "white"
            visible: false
            anchors.horizontalCenter: parent.horizontalCenter
            opacity: ((scaleFfactor * 250 - flickable.contentY) / (scaleFfactor * 60)  - 1)
        }

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: scaleFfactor * 25
            Text {
                id: high_temp
                text: qsTr("--")
                font.pixelSize: scaleFfactor * 40
                visible: false
                color: "white"
                opacity: ((scaleFfactor * 180 - flickable.contentY) / (scaleFfactor * 60)  - 1)
            }

            Text {
                id: low_temp
                text: qsTr("--")
                visible: false
                font.pixelSize: scaleFfactor * 40
                color: "white"
                opacity: high_temp.opacity
            }

        }
    }

    ListModel {
        id: model
        ListElement {
            date: "--"
            weather: "--"
            low_temp: "--"
            high_temp: "--"
            item_color: "#78aaee"
        }

        ListElement {
            date: "--"
            weather: "--"
            low_temp: "--"
            high_temp: "--"
            item_color: "#78aaee"
        }

        ListElement {
            date: "--"
            weather: "--"
            low_temp: "--"
            high_temp: "--"
            tempVariations: 0
            item_color: "#78aaee"
        }

        ListElement {
            date: "--"
            weather: "--"
            low_temp: "--"
            high_temp: "--"
            tempVariations: 0
            item_color: "#78aaee"
        }

        ListElement {
            date: "--"
            weather: "--"
            low_temp: "--"
            high_temp: "--"
            tempVariations: 0
            item_color: "#78aaee"
        }

        ListElement {
            date: "--"
            weather: "--"
            low_temp: "--"
            high_temp: "--"
            tempVariations: 0
            item_color: "#78aaee"
        }

        ListElement {
            date: "--"
            weather: "--"
            low_temp: "--"
            high_temp: "--"
            tempVariations: 0
            item_color: "#78aaee"
        }

        ListElement {
            date: "--"
            weather: "--"
            low_temp: "--"
            high_temp: "--"
            tempVariations: 0
            item_color: "#78aaee"
        }
    }


    Connections {
        target: weatherForecast
        function onWeatherInfoChanged() {
            listView.visible = true
            temp.visible = true
            low_temp.visible = true
            high_temp.visible = true
            weather.visible = true
            var dayName
            var time =  Number(Qt.formatDateTime(new Date(), "h" ))
            for (var i = 0; i < 8; i++) {  //获取8天天气，包括日期，天气类型，最低温与最高温
                var obj = model.get(i)
                if (i === 0)
                    obj.date = "昨天"
                else if (i === 1) {
                    obj.date = "今天"
                    var day = Qt.formatDateTime(new Date(), "dddd" )
                    if (day === "Sunday")
                        dayName = 0
                    else if (day === "Monday")
                        dayName = 1
                    else if (day === "Tuesday")
                        dayName = 2
                    else if (day === "Wednesday")
                        dayName = 3
                    else if (day === "Thursday")
                        dayName = 4
                    else if (day === "Friday")
                        dayName = 5
                    else if (day === "Saturday")
                        dayName = 6
                }
                else
                    obj.date = getDayName(dayName + i - 1)

                low_temp.text = "最低" + weatherForecast.weatherlowTemp(1) + "°"
                if (i === 1 && weatherForecast.weatherType(1) === "多云" || weatherForecast.weatherType(1) === "晴") {
                    if (time >= 18 || time <=  6)
                        obj.weather = "夜间" + weatherForecast.weatherType(i)
                    else
                        obj.weather = weatherForecast.weatherType(i)
                } else
                    obj.weather = weatherForecast.weatherType(i)
                if (time >= 18 || time <=  6)
                    obj.item_color = "#2a2e3a"
                else
                    obj.item_color = "#78aaee"
                obj.low_temp = weatherForecast.weatherlowTemp(i)
                obj.high_temp = weatherForecast.weatherhighTemp(i)
                obj.tempVariations = Number(weatherForecast.weatherhighTemp(i)) - Number(weatherForecast.weatherlowTemp(i))
            }
            // today weather
            high_temp.text = "最高" + weatherForecast.weatherhighTemp(1) + "°"
            low_temp.text = "最低" + weatherForecast.weatherlowTemp(1) + "°"
            if (time >= 18 || time <=  6) {
                weather.text = "夜间" + weatherForecast.weatherType(1)
                weatherBg.color = "#232730"
                bottomRect.color = "#2a2e3a"
            } else {
                weather.text = weatherForecast.weatherType(1)
                weatherBg.color = "#6391cf"
                bottomRect.color = "#78aaee"
            }
        }
    }

    Flickable {
        id: flickable
        anchors.top: parent.top
        anchors.topMargin: scaleFfactor * 500
        width: parent.width
        contentHeight: listView.height + scaleFfactor * 400
        height: weatherBg.height - column.height - scaleFfactor * 80
        ListView {
            id: listView
            anchors.horizontalCenter: parent.horizontalCenter
            model: model
            width: parent.width - scaleFfactor * 50
            height: listView.contentHeight
            anchors.top: parent.top
            anchors.topMargin: scaleFfactor * 50
            interactive : false
            visible: false
            delegate: CustomRectangle {
                height: index === 0 ? scaleFfactor * 150 : scaleFfactor * 80
                width: listView.width
                radiusCorners: if (index === 0)
                                   Qt.AlignLeft | Qt.AlignRight | Qt.AlignTop
                               else if ( index === listView.count - 1)
                                   Qt.AlignLeft | Qt.AlignRight | Qt.AlignBottom
                               else
                                   0
                radius: (index === 0 || index === 7) ? scaleFfactor * 25 : 0
                color: item_color//"#2a2e3a"

                Image {
                    id: scheduleIcon
                    visible: index === 0
                    source: "qrc:/icons/schedule.png"
                    anchors.top: parent.top
                    anchors.topMargin: scaleFfactor * 25
                    anchors.left: parent.left
                    anchors.leftMargin: scaleFfactor * 25
                    width: scaleFfactor * 30
                    height: height
                }

                Text {
                    id: forecastText
                    visible: index === 0
                    text: qsTr("8日天气预报")
                    anchors.verticalCenter: scheduleIcon.verticalCenter
                    anchors.left: scheduleIcon.right
                    anchors.leftMargin: scaleFfactor * 5
                    font.pixelSize: scaleFfactor * 25
                    color: "#dddddd"
                }

                Rectangle {
                    height: 1
                    color: "#44dddddd"
                    width: listView.width - scaleFfactor * 50
                    anchors.top: parent.top
                    anchors.topMargin: index === 0 ? scaleFfactor * 70 : 0
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: scaleFfactor * 15
                    Text {
                        text: date
                        color: "white"
                        font.pixelSize: scaleFfactor * 35
                        width: listView.width  / 5
                        horizontalAlignment: Text.AlignHCenter
                    }

                    /*Text {
                    text: weather
                    color: "white"
                    font.pixelSize: 35
                    width: listView.width  / 5
                    horizontalAlignment: Text.AlignHCenter
                }*/

                    Item {
                        width: listView.width  / 5
                        height: scaleFfactor * 50
                        Image {
                            anchors.centerIn: parent
                            width: parent.height
                            fillMode: Image.PreserveAspectFit
                            source: weather === "--" ? "" :"file:///" + appCurrtentDir + "/resource/weather/" + weather
                        }
                    }

                    Text {
                        text: low_temp + "°"
                        color: "white"
                        font.pixelSize: scaleFfactor * 35
                    }

                    Rectangle {
                        height: scaleFfactor * 10
                        radius: height / 2
                        color: "#554f6074"
                        id: parentRect
                        anchors.verticalCenter: parent.verticalCenter
                        width: scaleFfactor * 200

                        Rectangle {
                            height: parent.height
                            radius: parent.radius
                            anchors.leftMargin: (Number(low_temp) - weatherForecast.tempMin) * (parentRect.width / (weatherForecast.tempMax - weatherForecast.tempMin))
                            anchors.left: parent.left
                            width: tempVariations * (parentRect.width / (weatherForecast.tempMax - weatherForecast.tempMin))
                            clip: true
                            visible: false
                            id: maskSource
                            LinearGradient {
                                start: Qt.point(0, 0)
                                end: Qt.point(parentRect.width, 0)
                                anchors.fill: parent
                                visible: false
                                id: maskTarget
                                gradient: Gradient {
                                    GradientStop { position: 0.0; color: "#cfd78e" }
                                    GradientStop { position: 1.0; color: "#f2af2c" }
                                }
                            }
                        }

                        OpacityMask {
                            anchors.fill: maskSource
                            source: maskTarget
                            maskSource: maskSource

                        }
                    }

                    Text {
                        text: high_temp + "°"
                        color: "white"
                        font.pixelSize: scaleFfactor * 35
                    }
                }
            }
        }
    }

    Rectangle {
        id: bottomRect
        Rectangle {
            width: parent.width
            height: 1
            color: "gray"
        }
        anchors.bottom: parent.bottom
        width: parent.width
        height: scaleFfactor * 120
        color: weatherBg.color
        Image {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: scaleFfactor * 10
            source: "qrc:/icons/location.png"
        }
    }
}
