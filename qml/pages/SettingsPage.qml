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
                text: qsTr("Pages can only be scrolled this many screens down, so results never turn into an endless feed.")
            }
        }
    }
}
