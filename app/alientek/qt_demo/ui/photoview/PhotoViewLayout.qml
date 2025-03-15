import QtQuick 2.0
import AQuickPlugin 1.0
Item {
    id: photoViewLayout
    anchors.fill: parent
    property int displayPhotoHighlightMoveDuration: 0
    property QtObject photoListModel
    property real scaleFfactor: app_photoview.width / 720
    signal photoPropertyChanged()
    signal deleteButtonClicked()
    Loader {
        id: loader
        asynchronous: true
        Component.onCompleted:  {
            loader.sourceComponent = componentImages
        }
    }

    Component {
        id: componentImages
        PhotoListModel {
            id: images_photoListModel
            Component.onCompleted:  {
                images_photoListModel.add(appCurrtentDir + "/resource/images/");
                photoListModel = images_photoListModel
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        //color: "#eff2f7"
        color: "white"
    }
    PhotoListView {
        anchors.fill: parent
        id: phtoListView
    }
    DisplayPhoto {
        id: displayPhoto
        visible: false
        anchors.fill: parent
    }
}
