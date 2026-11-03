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

            PageHeader { title: qsTr("About"); description: "Ożywione przez Claude" }

            Label {
                width: parent.width
                wrapMode: Text.Wrap
                text: qsTr("Sailbook is a search-only Facebook client for Sailfish OS in the classic Sailbook look. There is no news feed, no messages and no notifications: only search, with limited scrolling. No Facebook account is needed: pages and people are found through their public Facebook links on Wikidata.")
            }

            Label {
                width: parent.width
                wrapMode: Text.Wrap
                color: Theme.secondaryColor
                text: qsTr("Free software released under the GNU General Public License (GPL), version 3 or later. Based on the original Sailbook by Dylan Van Assche and contributors.")
            }

            Label {
                width: parent.width
                wrapMode: Text.Wrap
                color: Theme.secondaryColor
                text: qsTr("Data: Wikidata (CC0). Pictures: Wikimedia Commons. Icons: the original Sailbook icons by Alain Molteni.")
            }

            Label {
                width: parent.width
                color: Theme.secondaryHighlightColor
                text: app.appName + " v" + app.version + " · Ożywione przez Claude"
            }
        }
    }
}
