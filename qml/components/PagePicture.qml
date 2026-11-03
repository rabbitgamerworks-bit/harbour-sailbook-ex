import QtQuick 2.2
import Sailfish.Silica 1.0
import "../js/wikidata.js" as Wd

// Square picture of a page or person; shows initials while loading or
// when there is no picture.
Rectangle {
    property string source
    property string name

    width: Theme.itemSizeMedium
    height: width
    color: Theme.rgba(Theme.highlightBackgroundColor, 0.4)

    Label {
        anchors.centerIn: parent
        visible: picture.status !== Image.Ready
        text: Wd.initials(name)
        font.pixelSize: parent.width * 0.36
        font.family: Theme.fontFamilyHeading
    }

    Image {
        id: picture
        anchors.fill: parent
        source: parent.source
        fillMode: Image.PreserveAspectCrop
        sourceSize { width: width; height: height }
        asynchronous: true
        clip: true
        visible: status === Image.Ready
    }
}
