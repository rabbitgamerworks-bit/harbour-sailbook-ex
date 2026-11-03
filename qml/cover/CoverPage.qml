import QtQuick 2.6
import Sailfish.Silica 1.0

// Classic Sailbook cover artwork, without the unread/notification counters.
CoverBackground {
    Image {
        source: Qt.resolvedUrl("../images/icon-cover.svg")
        asynchronous: true
        opacity: 0.2
        width: parent.width
        anchors { horizontalCenter: parent.horizontalCenter; bottom: parent.bottom }
        fillMode: Image.PreserveAspectFit
    }

    Column {
        anchors { left: parent.left; right: parent.right; top: parent.top; margins: Theme.paddingLarge }
        spacing: Theme.paddingSmall

        Label {
            text: "Sailbook"
            font.pixelSize: Theme.fontSizeLarge
            font.family: Theme.fontFamilyHeading
        }
        Label {
            width: parent.width
            wrapMode: Text.Wrap
            text: "Ożywione przez Claude"
            font.pixelSize: Theme.fontSizeExtraSmall
            color: Theme.secondaryColor
        }
    }
}
