import QtQuick 2.6
import Sailfish.Silica 1.0
import "../js/backend.js" as Backend

// Round placeholder avatar with initials (sample data has no pictures).
Rectangle {
    property string name
    property string kind: "profile"

    width: Theme.itemSizeMedium
    height: width
    radius: kind === "group" ? Theme.paddingMedium : width / 2
    color: kind === "group" ? "#4a6a9c" : (kind === "post" ? "#5b7f4a" : "#3b5998")

    Label {
        anchors.centerIn: parent
        text: Backend.initials(name)
        color: "white"
        font.pixelSize: parent.width * 0.38
        font.bold: true
    }
}
