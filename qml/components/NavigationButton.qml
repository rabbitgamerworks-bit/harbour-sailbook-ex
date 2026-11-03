import QtQuick 2.6
import Sailfish.Silica 1.0

// Classic Sailbook menu bar button (same size and look as the original).
// The notification counters of the original are gone on purpose.
BackgroundItem {
    property string iconSource
    property bool active
    property color highlight

    height: parent.height
    highlightedColor: highlight

    Rectangle {
        anchors.fill: parent
        color: highlight
        opacity: active ? 1.0 : 0.0
        Behavior on opacity { FadeAnimation {} }
    }

    Image {
        width: Theme.iconSizeSmallPlus
        height: width
        sourceSize { width: width; height: height }
        anchors.centerIn: parent
        source: iconSource
        asynchronous: true
    }
}
