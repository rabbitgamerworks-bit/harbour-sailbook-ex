import QtQuick 2.6
import Sailfish.Silica 1.0
import Nemo.Configuration 1.0
import "pages"

ApplicationWindow {
    id: app
    initialPage: Component { SearchPage { } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: defaultAllowedOrientations

    property string appName: "Sailbook"
    property string version: "12.0"

    ConfigurationGroup {
        id: settings
        path: "/apps/harbour-sailbook/settings"

        // How far a page may be scrolled, in screen heights.
        property int scrollScreens: 3
    }
}
