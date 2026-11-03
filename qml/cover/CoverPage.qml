import QtQuick 2.0
import Sailfish.Silica 1.0
import "../js/util.js" as Util

CoverBackground {

    // App Icon
    Image
    {
        id: imgcover
        source: "qrc:///images/icon-cover.svg"
        asynchronous: true
        opacity: 0.2
        width: parent.width
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: parent.bottomMargin
        fillMode: Image.PreserveAspectFit
    }

    Column {
        anchors {
            fill: parent
            topMargin: Theme.paddingMedium
            leftMargin: Theme.paddingLarge
            rightMargin: Theme.paddingLarge
        }
        spacing: Theme.paddingMedium

        // Original layout; the unread message / notification / friend request
        // counters are removed (messenger is gone, counters are addictive).
        Item {
            width: parent.width
            height: numberOfResults.contentHeight

            Label {
                id: numberOfResults
                anchors { left: parent.left; top: parent.top; }
                font.pixelSize: Theme.fontSizeHuge
                font.family: Theme.fontFamilyHeading
                text: app.resultCount
            }

            Label {
                wrapMode: Text.WordWrap
                text: qsTr("Search") + "\n" + qsTr("results")
                font.pixelSize: Theme.fontSizeExtraSmall
                font.family: Theme.fontFamilyHeading
                font.weight: Font.Light
                lineHeight: 0.8
                truncationMode: TruncationMode.Fade

                anchors {
                    left: numberOfResults.right
                    leftMargin: Theme.paddingMedium
                    verticalCenter: numberOfResults.verticalCenter
                }
           }
        }

        Label {
            width: parent.width
            wrapMode: Text.WordWrap
            text: "Ożywione przez Claude"
            font.pixelSize: Theme.fontSizeExtraSmall
            color: Theme.secondaryColor
        }
    }
}
