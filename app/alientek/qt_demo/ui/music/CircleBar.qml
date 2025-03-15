/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @projectName   music
* @brief         CircleBar.qml
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com/1252699831@qq.com
* @link          www.openedv.com
* @date          2023-02-27
*******************************************************************/
import QtQuick 2.0

Rectangle {
    id: control
    implicitWidth: 100
    implicitHeight: 100
    //anchors.fill: parent
    color: "#55888888"
    radius: height / 2
    property real progress: 0
    //signal playProgressChanged(real playProgress)
    readonly property real size: Math.min(control.width, control.height)

    Canvas {
        id: canvas
        anchors.fill: parent

        Connections {
            target: app_music
            function onPlayProgressChanged(playProgress)  {
                progress = playProgress
                if (app_music.active && appActive)
                    canvas.requestPaint()
            }
        }
        onPaint: {
            var ctx = getContext("2d")
            ctx.clearRect(0, 0, width, height)
            ctx.strokeStyle = "#f19ec2"
            ctx.lineWidth = parent.size / 15
            ctx.lineCap = "round"
            ctx.beginPath()
            var startAngle = -Math.PI / 180 * 90
            var endAngle = startAngle + control.progress * Math.PI / 180 * 360
            ctx.arc(width / 2, height / 2, width / 2 - ctx.lineWidth / 2, startAngle, endAngle)
            ctx.stroke()
        }
    }
}
