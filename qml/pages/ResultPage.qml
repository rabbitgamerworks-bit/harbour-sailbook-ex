import QtQuick 2.2
import Sailfish.Silica 1.0
import "../components"
import "../js/wikidata.js" as Wd

// A page or person found by the search, in the style of the original
// Sailbook pages. The Facebook address is plain text on purpose: nothing in
// Sailbook opens Facebook, so there is never a login screen.
Page {
    property var item

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height + Theme.paddingLarge

        VerticalScrollDecorator {}

        Column {
            id: column
            width: parent.width
            spacing: Theme.paddingLarge

            PageHeader { title: item.name }

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width - 2 * Theme.horizontalPageMargin
                height: status === Image.Ready ? width * 0.5 : 0
                source: item.cover
                fillMode: Image.PreserveAspectCrop
                asynchronous: true
                clip: true
            }

            Row {
                x: Theme.horizontalPageMargin
                spacing: Theme.paddingLarge

                PagePicture {
                    width: Theme.itemSizeExtraLarge
                    source: item.picture
                    name: item.name
                }

                Column {
                    anchors.verticalCenter: parent.verticalCenter
                    width: column.width - 2 * Theme.horizontalPageMargin - Theme.itemSizeExtraLarge - Theme.paddingLarge
                    Label {
                        width: parent.width
                        wrapMode: Text.WordWrap
                        color: Theme.highlightColor
                        text: item.name
                    }
                    Label {
                        width: parent.width
                        wrapMode: Text.WordWrap
                        font.pixelSize: Theme.fontSizeSmall
                        color: Theme.secondaryHighlightColor
                        text: Wd.subtitle(item)
                        visible: text.length > 0
                    }
                }
            }

            SectionHeader { text: qsTr("About") }
            TextLabel { labelText: item.description; visible: item.description.length > 0 }
            TextLabel {
                labelFontSize: Theme.fontSizeSmall
                color: Theme.secondaryColor
                labelText: qsTr("Founded in %1").arg(item.founded)
                visible: item.founded.length > 0
            }

            SectionHeader { text: "Facebook" }
            TextLabel { labelFontSize: Theme.fontSizeSmall; labelText: "facebook.com/" + item.facebook }

            IconTextButton {
                anchors.horizontalCenter: parent.horizontalCenter
                visible: item.website.length > 0
                text: item.website.replace(/^https?:\/\//, "").replace(/\/$/, "")
                iconSource: "qrc:///images/icon-external.png"
                onClicked: Qt.openUrlExternally(item.website)
            }

            TextLabel {
                labelFontSize: Theme.fontSizeTiny
                color: Theme.secondaryColor
                labelText: qsTr("Public info from Wikidata, photo from Wikimedia Commons. No Facebook account used.")
            }
        }
    }
}
