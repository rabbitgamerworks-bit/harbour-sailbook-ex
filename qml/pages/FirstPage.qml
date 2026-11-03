import QtQuick 2.2
import Sailfish.Silica 1.0
import "../js/util.js" as Util
import "../components"

Page {
    SearchView {
        id: fbWebview
        anchors { left: parent.left; right: parent.right; top: parent.top; bottom: navigation.top }
        visible: opacity > 0
        Behavior on opacity { FadeAnimation {} }
    }

    Rectangle {
        id: navigation
        height: Theme.itemSizeMedium
        color: Util.getBackgroundColor(settings.theme)
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        // Original Sailbook menu bar. Removed in this fork: messages (messenger),
        // notifications, events, groups and the Facebook settings button.
        // The feed button shows an empty page: there is no news feed.
        Row {
            anchors { fill: parent }
            NavigationButton { onClicked: fbWebview.goBack(); iconSource: "qrc:///images/icon-back.svg"; visible: settings.placeBack==1 && fbWebview.canGoBack }
            NavigationButton { onClicked: fbWebview.showFeed(); iconSource: "qrc:///images/icon-newsfeed.svg"; visible: settings.showFeed }
            NavigationButton { onClicked: fbWebview.setFilter("profile"); iconSource: "qrc:///images/icon-requests.svg"; visible: settings.showFriends }
            NavigationButton { onClicked: fbWebview.setFilter("all"); iconSource: "qrc:///images/icon-search.svg"; visible: settings.showSearch }
            NavigationButton { onClicked: fbWebview.setFilter("page"); iconSource: "qrc:///images/icon-pages.svg"; visible: settings.showLikedPages }
        }
    }
}
