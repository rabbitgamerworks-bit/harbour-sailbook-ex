import QtQuick 2.2
import Sailfish.Silica 1.0
import "../js/util.js" as Util
import "../components"

Dialog {

    // Removed in this fork: notifications, messages, events, groups,
    // Facebook settings and logout buttons, feed priority, external links.
    onAccepted: {
        settings.showFeed = showFeed.checked
        settings.showFriends = showFriends.checked
        settings.showSearch = showSearch.checked
        settings.showLikedPages = showLikedPages.checked
        settings.showRefresh = showRefresh.checked
        settings.placeBack = placeBack.currentIndex
        settings.theme = theme.currentIndex
        settings.scrollScreens = Math.round(scrollScreens.value)
    }

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: settingsColumn.height

        VerticalScrollDecorator {}

        Column {
            id: settingsColumn
            width: parent.width
            spacing: Theme.paddingLarge

            DialogHeader { title: qsTr("Settings") }

            SectionHeader{ text: qsTr("Appearance") }

            ComboBox {
                id: theme
                label: qsTr("Theme")
                currentIndex: settings.theme
                menu: ContextMenu {
                    MenuItem { text: qsTr("Ambience") }
                    MenuItem { text: qsTr("Facebook") }
                    MenuItem { text: qsTr("Facebook nightmode") }
                }
            }

            ComboBox {
                id: placeBack
                label: qsTr("Back button in")
                currentIndex: settings.placeBack
                menu: ContextMenu {
                    MenuItem { text: qsTr("Pulldown menu") }
                    MenuItem { text: qsTr("Menu bar") }
                }
            }

            TextSwitch {
                id: showFeed
                text: qsTr("Show Facebook feed button")
                checked: settings.showFeed
                description: qsTr("There is no news feed: this button only clears the search.")
            }

            TextSwitch {
                id: showFriends
                text: qsTr("Show Facebook friends button")
                checked: settings.showFriends
                description: qsTr("Searches people only.")
            }

            TextSwitch {
                id: showSearch
                text: qsTr("Show Facebook search button")
                checked: settings.showSearch
            }

            TextSwitch {
                id: showLikedPages
                text: qsTr("Show Facebook liked pages button")
                checked: settings.showLikedPages
                description: qsTr("Searches pages only.")
            }

            TextSwitch {
                id: showRefresh
                text: qsTr("Show Facebook refresh pulldown menu")
                checked: settings.showRefresh
            }

            SectionHeader{ text: qsTr("Limits") }

            Slider {
                id: scrollScreens
                width: parent.width
                label: qsTr("Scroll limit (screens)")
                minimumValue: 1
                maximumValue: 10
                stepSize: 1
                value: settings.scrollScreens
                valueText: value
            }

            TextLabel {
                labelFontSize: Theme.fontSizeExtraSmall
                color: Theme.secondaryHighlightColor
                labelText: qsTr("Search results stop after this many screens, so they never turn into an endless feed. Sailbook has no news feed, messenger or notifications and never asks for a Facebook account.")
            }
        }
    }
}
