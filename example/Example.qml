import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic
import DelegateUI.Utils

Window {
    id: window
    width: 800
    height: 600
    visible: true
    title: qsTr("DelegateUI-Colors Example")

    property bool light: !themeSwitch.checked

    onLightChanged: {
        listView.model = colorGenerator.generate("#1677FF", window.light, light ? "#f0f0f0" : "#141414");
    }

    Rectangle {
        id: background
        anchors.fill: parent
        color: "#f0f0f0"

        Rectangle {
            id: circle
            x: r - width
            y: -height * 0.5
            width: r * 2
            height: width
            radius: width * 0.5
            color: "#141414"
            property real r: Math.sqrt(parent.width * parent.width + parent.height * parent.height)

            NumberAnimation on width {
                running: !window.light
                from: 0
                to: circle.r * 2
                duration: 800
                easing.type: Easing.InOutCubic
            }

            NumberAnimation on width {
                running: window.light
                from: circle.r * 2
                to: 0
                duration: 800
                easing.type: Easing.InOutCubic
            }
        }
    }

    Switch {
        id: themeSwitch
        anchors.right: parent.right
        text: checked ? "🌙" : "🔆"
        font.pointSize: 18
    }

    DelColorGenerator {
        id: colorGenerator
    }

    ListView {
        id: listView
        width: 100
        height: count * 20
        anchors.centerIn: parent
        delegate: Rectangle {
            width: 100
            height: 20
            color: modelData
        }
        populate: Transition {
            NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 800 }
        }
    }
}
