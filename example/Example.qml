import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic
import DelegateUI.Utils

Window {
    id: window
    width: 1600
    height: 850
    visible: true
    title: qsTr("DelegateUI-Colors Example")

    property bool light: !themeSwitch.checked

    Component.onCompleted: lightChanged();

    Rectangle {
        id: background
        anchors.fill: parent
        color: "#f0f0f0"

        Rectangle {
            id: circle
            x: r - width
            y: -height * 0.5
            width: 0
            height: 0
            radius: width * 0.5
            color: "#141414"
            property real r: Math.sqrt(parent.width * parent.width + parent.height * parent.height)

            NumberAnimation {
                running: !window.light
                properties: "width,height"
                target: circle
                from: 0
                to: circle.r * 2
                duration: 800
                easing.type: Easing.InOutCubic
            }

            NumberAnimation on width {
                running: window.light
                properties: "width,height"
                target: circle
                from: circle.r * 2
                to: 0
                duration: 800
                easing.type: Easing.InOutCubic
            }
        }
    }

    DelColorGenerator {
        id: colorGenerator
    }

    component ColorView: Column {
        id: __column
        spacing: 5
        property alias title: __title.text
        property alias desc: __desc.text
        property alias model: __listView.model
        property string colorName: ""
        property real lineWidth: 180
        property real lineHeight: 30
        property real stretch: 15

        Text {
            id: __title
            anchors.horizontalCenter: parent.horizontalCenter
            color: window.light ? "#5c6b77" : "white"
            font.pointSize: 14

            Behavior on color { ColorAnimation { duration: 800 } }
        }

        Text {
            id: __desc
            anchors.horizontalCenter: parent.horizontalCenter
            color: window.light ? "#5c6b77" : "white"

            Behavior on color { ColorAnimation { duration: 800 } }
        }

        ListView {
            id: __listView
            width: __column.lineWidth
            height: count * __column.lineHeight
            anchors.horizontalCenter: parent.horizontalCenter
            interactive: false
            delegate: Rectangle {
                id: __rootItem
                width: hovered ? __column.lineWidth + __column.stretch : __column.lineWidth
                height: __column.lineHeight
                topRightRadius: hovered ? 4 : 0
                bottomRightRadius: hovered ? 4 : 0
                color: modelData

                property bool hovered: false

                Behavior on width { NumberAnimation { } }
                Behavior on topRightRadius { NumberAnimation { } }
                Behavior on bottomRightRadius { NumberAnimation { } }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    color: (window.light ? (index < 5) : (index >= 5)) ? "#444" : "#f0f0f0"
                    text: __column.colorName + "-" + (index + 1)
                    font.bold: true
                }

                Text {
                    id: __text
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: 5
                    color: (window.light ? (index < 5) : (index >= 5)) ? "#444" : "#f0f0f0"
                    text: String(modelData).toUpperCase()
                    font.bold: true
                    opacity: __rootItem.hovered ? 1 : 0

                    Behavior on opacity { NumberAnimation { } }
                }

                ToolTip {
                    id: __tooltip
                    enter: Transition {
                        NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; duration: 300 }
                    }
                    exit: Transition {
                        NumberAnimation { property: "opacity"; from: 1.0; to: 0.0; duration: 300  }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: __rootItem.hovered = true;
                    onExited: __rootItem.hovered = false;
                    onClicked: {
                        qmlApi.setClipboardText(__text.text);
                        __tooltip.show(qsTr("已复制到剪切板: ") + __text.text, 300);
                    }
                }
            }
            populate: Transition {
                NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 800 }
            }
        }
    }

    Switch {
        id: themeSwitch
        anchors.right: parent.right
        height: 40
        text: checked ? "🌙" : "🔆"
        font.pointSize: 18
    }

    TabBar {
        id: bar
        width: parent.width
        anchors.bottom: parent.bottom
        currentIndex: swipeView.currentIndex

        TabButton {
            text: qsTr("调色板样例")
        }

        TabButton {
            text: qsTr("自定义色板生成")
        }
    }

    SwipeView {
        id: swipeView
        width: parent.width
        anchors.top: themeSwitch.bottom
        anchors.bottom: bar.top
        currentIndex: bar.currentIndex
        interactive: false

        Item {
            GridLayout {
                anchors.fill: parent
                columns: 6
                rows: 2
                uniformCellWidths: true
                uniformCellHeights: true

                Repeater {
                    model: [
                        { title: qsTr("Dust Red / 薄暮"), desc: qsTr("斗志、奔放"), color: DelColorGenerator.Preset_Red, colorName: "red" },
                        { title: qsTr("Volcano / 火山"), desc: qsTr("醒目、澎湃"), color: DelColorGenerator.Preset_Volcano, colorName: "volcano" },
                        { title: qsTr("Sunset Orange / 日暮"), desc: qsTr("温暖、欢快"), color: DelColorGenerator.Preset_Orange, colorName: "orange" },
                        { title: qsTr("Calendula Gold / 金盏花"), desc: qsTr("活力、积极"), color: DelColorGenerator.Preset_Gold, colorName: "gold" },
                        { title: qsTr("Sunrise Yellow / 日出"), desc: qsTr("出生、阳光"), color: DelColorGenerator.Preset_Yellow, colorName: "yellow" },
                        { title: qsTr("Lime / 青柠"), desc: qsTr("自然、生机"), color: DelColorGenerator.Preset_Lime, colorName: "lime" },
                        { title: qsTr("Polar Green / 极光绿"), desc: qsTr("健康、创新"), color: DelColorGenerator.Preset_Green, colorName: "green" },
                        { title: qsTr("Cyan / 明青"), desc: qsTr("希望、坚强"), color: DelColorGenerator.Preset_Cyan, colorName: "cyan" },
                        { title: qsTr("Daybreak Blue / 拂晓蓝"), desc: qsTr("包容、科技、普惠"), color: DelColorGenerator.Preset_Blue, colorName: "blue" },
                        { title: qsTr("Geek Blue / 极客蓝"), desc: qsTr("探索、钻研"), color: DelColorGenerator.Preset_Geekblue, colorName: "geekblue" },
                        { title: qsTr("Golden Purple / 酱紫"), desc: qsTr("优雅、浪漫"), color: DelColorGenerator.Preset_Purple, colorName: "purple" },
                        { title: qsTr("Magenta / 法式洋红"), desc: qsTr("明快、感性"), color: DelColorGenerator.Preset_Magenta, colorName: "magenta" }
                    ]
                    delegate: ColorView {
                        id: rootItem
                        Layout.alignment: Qt.AlignCenter
                        title: modelData.title
                        desc: modelData.desc
                        colorName: modelData.colorName

                        Connections {
                            target: window
                            function onLightChanged() {
                                rootItem.model = colorGenerator.generate(modelData.color, window.light, window.light ? "#ffffff" : "#141414");
                            }
                        }
                    }
                }
            }
        }

        Item {
            id: discoverTab

            RowLayout{
                anchors.fill: parent

                Item {
                    Layout.preferredWidth: parent.width * 0.5
                    Layout.fillHeight: true

                    ColorView {
                        id: customView
                        width: 600
                        anchors.centerIn: parent
                        lineWidth: 600
                        lineHeight: 50
                        stretch: 30
                        colorName: "color"

                        Connections {
                            target: window
                            function onLightChanged() {
                                customView.model = colorGenerator.generate(colorSelect.currentColor, window.light, window.light ? "#f0f0f0" : "#141414");
                            }
                        }
                    }
                }

                Item {
                    Layout.preferredWidth: parent.width * 0.5
                    Layout.fillHeight: true

                    DelColorPicker {
                        id: colorSelect
                        anchors.centerIn: parent
                        initColor: "red"
                        movable: false
                        onCurrentColorChanged: {
                            customView.model = colorGenerator.generate(colorSelect.currentColor, window.light, window.light ? "#f0f0f0" : "#141414");
                        }
                        Component.onCompleted: open();
                    }
                }
            }
        }
    }
}
