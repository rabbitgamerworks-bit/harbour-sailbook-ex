import QtQuick 2.6
import Sailfish.Silica 1.0
import Sailfish.WebView 1.0
import "../js/guard.js" as Guard

// The only screen of the app: a search field on top of the full
// m.facebook.com page. No feed, no navigation bar, limited scrolling.
WebViewPage {
    id: page

    function search(query) {
        webView.url = Guard.searchUrl(query)
    }

    function applyScrollLimit() {
        webView.runJavaScript(Guard.scrollLimitScript(settings.scrollScreens))
    }

    Connections {
        target: settings
        onScrollScreensChanged: page.applyScrollLimit()
    }

    Rectangle {
        id: toolbar
        z: 1
        anchors { left: parent.left; right: parent.right; top: parent.top }
        height: searchField.height
        color: Theme.overlayBackgroundColor

        IconButton {
            id: backButton
            anchors { left: parent.left; verticalCenter: parent.verticalCenter }
            icon.source: "image://theme/icon-m-back"
            enabled: webView.canGoBack
            opacity: enabled ? 1.0 : Theme.opacityLow
            onClicked: webView.goBack()
        }

        SearchField {
            id: searchField
            anchors { left: backButton.right; right: menuButton.left }
            placeholderText: qsTr("Search Facebook")
            EnterKey.iconSource: "image://theme/icon-m-search"
            EnterKey.onClicked: {
                page.search(text)
                focus = false
            }
        }

        IconButton {
            id: menuButton
            anchors { right: parent.right; verticalCenter: parent.verticalCenter }
            icon.source: "image://theme/icon-m-setting"
            onClicked: pageStack.push(Qt.resolvedUrl("SettingsPage.qml"))
        }
    }

    WebView {
        id: webView
        anchors { left: parent.left; right: parent.right; top: toolbar.bottom; bottom: progress.top }
        // No httpUserAgent override: the engine's own, current user agent is sent.
        url: Guard.SEARCH_URL
        opacity: Guard.isBlocked(url) ? 0.0 : 1.0

        onUrlChanged: {
            if (Guard.isBlocked(url)) {
                console.log("Feed page blocked, back to search:", url)
                webView.url = Guard.SEARCH_URL
            }
        }
        onLoadingChanged: {
            if (!loading) page.applyScrollLimit()
        }
    }

    ProgressBar {
        id: progress
        anchors { left: parent.left; right: parent.right; bottom: parent.bottom }
        height: webView.loading ? implicitHeight : 0
        visible: webView.loading
        minimumValue: 0
        maximumValue: 100
        value: webView.loadProgress
    }
}
