import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1
import 'qrc:///core' as Core

Rectangle {
    property alias caption: label.text
    property alias model: list.model
    property alias delegate: list.delegate
    property alias newelement: newElementButton.text
    property bool visibleNewButton: false

    signal newElementRequested

    anchors.left: parent.left
    anchors.right: parent.right
    anchors.margins: units.nailUnit
    height: mainLayout.height

    Core.UseUnits {
        id: units
    }

    ColumnLayout {
        id: mainLayout
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: label.height + list.height + newElementButton.height + 2 * units.nailUnit
        spacing: units.nailUnit

        Text {
            id: label
            text: ''
            Layout.fillWidth: true
            Layout.preferredHeight: contentHeight
            font.bold: true
            font.pixelSize: units.readUnit
        }

        ListView {
            id: list
            Layout.fillWidth: true
            Layout.preferredHeight: contentItem.height
            interactive: false
        }

        Button {
            id: newElementButton
            Layout.fillWidth: true
            Layout.preferredHeight: height
            height: (visibleNewButton)?units.fingerUnit:0
            visible: visibleNewButton
            onClicked: newElementRequested()
        }
    }

    function indexAt(x,y) {
        return list.currentIndex;
    }
}
