import QtQuick 2.6
import Sailfish.Silica 1.0
import "../components"

// Native view of a single search result (profile, group or post).
Page {
    property var item

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height + Theme.paddingLarge

        Column {
            id: column
            width: parent.width
            spacing: Theme.paddingLarge

            PageHeader {
                title: item.type === "profile" ? qsTr("Profile")
                     : item.type === "group" ? qsTr("Group") : qsTr("Post")
            }

            Avatar {
                anchors.horizontalCenter: parent.horizontalCenter
                width: Theme.itemSizeHuge
                name: item.name
                kind: item.type
            }

            Label {
                x: Theme.horizontalPageMargin
                width: parent.width - 2 * x
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.Wrap
                font.pixelSize: Theme.fontSizeLarge
                color: Theme.highlightColor
                text: item.name + (item.isVerified ? " ✔" : "")
            }

            Label {
                x: Theme.horizontalPageMargin
                width: parent.width - 2 * x
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.Wrap
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.secondaryHighlightColor
                text: item.subtitle
            }

            Label {
                x: Theme.horizontalPageMargin
                width: parent.width - 2 * x
                wrapMode: Text.Wrap
                text: item.text
            }

            Label {
                x: Theme.horizontalPageMargin
                width: parent.width - 2 * x
                wrapMode: Text.Wrap
                font.pixelSize: Theme.fontSizeExtraSmall
                color: Theme.secondaryColor
                text: qsTr("Mockup: this is sample data, not a real Facebook %1.").arg(item.type)
            }
        }
    }
}
