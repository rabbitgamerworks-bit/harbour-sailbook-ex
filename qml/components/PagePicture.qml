import QtQuick 2.2
import Sailfish.Silica 1.0
import "../js/wikidata.js" as Wd

// Picture of a page or person (round like on the original Sailbook
// screenshots, or square). Shows initials while loading or when there is
// no picture.
Item {
    property string source
    property string name
    property bool round
    property color fallbackColor: "#3b5998"

    width: Theme.itemSizeMedium
    height: width

    Rectangle {
        anchors.fill: parent
        radius: round ? width / 2 : 0
        color: fallbackColor
        visible: picture.status !== Image.Ready

        Text {
            anchors.centerIn: parent
            text: Wd.initials(name)
            color: "white"
            font.pixelSize: parent.width * 0.36
            font.bold: true
        }
    }

    Image {
        id: picture
        anchors.fill: parent
        source: parent.source
        fillMode: Image.PreserveAspectCrop
        sourceSize { width: width; height: height }
        asynchronous: true
        clip: true
        visible: !round && status === Image.Ready
    }

    // Round crop without extra modules.
    ShaderEffect {
        anchors.fill: parent
        visible: round && picture.status === Image.Ready
        property variant source: ShaderEffectSource { sourceItem: picture; hideSource: round }
        fragmentShader: "
            varying highp vec2 qt_TexCoord0;
            uniform sampler2D source;
            uniform lowp float qt_Opacity;
            void main() {
                highp float d = distance(qt_TexCoord0, vec2(0.5));
                gl_FragColor = texture2D(source, qt_TexCoord0) * qt_Opacity * (1.0 - smoothstep(0.48, 0.5, d));
            }"
    }
}
