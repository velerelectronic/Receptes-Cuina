import QtQuick 2.0

Rectangle {
    id: mainApp
// No dimensions. The rectangle must be full screen

    Text {
        id: title
        text: "Receptes de cuina"
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter

        color: "#000000"
        font.italic: false
        font.bold: true
        font.pointSize: 32
        verticalAlignment: Text.AlignVCenter
        font.family: "Tahoma"
    }


}
