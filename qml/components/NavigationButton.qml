import QtQuick 2.0
import Sailfish.Silica 1.0
import "../js/util.js" as Util

BackgroundItem {
    property string iconSource

    width: parent.width/Util.getMenubarItems()
    height: parent.height
    highlightedColor: Util.getHighlightBackgroundColor(settings.theme)

    Image {
        width: Theme.iconSizeSmallPlus
        height: width
        anchors { centerIn: parent }
        source: iconSource
        asynchronous: true
    }
    // The notification counters of the original are removed on purpose.
}
