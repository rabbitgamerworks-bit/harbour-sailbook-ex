import QtQuick 2.0
import Sailfish.Silica 1.0
import "../js/util.js" as Util
import "../js/wikidata.js" as Wd

// Replaces the original FBWebview. Same role and API (goBack, reload,
// canGoBack, pulldown menu, loading placeholder), but instead of the
// Facebook web page it shows a native search. There is no login and no
// request ever goes to Facebook/Meta: pages and people are found through
// their public Facebook usernames on Wikidata (see wikidata.js).
Item {
    id: root

    property bool canGoBack: history.length > 0
    property string query
    property string filter: "all"      // "all", "profile" or "page"
    property bool loading
    property string note
    readonly property int resultLimit: settings.scrollScreens * 6
    property var history: []
    property Item searchFieldItem
    property int _request: 0

    function search(text, newFilter) {
        if (query.length > 0) history = history.concat([{ query: query, filter: filter }])
        query = String(text).trim()
        if (newFilter) filter = newFilter
        reload()
    }

    function setFilter(newFilter) {
        if (query.length === 0) { filter = newFilter; if (searchFieldItem) searchFieldItem.forceActiveFocus(); return }
        search(query, newFilter)
    }

    // The news feed button: there is no feed, the page stays empty.
    function showFeed() {
        if (query.length > 0) history = history.concat([{ query: query, filter: filter }])
        query = ""
        if (searchFieldItem) searchFieldItem.text = ""
        reload()
    }

    function goBack() {
        if (history.length === 0) return
        var last = history[history.length - 1]
        history = history.slice(0, history.length - 1)
        query = last.query
        filter = last.filter
        if (searchFieldItem) searchFieldItem.text = query
        reload()
    }

    function reload() {
        results.clear()
        app.resultCount = 0
        note = ""
        if (query.length === 0) { loading = false; return }
        loading = true
        var id = ++_request
        var xhr = new XMLHttpRequest()
        xhr.open("GET", Wd.buildUrl(query, filter, resultLimit, Qt.locale().name.split("_")[0]))
        xhr.setRequestHeader("Accept", "application/sparql-results+json")
        xhr.onreadystatechange = function () {
            if (xhr.readyState !== XMLHttpRequest.DONE || id !== root._request) return
            root.loading = false
            if (xhr.status === 0) { root.note = qsTr("No network"); return }
            if (xhr.status !== 200) { root.note = qsTr("Search failed (%1)").arg(xhr.status); return }
            try {
                var items = Wd.parse(xhr.responseText, Qt.md5, root.resultLimit)
                for (var i = 0; i < items.length; i++) results.append(items[i])
                app.resultCount = items.length
            } catch (e) {
                root.note = qsTr("Search failed (%1)").arg("JSON")
            }
        }
        xhr.send()
    }

    onResultLimitChanged: reload()

    ListModel { id: results }

    // The night theme had a dark page; the others show the ambience.
    Rectangle {
        anchors.fill: parent
        color: settings.theme == 2 ? Util.getBackgroundColor(2) : "transparent"
    }

    SilicaListView {
        id: list
        anchors.fill: parent
        clip: true // Enforce painting inside our defined screen
        model: results
        opacity: loading ? 0.0 : 1.0
        Behavior on opacity { FadeAnimation {} }

        PullDownMenu {
            backgroundColor: Util.getBackgroundColor(settings.theme)
            highlightColor: Util.getHighlightColor(settings.theme)
            enabled: !root.loading

            MenuItem {
                color: Util.getPrimaryColor(settings.theme)
                text: qsTr("About")
                onClicked: pageStack.push(Qt.resolvedUrl("../pages/AboutPage.qml"))
            }

            MenuItem {
                color: Util.getPrimaryColor(settings.theme)
                text: qsTr("Settings")
                onClicked: pageStack.push(Qt.resolvedUrl("../pages/SettingsPage.qml"))
            }

            MenuItem {
                color: Util.getPrimaryColor(settings.theme)
                text: qsTr("Refresh")
                visible: settings.showRefresh && root.query.length > 0
                onClicked: root.reload()
            }

            MenuItem {
                color: Util.getPrimaryColor(settings.theme)
                text: qsTr("Back")
                visible: root.canGoBack && settings.placeBack == 0 // Hide when we haven't navigated yet
                onClicked: root.goBack()
            }
        }

        header: Column {
            width: list.width

            PageHeader {
                title: app.appName
                description: "Ożywione przez Claude"
            }

            SearchField {
                id: searchField
                width: parent.width
                placeholderText: qsTr("Search")
                inputMethodHints: Qt.ImhNoPredictiveText
                EnterKey.iconSource: "image://theme/icon-m-search"
                EnterKey.onClicked: {
                    root.search(text)
                    focus = false
                }
                Component.onCompleted: root.searchFieldItem = searchField
            }

            SectionHeader {
                visible: results.count > 0
                text: root.filter === "profile" ? qsTr("People") : root.filter === "page" ? qsTr("Pages") : qsTr("Pages and people")
            }
        }

        delegate: ListItem {
            contentHeight: Math.max(picture.height, info.height) + 2 * Theme.paddingMedium
            onClicked: pageStack.push(Qt.resolvedUrl("../pages/ResultPage.qml"), { item: {
                type: model.type, name: model.name, description: model.description,
                facebook: model.facebook, website: model.website, founded: model.founded,
                category: model.category, place: model.place, picture: model.picture,
                cover: model.cover, wikidataUrl: model.wikidataUrl
            } })

            PagePicture {
                id: picture
                x: Theme.horizontalPageMargin
                anchors.verticalCenter: parent.verticalCenter
                source: model.picture
                name: model.name
            }

            Column {
                id: info
                anchors {
                    left: picture.right; leftMargin: Theme.paddingLarge
                    right: parent.right; rightMargin: Theme.horizontalPageMargin
                    verticalCenter: parent.verticalCenter
                }
                Label {
                    width: parent.width
                    truncationMode: TruncationMode.Fade
                    color: highlighted ? Theme.highlightColor : Theme.primaryColor
                    text: model.name
                }
                Label {
                    width: parent.width
                    truncationMode: TruncationMode.Fade
                    font.pixelSize: Theme.fontSizeExtraSmall
                    color: highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
                    text: Wd.subtitle(model)
                    visible: text.length > 0
                }
                Label {
                    width: parent.width
                    truncationMode: TruncationMode.Fade
                    font.pixelSize: Theme.fontSizeExtraSmall
                    color: Theme.secondaryHighlightColor
                    text: "facebook.com/" + model.facebook
                }
            }
        }

        footer: Item {
            width: list.width
            height: results.count > 0 ? limitLabel.height + 2 * Theme.paddingLarge : 0
            visible: results.count > 0

            Label {
                id: limitLabel
                anchors.centerIn: parent
                width: parent.width - 2 * Theme.horizontalPageMargin
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
                font.pixelSize: Theme.fontSizeExtraSmall
                color: Theme.secondaryHighlightColor
                text: results.count >= root.resultLimit
                      ? qsTr("Scroll limit reached: %1 results. Refine your search to see others.").arg(results.count)
                      : qsTr("End of results.")
            }
        }

        VerticalScrollDecorator {}
    }

    // Original Sailbook loading screen, also used for "No network".
    PlaceholderWebview {
        id: placeholder
        opacity: root.loading || root.note.length > 0 ? 1.0 : 0.0
        visible: opacity > 0
        note: root.note
    }
}
