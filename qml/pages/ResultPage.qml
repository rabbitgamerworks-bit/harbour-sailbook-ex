import QtQuick 2.6
import Sailfish.Silica 1.0
import "../components"
import "../js/util.js" as Util
import "../js/wikidata.js" as Wd

// A page or person found by the search, drawn like a page on the Facebook
// mobile site inside the original Sailbook: cover photo, picture, name,
// category and an About card. No posts (they need an account).
// The Facebook address is plain text: nothing in Sailbook opens Facebook,
// so there is never a login screen.
Page {
    property var item
    property var page: Util.getPagePalette(settings.theme)

    Rectangle { anchors.fill: parent; color: page.page }

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height + Theme.paddingLarge

        VerticalScrollDecorator {}

        Column {
            id: column
            width: parent.width

            // Cover photo
            Rectangle {
                width: parent.width
                height: width * 0.5
                color: Util.getBackgroundColor(1)
                Image {
                    anchors.fill: parent
                    source: item.cover
                    fillMode: Image.PreserveAspectCrop
                    asynchronous: true
                    clip: true
                }
            }

            Rectangle {
                width: parent.width
                height: card.height + 2 * Theme.paddingLarge
                color: page.card

                Column {
                    id: card
                    x: Theme.horizontalPageMargin
                    y: Theme.paddingLarge
                    width: parent.width - 2 * x
                    spacing: Theme.paddingSmall

                    PagePicture {
                        width: Theme.itemSizeHuge
                        source: item.picture
                        name: item.name
                    }
                    Text {
                        width: parent.width
                        wrapMode: Text.WordWrap
                        color: page.text
                        font.pixelSize: Theme.fontSizeLarge
                        font.bold: true
                        text: item.name
                    }
                    Text {
                        width: parent.width
                        wrapMode: Text.WordWrap
                        color: page.secondary
                        font.pixelSize: Theme.fontSizeSmall
                        text: Wd.subtitle(item)
                        visible: text.length > 0
                    }
                }
            }

            Item { width: parent.width; height: Theme.paddingMedium }

            Rectangle {
                width: parent.width
                height: about.height + 2 * Theme.paddingLarge
                color: page.card

                Column {
                    id: about
                    x: Theme.horizontalPageMargin
                    y: Theme.paddingLarge
                    width: parent.width - 2 * x
                    spacing: Theme.paddingMedium

                    Text { color: page.text; font.pixelSize: Theme.fontSizeSmall; font.bold: true; text: qsTr("About") }
                    Text {
                        width: parent.width; wrapMode: Text.WordWrap; color: page.text
                        font.pixelSize: Theme.fontSizeSmall
                        text: item.description; visible: text.length > 0
                    }
                    Text {
                        width: parent.width; wrapMode: Text.WordWrap; color: page.secondary
                        font.pixelSize: Theme.fontSizeSmall
                        text: qsTr("Founded in %1").arg(item.founded); visible: item.founded.length > 0
                    }
                    Text {
                        width: parent.width; wrapMode: Text.WrapAnywhere; color: page.secondary
                        font.pixelSize: Theme.fontSizeSmall
                        text: "facebook.com/" + item.facebook
                    }
                    Text {
                        width: parent.width; wrapMode: Text.WrapAnywhere; color: page.link
                        font.pixelSize: Theme.fontSizeSmall
                        text: item.website.replace(/^https?:\/\//, "").replace(/\/$/, "")
                        visible: item.website.length > 0
                        MouseArea { anchors.fill: parent; onClicked: Qt.openUrlExternally(item.website) }
                    }
                }
            }

            Text {
                x: Theme.horizontalPageMargin
                width: parent.width - 2 * x
                topPadding: Theme.paddingMedium
                wrapMode: Text.WordWrap
                color: page.secondary
                font.pixelSize: Theme.fontSizeTiny
                text: qsTr("Public info from Wikidata, photo from Wikimedia Commons. No Facebook account used.")
            }
        }
    }
}
