import QtQuick 2.0

Rectangle {
    property alias caption: label.text
    property alias model: list.model
    property alias delegate: list.delegate

    anchors.left: parent.left
    anchors.right: parent.right
    height: childrenRect.height

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
            anchors.margins: 10
            font.bold: true
            font.pointSize: 16
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
    }

    function indexAt(x,y) {
        return list.currentIndex;
    }
}
