import QtQuick 2.6
import Sailfish.Silica 1.0
import "../components"
import "../js/themes.js" as Themes
import "../js/wikidata.js" as Wd

// A Facebook page / profile, drawn natively in the classic Sailbook style:
// cover photo, picture, name, category and the public info.
// No posts: those would need an account (and are what makes it addictive).
Page {
    property var item
    property var colors: Themes.palette(settings.theme, Theme)

    Rectangle { anchors.fill: parent; color: colors.page }

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height + Theme.paddingLarge

        Column {
            id: column
            width: parent.width

            // Cover photo
            Rectangle {
                width: parent.width
                height: width * 0.5
                color: colors.bar
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
                color: colors.card

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
                        border.width: 3
                        borderColor: colors.card
                    }

                    Text {
                        width: parent.width
                        wrapMode: Text.Wrap
                        color: colors.text
                        font.pixelSize: Theme.fontSizeLarge
                        font.bold: true
                        text: item.name
                    }
                    Text {
                        width: parent.width
                        wrapMode: Text.Wrap
                        color: colors.secondary
                        font.pixelSize: Theme.fontSizeSmall
                        text: Wd.subtitle(item)
                        visible: text.length > 0
                    }
                }
            }

            Rectangle { width: parent.width; height: Theme.paddingMedium; color: colors.page }

            // About
            Rectangle {
                width: parent.width
                height: about.height + 2 * Theme.paddingLarge
                color: colors.card

                Column {
                    id: about
                    x: Theme.horizontalPageMargin
                    y: Theme.paddingLarge
                    width: parent.width - 2 * x
                    spacing: Theme.paddingMedium

                    Text { color: colors.text; font.pixelSize: Theme.fontSizeSmall; font.bold: true; text: qsTr("About") }
                    Text {
                        width: parent.width; wrapMode: Text.Wrap; color: colors.text
                        font.pixelSize: Theme.fontSizeSmall
                        text: item.description; visible: text.length > 0
                    }
                    Text {
                        width: parent.width; wrapMode: Text.Wrap; color: colors.secondary
                        font.pixelSize: Theme.fontSizeSmall
                        text: qsTr("Founded in %1").arg(item.founded); visible: item.founded.length > 0
                    }
                    Text {
                        width: parent.width; wrapMode: Text.Wrap; color: colors.link
                        font.pixelSize: Theme.fontSizeSmall
                        text: "facebook.com/" + item.facebook
                        MouseArea { anchors.fill: parent; onClicked: Qt.openUrlExternally(item.facebookUrl) }
                    }
                    Text {
                        width: parent.width; wrapMode: Text.Wrap; color: colors.link
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
                wrapMode: Text.Wrap
                color: colors.secondary
                font.pixelSize: Theme.fontSizeTiny
                text: qsTr("Public info from Wikidata, photo from Wikimedia Commons. No Facebook account used.")
                MouseArea { anchors.fill: parent; onClicked: Qt.openUrlExternally(item.wikidataUrl) }
            }
        }
    }
}
