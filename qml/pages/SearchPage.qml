import QtQuick 2.6
import Sailfish.Silica 1.0
import "../components"
import "../js/backend.js" as Backend
import "../js/themes.js" as Themes

// The only screen of the app: native Silica search. No feed, no web page.
// Results are capped, so the list can only be scrolled so far.
Page {
    id: page

    property string query
    property string filter: "all"
    readonly property int resultLimit: settings.scrollScreens * 6

    function runSearch() {
        results.clear()
        var items = Backend.search(query, filter, resultLimit)
        for (var i = 0; i < items.length; i++) results.append(items[i])
    }

    onFilterChanged: runSearch()
    onResultLimitChanged: runSearch()

    ListModel { id: results }

    SilicaListView {
        id: list
        anchors { left: parent.left; right: parent.right; top: parent.top; bottom: navigation.top }
        clip: true
        model: results

        header: Column {
            width: list.width

            PageHeader { title: "Sailbook" }

            SearchField {
                id: searchField
                width: parent.width
                placeholderText: qsTr("Search Facebook")
                text: page.query
                EnterKey.iconSource: "image://theme/icon-m-search"
                EnterKey.onClicked: {
                    page.query = text
                    page.runSearch()
                    focus = false
                }
                onTextChanged: if (text.length === 0) { page.query = ""; page.runSearch() }
            }

            Label {
                x: Theme.horizontalPageMargin
                width: parent.width - 2 * x
                wrapMode: Text.Wrap
                font.pixelSize: Theme.fontSizeExtraSmall
                color: Theme.secondaryHighlightColor
                text: qsTr("Mockup: sample data only, not connected to Facebook.")
                bottomPadding: Theme.paddingMedium
            }
        }

        delegate: ListItem {
            contentHeight: Math.max(avatar.height, info.height) + 2 * Theme.paddingMedium
            // Pass a plain copy: the ListModel row object must not outlive the row.
            onClicked: pageStack.push(Qt.resolvedUrl("ResultPage.qml"), {
                item: { type: model.type, name: model.name, subtitle: model.subtitle,
                        text: model.text, isVerified: model.isVerified }
            })

            Avatar {
                id: avatar
                x: Theme.horizontalPageMargin
                anchors.verticalCenter: parent.verticalCenter
                name: model.name
                kind: model.type
            }

            Column {
                id: info
                anchors {
                    left: avatar.right; leftMargin: Theme.paddingLarge
                    right: parent.right; rightMargin: Theme.horizontalPageMargin
                    verticalCenter: parent.verticalCenter
                }

                Label {
                    width: parent.width
                    truncationMode: TruncationMode.Fade
                    text: model.name + (model.isVerified ? " ✔" : "")
                    color: highlighted ? Theme.highlightColor : Theme.primaryColor
                }
                Label {
                    width: parent.width
                    truncationMode: TruncationMode.Fade
                    font.pixelSize: Theme.fontSizeExtraSmall
                    color: highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
                    text: (model.type === "profile" ? qsTr("Profile")
                         : model.type === "group" ? qsTr("Group") : qsTr("Post")) + " · " + model.subtitle
                }
                Label {
                    width: parent.width
                    visible: model.type === "post"
                    wrapMode: Text.Wrap
                    maximumLineCount: 3
                    elide: Text.ElideRight
                    font.pixelSize: Theme.fontSizeSmall
                    color: highlighted ? Theme.highlightColor : Theme.primaryColor
                    text: model.text
                }
            }
        }

        footer: Item {
            width: list.width
            height: results.count > 0 ? endLabel.height + 2 * Theme.paddingLarge : 0
            visible: results.count > 0

            Label {
                id: endLabel
                anchors.centerIn: parent
                width: parent.width - 2 * Theme.horizontalPageMargin
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.Wrap
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.secondaryHighlightColor
                text: qsTr("Scroll limit reached: %1 results. Refine your search to see others.").arg(results.count)
            }
        }

        ViewPlaceholder {
            enabled: results.count === 0
            verticalOffset: list.headerItem ? list.headerItem.height / 2 : 0
            text: page.query.length === 0 ? qsTr("Search Facebook") : qsTr("No results")
            hintText: page.query.length === 0
                      ? qsTr("Sailbook has no news feed. Type something to search.")
                      : qsTr("Try a different search.")
        }

        VerticalScrollDecorator {}
    }

    // Classic Sailbook menu bar, now only with search filters and settings.
    Rectangle {
        id: navigation
        height: Theme.itemSizeMedium
        color: Themes.bar(settings.theme, Theme)
        anchors { left: parent.left; right: parent.right; bottom: parent.bottom }

        Row {
            anchors.fill: parent
            property real buttonWidth: width / 5

            NavigationButton { width: parent.buttonWidth; iconSource: Qt.resolvedUrl("../images/icon-search.svg"); active: page.filter === "all"; onClicked: page.filter = "all" }
            NavigationButton { width: parent.buttonWidth; iconSource: Qt.resolvedUrl("../images/icon-requests.svg"); active: page.filter === "profile"; onClicked: page.filter = "profile" }
            NavigationButton { width: parent.buttonWidth; iconSource: Qt.resolvedUrl("../images/icon-pages.svg"); active: page.filter === "post"; onClicked: page.filter = "post" }
            NavigationButton { width: parent.buttonWidth; iconSource: Qt.resolvedUrl("../images/icon-groups.svg"); active: page.filter === "group"; onClicked: page.filter = "group" }
            NavigationButton { width: parent.buttonWidth; iconSource: Qt.resolvedUrl("../images/icon-settings.svg"); onClicked: pageStack.push(Qt.resolvedUrl("SettingsPage.qml")) }
        }
    }
}
