import QtQuick 2.6
import Sailfish.Silica 1.0
import "../js/wikidata.js" as Wd

// Square page/profile picture; falls back to initials while loading or
// when there is no picture (or it cannot be downloaded).
Rectangle {
    property string source
    property string name
    property color borderColor: "#dddfe2"

    width: Theme.itemSizeMedium
    height: width
    color: "#3b5998"
    border { width: 1; color: borderColor }

    Label {
        anchors.centerIn: parent
        visible: picture.status !== Image.Ready
        text: Wd.initials(name)
        color: "white"
        font.pixelSize: parent.width * 0.36
        font.bold: true
    }

    Image {
        id: picture
        anchors { fill: parent; margins: 1 }
        source: parent.source
        fillMode: Image.PreserveAspectCrop
        sourceSize { width: width; height: height }
        asynchronous: true
        clip: true
        visible: status === Image.Ready
    }
}
