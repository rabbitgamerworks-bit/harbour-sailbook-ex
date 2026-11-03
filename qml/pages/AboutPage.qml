import QtQuick 2.6
import Sailfish.Silica 1.0

Page {
    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        VerticalScrollDecorator {}

        Column {
            id: column
            x: Theme.horizontalPageMargin
            width: parent.width - 2 * x
            spacing: Theme.paddingLarge

            PageHeader { title: qsTr("About") }

            Label {
                width: parent.width
                wrapMode: Text.Wrap
                text: qsTr("Sailbook is a search-only wrapper around m.facebook.com for Sailfish OS. There is no feed: only search, with limited scrolling.")
            }

            Label {
                width: parent.width
                wrapMode: Text.Wrap
                color: Theme.secondaryColor
                text: qsTr("Free software released under the GNU General Public License (GPL), version 3 or later. Based on the original Sailbook by Dylan Van Assche and contributors.")
            }

            Label {
                width: parent.width
                color: Theme.secondaryHighlightColor
                text: app.appName + " v" + app.version
            }
        }
    }
}
