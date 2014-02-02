import QtQuick 2.0
import QtQuick.Controls 1.0
import "Storage.js" as Storage


Rectangle {
    id: newReceipt
    anchors.fill: parent

    property alias receiptName: receiptName.text
    signal savedReceipt(int receiptId)
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
            inputMethodHints: Qt.ImhNoPredictiveText
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
            id: receiptDesc
            anchors.fill: parent
            width: parent.width
            height: parent.height
            text: ''
            wrapMode: TextEdit.WordWrap
            font.pointSize: 16
            inputMethodHints: Qt.ImhNoPredictiveText
        }
    }

    Row {
        id: buttonsRow
        anchors.bottom: parent.bottom
        anchors.margins: 10
        Button {
            text: 'Desa'
            anchors.margins: 10
            onClicked: newReceipt.savedReceipt(Storage.saveNewReceipt(receiptName.text,receiptDesc.text))
        }
        Button {
            text: 'Cancela'
            anchors.margins: 10
            onClicked: newReceipt.noNewReceipt()
        }
    }

}
