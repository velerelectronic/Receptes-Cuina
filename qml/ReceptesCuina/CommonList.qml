import QtQuick 2.0
import QtQuick.Controls 1.1
import 'core' as Core

Rectangle {
    property alias caption: label.text
    property alias model: list.model
    property alias delegate: list.delegate
    property alias newelement: newElementButton.text
    property alias visibleNewButton: newElementButton.visible

    signal newElementRequested

    anchors.left: parent.left
    anchors.right: parent.right
    height: childrenRect.height

    Core.BasicWidget {
        id: units
    }

    Column {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: childrenRect.height

        Text {
            id: label
            text: ''
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: units.nailUnit
            font.bold: true
            font.pixelSize: units.fingerUnit
        }

        ListView {
            id: list
            anchors.left: parent.left
            anchors.right: parent.right
            height: childrenRect.height
            interactive: false
/*            header: Component {
                Text { text: 'header' }
            }*/
        }

        Button {
            id: newElementButton
            anchors.left: parent.left
            anchors.right: parent.right
            height: units.fingerUnit
            visible: false
            onClicked: newElementRequested()
        }
    }

    function indexAt(x,y) {
        return list.currentIndex;
    }
}
