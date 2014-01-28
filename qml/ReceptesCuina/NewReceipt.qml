import QtQuick 2.0
import QtQuick.Controls 1.0


Rectangle {
    id: newReceipt
    anchors.fill: parent

    property alias receiptName: receiptName.text

    signal saveReceipt(string name, string desc)
    signal noNewReceipt()

    Text {
        id: labelName
        anchors.left: parent.left
        anchors.top: parent.top
        text: 'Nom de la recepta'
        font.bold: true
        anchors.margins: 10
    }

    Rectangle {
        id: nameRect
        border.color: "black"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: labelName.bottom
        height: receiptName.height

        TextField {
            id: receiptName
            text: ''
            focus: true
            anchors.fill: parent
            font.pointSize: 20
        }
        anchors.margins: 10
    }

    Text {
        id: labelDesc
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: nameRect.bottom
        text: 'Descripció'
        height: 20
        font.bold: true
        anchors.margins: 10
    }

    Rectangle {
        border.color: "black"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: labelDesc.bottom
        anchors.bottom: buttonsRow.top

        anchors.margins: 10
        TextArea {
            id: desc
            anchors.fill: parent
            width: parent.width
            height: parent.height
            text: ''
            wrapMode: TextEdit.WordWrap
            font.pointSize: 16
        }
    }

    Row {
        id: buttonsRow
        anchors.bottom: parent.bottom
        anchors.margins: 10
        Button {
            text: 'Desa'
            onClicked: newReceipt.saveReceipt(receiptName.text,desc.text)
            anchors.margins: 10
        }
        Button {
            text: 'Cancela'
            onClicked: newReceipt.noNewReceipt()
            anchors.margins: 10
        }
    }

}
