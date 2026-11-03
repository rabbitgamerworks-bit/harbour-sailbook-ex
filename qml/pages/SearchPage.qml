import QtQuick 2.6
import Sailfish.Silica 1.0
import "../components"
import "../js/themes.js" as Themes
import "../js/wikidata.js" as Wd

// Sailbook's main screen, recreating the classic Sailbook look:
// Facebook-style white content with the blue Sailbook menu bar at the bottom.
//
// Deliberately NOT here: news feed, messages, notifications, counters.
// The "feed" stays empty until you search, and results stop at the
// scroll limit. Search works without a Facebook account (see wikidata.js).
Page {
    id: page

    property var colors: Themes.palette(settings.theme, Theme)
    property string query
    property string filter: "all"
    property bool loading
    property string error
    readonly property int resultLimit: settings.scrollScreens * 6
    property int _request: 0

    function runSearch() {
        results.clear()
        error = ""
        if (query.trim().length === 0) { loading = false; return }
        loading = true
        var id = ++_request
        var lang = Qt.locale().name.split("_")[0]
        var xhr = new XMLHttpRequest()
        xhr.open("GET", Wd.buildUrl(query, filter, resultLimit, lang))
        xhr.setRequestHeader("Accept", "application/sparql-results+json")
        xhr.onreadystatechange = function () {
            if (xhr.readyState !== XMLHttpRequest.DONE || id !== page._request) return
            page.loading = false
            if (xhr.status !== 200) {
                page.error = xhr.status === 429 ? qsTr("Too many searches right now, try again in a minute.")
                                                : qsTr("Search failed (%1). Check your connection.").arg(xhr.status)
                return
            }
            try {
                var items = Wd.parse(xhr.responseText, Qt.md5, page.resultLimit)
                for (var i = 0; i < items.length; i++) results.append(items[i])
            } catch (e) {
                page.error = qsTr("Unexpected answer from the server.")
            }
        }
        xhr.send()
    }

    function goHome() {
        query = ""
        searchInput.text = ""
        filter = "all"
        runSearch()
    }

    onFilterChanged: runSearch()
    onResultLimitChanged: runSearch()

    ListModel { id: results }

    Rectangle {
        anchors.fill: parent
        color: colors.page
    }

    // Facebook mobile style search bar at the top.
    Rectangle {
        id: topBar
        z: 2
        anchors { left: parent.left; right: parent.right; top: parent.top }
        height: Theme.itemSizeSmall + Theme.paddingMedium
        color: colors.bar

        Rectangle {
            anchors { fill: parent; margins: Theme.paddingSmall + 2 }
            radius: 4
            color: colors.field

            Image {
                id: lens
                anchors { left: parent.left; leftMargin: Theme.paddingMedium; verticalCenter: parent.verticalCenter }
                width: Theme.iconSizeSmall; height: width
                sourceSize { width: width; height: height }
                source: "image://theme/icon-m-search?" + colors.secondary
            }

            TextInput {
                id: searchInput
                anchors {
                    left: lens.right; leftMargin: Theme.paddingMedium
                    right: parent.right; rightMargin: Theme.paddingMedium
                    verticalCenter: parent.verticalCenter
                }
                color: colors.fieldText
                font.pixelSize: Theme.fontSizeSmall
                selectionColor: colors.barHighlight
                inputMethodHints: Qt.ImhNoPredictiveText
                clip: true
                EnterKey.iconSource: "image://theme/icon-m-search"
                EnterKey.onClicked: {
                    page.query = text
                    page.runSearch()
                    focus = false
                }

                Text {
                    anchors.fill: parent
                    verticalAlignment: Text.AlignVCenter
                    visible: searchInput.text.length === 0 && !searchInput.activeFocus
                    text: qsTr("Search Facebook")
                    color: colors.secondary
                    font.pixelSize: Theme.fontSizeSmall
                }
            }
        }
    }

    SilicaListView {
        id: list
        anchors { left: parent.left; right: parent.right; top: topBar.bottom; bottom: navigation.top }
        clip: true
        model: results

        PullDownMenu {
            MenuItem { text: qsTr("About"); onClicked: pageStack.push(Qt.resolvedUrl("AboutPage.qml")) }
            MenuItem { text: qsTr("Settings"); onClicked: pageStack.push(Qt.resolvedUrl("SettingsPage.qml")) }
            MenuItem { text: qsTr("Refresh"); visible: page.query.length > 0; onClicked: page.runSearch() }
        }

        header: Column {
            width: list.width

            // App name with the "revived" line underneath.
            Rectangle {
                width: parent.width
                height: titleColumn.height + 2 * Theme.paddingMedium
                color: colors.card

                Column {
                    id: titleColumn
                    x: Theme.horizontalPageMargin
                    anchors.verticalCenter: parent.verticalCenter
                    Text { text: "Sailbook"; color: colors.link; font.pixelSize: Theme.fontSizeLarge; font.bold: true }
                    Text { text: "Ożywione przez Claude"; color: colors.secondary; font.pixelSize: Theme.fontSizeExtraSmall }
                }
            }

            Rectangle { width: parent.width; height: 1; color: colors.separator }

            // Section header like the original ("Recommended", "Friends"...)
            Rectangle {
                width: parent.width
                height: results.count > 0 ? Theme.itemSizeExtraSmall : 0
                visible: results.count > 0
                color: colors.card
                Text {
                    x: Theme.horizontalPageMargin
                    anchors.verticalCenter: parent.verticalCenter
                    color: colors.text
                    font.pixelSize: Theme.fontSizeSmall
                    font.bold: true
                    text: page.filter === "profile" ? qsTr("People") : page.filter === "page" ? qsTr("Pages") : qsTr("Pages and people")
                }
                Rectangle { anchors.bottom: parent.bottom; width: parent.width; height: 1; color: colors.separator }
            }
        }

        delegate: BackgroundItem {
            width: list.width
            height: Math.max(picture.height, info.height) + 2 * Theme.paddingLarge
            highlightedColor: colors.separator
            onClicked: pageStack.push(Qt.resolvedUrl("ResultPage.qml"), { item: {
                type: model.type, name: model.name, description: model.description,
                facebook: model.facebook, facebookUrl: model.facebookUrl, website: model.website,
                founded: model.founded, category: model.category, place: model.place,
                picture: model.picture, cover: model.cover, wikidataUrl: model.wikidataUrl
            } })

            Rectangle { anchors.fill: parent; color: colors.card; z: -1 }

            PagePicture {
                id: picture
                x: Theme.horizontalPageMargin
                anchors.verticalCenter: parent.verticalCenter
                source: model.picture
                name: model.name
                borderColor: colors.separator
            }

            Column {
                id: info
                anchors {
                    left: picture.right; leftMargin: Theme.paddingLarge
                    right: parent.right; rightMargin: Theme.horizontalPageMargin
                    verticalCenter: parent.verticalCenter
                }
                Text {
                    width: parent.width
                    elide: Text.ElideRight
                    color: colors.text
                    font.pixelSize: Theme.fontSizeMedium
                    text: model.name
                }
                Text {
                    width: parent.width
                    elide: Text.ElideRight
                    color: colors.secondary
                    font.pixelSize: Theme.fontSizeExtraSmall
                    text: Wd.subtitle(model)
                    visible: text.length > 0
                }
                Text {
                    width: parent.width
                    elide: Text.ElideRight
                    color: colors.link
                    font.pixelSize: Theme.fontSizeExtraSmall
                    text: "facebook.com/" + model.facebook
                }
            }

            Rectangle { anchors.bottom: parent.bottom; x: Theme.horizontalPageMargin; width: parent.width - x; height: 1; color: colors.separator }
        }

        footer: Item {
            width: list.width
            height: (results.count > 0 || page.error.length > 0) ? endText.height + 2 * Theme.paddingLarge : 0

            Text {
                id: endText
                anchors.centerIn: parent
                width: parent.width - 2 * Theme.horizontalPageMargin
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.Wrap
                color: colors.secondary
                font.pixelSize: Theme.fontSizeExtraSmall
                visible: parent.height > 0
                text: page.error.length > 0 ? page.error
                      : results.count >= page.resultLimit
                        ? qsTr("Scroll limit reached: %1 results. Refine your search to see others.").arg(results.count)
                        : qsTr("End of results.")
            }
        }

        BusyIndicator {
            anchors.centerIn: parent
            running: page.loading
            size: BusyIndicatorSize.Medium
        }
    }

    // Classic Sailbook menu bar. The original had: news feed, friends,
    // messages, notifications, search, groups, settings. Messages,
    // notifications and groups are gone (addictive / need an account);
    // the news feed button now shows an empty page.
    Rectangle {
        id: navigation
        height: Theme.itemSizeMedium
        color: colors.bar
        anchors { left: parent.left; right: parent.right; bottom: parent.bottom }

        Row {
            anchors.fill: parent
            property real buttonWidth: width / 5

            NavigationButton {
                width: parent.buttonWidth; highlight: colors.barHighlight
                iconSource: Qt.resolvedUrl("../images/icon-newsfeed.svg")
                active: page.query.length === 0
                onClicked: page.goHome()
            }
            NavigationButton {
                width: parent.buttonWidth; highlight: colors.barHighlight
                iconSource: Qt.resolvedUrl("../images/icon-requests.svg")
                active: page.query.length > 0 && page.filter === "profile"
                onClicked: { page.filter = "profile"; if (page.query.length === 0) searchInput.forceActiveFocus() }
            }
            NavigationButton {
                width: parent.buttonWidth; highlight: colors.barHighlight
                iconSource: Qt.resolvedUrl("../images/icon-search.svg")
                active: page.query.length > 0 && page.filter === "all"
                onClicked: { page.filter = "all"; searchInput.forceActiveFocus() }
            }
            NavigationButton {
                width: parent.buttonWidth; highlight: colors.barHighlight
                iconSource: Qt.resolvedUrl("../images/icon-pages.svg")
                active: page.query.length > 0 && page.filter === "page"
                onClicked: { page.filter = "page"; if (page.query.length === 0) searchInput.forceActiveFocus() }
            }
            NavigationButton {
                width: parent.buttonWidth; highlight: colors.barHighlight
                iconSource: Qt.resolvedUrl("../images/icon-settings.svg")
                onClicked: pageStack.push(Qt.resolvedUrl("SettingsPage.qml"))
            }
        }
    }
}
