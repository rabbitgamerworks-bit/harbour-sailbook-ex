import QtQuick 2.6
import Sailfish.Silica 1.0

Page {
    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        PullDownMenu {
            MenuItem {
                text: qsTr("About")
                onClicked: pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
            }
        }

        Column {
            id: column
            width: parent.width

            PageHeader { title: qsTr("Settings") }

            ComboBox {
                label: qsTr("Theme")
                currentIndex: settings.theme
                menu: ContextMenu {
                    MenuItem { text: qsTr("Ambience") }
                    MenuItem { text: qsTr("Facebook") }
                    MenuItem { text: qsTr("Night") }
                }
                onCurrentIndexChanged: settings.theme = currentIndex
            }

            Slider {
                width: parent.width
                label: qsTr("Scroll limit (screens)")
                minimumValue: 1
                maximumValue: 10
                stepSize: 1
                value: settings.scrollScreens
                valueText: value
                onValueChanged: settings.scrollScreens = Math.round(value)
            }

            Label {
                x: Theme.horizontalPageMargin
                width: parent.width - 2 * x
                wrapMode: Text.Wrap
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.secondaryHighlightColor
                text: qsTr("Search results stop after this many screens, so they never turn into an endless feed.")
            }
        }
    }
}
