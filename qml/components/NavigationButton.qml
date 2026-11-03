import QtQuick 2.6
import Sailfish.Silica 1.0
import "../js/themes.js" as Themes

// Bottom bar button in the style of the classic Sailbook menu bar.
BackgroundItem {
    property alias iconSource: icon.source
    property bool active

    height: parent.height
    highlightedColor: Themes.barHighlight(settings.theme, Theme)

    Rectangle {
        anchors.fill: parent
        color: Themes.barHighlight(settings.theme, Theme)
        visible: active
    }

    HighlightImage {
        id: icon
        anchors.centerIn: parent
        width: Theme.iconSizeMedium
        height: width
        sourceSize { width: width; height: height }
        color: Themes.icon(settings.theme, Theme)
        highlightColor: color
    }
}
