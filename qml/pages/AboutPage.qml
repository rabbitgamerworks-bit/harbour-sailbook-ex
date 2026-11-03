import QtQuick 2.2
import Sailfish.Silica 1.0
import "../js/util.js" as Util
import "../components"

Page {
    SilicaFlickable {
        anchors.fill: parent
        contentHeight: aboutColumn.height

        VerticalScrollDecorator {}

        Column {
            id: aboutColumn
            width: parent.width
            spacing: Theme.paddingLarge

            PageHeader { title: qsTr("About"); description: "Ożywione przez Claude" }

            SectionHeader { text: qsTr("What's") + " Sailbook?" }
            TextLabel { labelText: qsTr("Sailbook is an unofficial Facebook client for Sailfish OS.") }

            SectionHeader { text: "Ożywione przez Claude" }
            TextLabel { labelText: qsTr("This fork only searches. There is no login, no news feed, no messenger and no notifications, and scrolling is limited. Sailbook never connects to Facebook: pages and people are found through their public Facebook addresses on Wikidata, so no account is needed and nothing can get an account banned.") }
            TextLabel { labelFontSize: Theme.fontSizeExtraSmall; color: Theme.secondaryHighlightColor; labelText: qsTr("Data: Wikidata (CC0). Pictures: Wikimedia Commons.") }

            IconTextButton {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("GitHub") + " (fork)"
                iconSource: "qrc:///images/icon-github.png"
                onClicked: Qt.openUrlExternally("https://github.com/rabbitgamerworks-bit/harbour-sailbook-ex")
            }

            SectionHeader { text: qsTr("Privacy & licensing") }
            TextLabel { labelText: "Sailbook " + qsTr("is free software released under the GNU General Public License (GPL), version 3 or later.") }

            IconTextButton {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("GitHub")
                iconSource: "qrc:///images/icon-github.png"
                onClicked: { Qt.openUrlExternally("https://github.com/DylanVanAssche/harbour-sailbook");
                }
            }

            SectionHeader { text: qsTr("Developers") }

            IconTextButton {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Rudi Timmermans")
                iconSource: "qrc:///images/image-rudi.png"
                onClicked: { Qt.openUrlExternally("https://twitter.com/Xray20001");
                }
            }

            IconTextButton {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Dylan Van Assche")
                iconSource: "qrc:///images/image-dylan.png"
                onClicked: { Qt.openUrlExternally("https://www.github.com/modulebaan");
                }
            }

            IconTextButton {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Matthias Weiß")
                iconSource: "qrc:///images/image-matthias.png"
                onClicked: { Qt.openUrlExternally("https://github.com/codeandcreate");
                }
            }

            IconTextButton {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Donate with Paypal")
                iconSource: "qrc:///images/icon-paypal.png"
                onClicked: { Qt.openUrlExternally("https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=6Z4P9MAAD996W");
                }
            }

            SectionHeader { text: qsTr("Translators") }

            IconTextButton {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Translations")
                iconSource: "qrc:///images/icon-trans.png"
                onClicked: pageStack.push(Qt.resolvedUrl("../pages/TranslationsPage.qml"))
            }

            SectionHeader { text: qsTr("Icons") }
            TextLabel { labelText: qsTr("Sailbook icons made by Alain Molteni.") }

            SectionHeader { text: qsTr("Version") }
            TextLabel { labelText: app.appName + " v" + app.version }

            Item { width: parent.width; height: Theme.itemSizeMedium } //Spacer
        }
    }
}
