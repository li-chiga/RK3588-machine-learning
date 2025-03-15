import QtQuick 2.0
import QtGraphicalEffects 1.0

/**
Lisence: MIT
Author: surfsky.cnblogs.com 2015-01
*/
Rectangle{
    id: panelFg
    color: 'lightblue'
    width: 200
    height: 200
    clip: true

    property Item target : panelBg
    property bool dragable : true

    FastBlur {
        id: blur
        source: parent.target
        width: source.width;
        height: source.height
        radius: 100
    }

    MouseArea {
        id: dragArea
        anchors.fill: parent
        drag.target: dragable ? parent : null
    }

    onXChanged: setBlurPosition();
    onYChanged: setBlurPosition();
    Component.onCompleted: setBlurPosition();
    function setBlurPosition(){
        blur.x = target.x - x;
        blur.y = target.y - y;
    }
}
