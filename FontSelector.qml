import QtQuick
import QtQuick.Controls
import qs.Commons
import qs.Ui

Item {
    id: root

    property var fontOptions: []
    property var filteredFonts: []
    property string selectedFont: ""
    property string fontSearch: ""
    property bool fontListLoaded: false

    signal fontSelected(string font)
    signal searchChanged(string text)

    property Item focusTarget: fontSearchField

    function forceFocus() {
        fontSearchField.forceActiveFocus()
    }

    implicitHeight: fontColumn.implicitHeight

    Column {
        id: fontColumn

        width: parent.width
        spacing: Style.space(8)

        Text {
            text: "FONT"
            color: Color.popups.text
            font.family: Style.font.family
            font.pixelSize: Style.font.caption
            font.bold: true
            topPadding: Style.space(4)
        }

        Row {
            width: parent.width
            spacing: Style.space(6)

            Text {
                text: "Current"
                color: Color.popups.text
                font.family: Style.font.family
                font.pixelSize: Style.font.body
                width: parent.width - currentFontLabel.implicitWidth - parent.spacing
            }

            Text {
                id: currentFontLabel

                text: root.selectedFont.length > 0 ? root.selectedFont : "Default (Inter)"
                color: Qt.darker(Color.popups.text, 1.4)
                font.family: Style.font.family
                font.pixelSize: Style.font.body
                elide: Text.ElideRight
            }

        }

        TextField {
            id: fontSearchField

            width: parent.width
            activeFocusOnTab: true
            placeholderText: "Search fonts..."
            text: root.fontSearch
            foreground: Color.popups.text
            accent: Color.accent
            onTextChanged: {
                root.searchChanged(text)
                fontList.currentIndex = -1
            }
        }

        Text {
            visible: !root.fontListLoaded
            text: "Loading fonts..."
            color: Qt.darker(Color.popups.text, 1.5)
            font.family: Style.font.family
            font.pixelSize: Style.font.caption
            font.italic: true
        }

        Text {
            visible: root.fontListLoaded && root.fontOptions.length === 0
            text: "No fonts found"
            color: Qt.darker(Color.popups.text, 1.5)
            font.family: Style.font.family
            font.pixelSize: Style.font.caption
            font.italic: true
        }

        Text {
            visible: root.fontListLoaded && root.fontOptions.length > 0 && root.filteredFonts.length === 0
            text: "No matches"
            color: Qt.darker(Color.popups.text, 1.5)
            font.family: Style.font.family
            font.pixelSize: Style.font.caption
            font.italic: true
        }

        Rectangle {
            visible: root.fontListLoaded && root.filteredFonts.length > 0
            width: parent.width
            height: Math.min(Style.space(200), root.filteredFonts.length * Style.space(28))
            radius: Style.cornerRadius
            color: "transparent"

            ListView {
                id: fontList

                anchors.fill: parent
                clip: true
                boundsBehavior: Flickable.StopAtBounds
                model: root.filteredFonts
                currentIndex: -1

                delegate: Rectangle {
                    required property var modelData
                    required property int index
                    readonly property string label: modelData !== undefined && modelData.label !== undefined
                        ? String(modelData.label) : String(modelData)
                    readonly property string fontValue: modelData !== undefined && modelData.value !== undefined
                        ? String(modelData.value) : String(modelData)
                    readonly property bool selected: root.selectedFont === fontValue

                    width: fontList.width
                    height: Style.space(28)
                    radius: Math.max(2, Style.cornerRadius)
                    color: fontList.currentIndex === index ? Style.selectedFill
                        : (selected ? Util.alpha(Color.accent, 0.18) : "transparent")

                    Text {
                        anchors.fill: parent
                        anchors.leftMargin: Style.space(8)
                        anchors.rightMargin: Style.space(8)
                        text: parent.label
                        color: fontList.currentIndex === index ? Color.accent : Color.popups.text
                        font.family: Style.font.family
                        font.pixelSize: Style.font.body
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onPositionChanged: fontList.currentIndex = parent.index
                        onClicked: root.fontSelected(parent.fontValue)
                    }
                }
            }
        }

    }

}
