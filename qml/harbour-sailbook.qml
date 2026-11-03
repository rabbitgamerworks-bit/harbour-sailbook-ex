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
    property string version: "13.0"

    ConfigurationGroup {
        id: settings
        path: "/apps/harbour-sailbook/settings"

        // How far search results go, in screens (about 6 results per screen).
        property int scrollScreens: 3
        // 0 = Ambience, 1 = Facebook, 2 = Night (classic Sailbook themes)
        property int theme: 1
    }
}
