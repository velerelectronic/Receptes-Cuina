import QtQuick 2.0
import "Storage.js" as Storage

Rectangle {
    id: mainApp
// No dimensions. The rectangle must be full screen
//    anchors.fill: parent

    signal newReceipt (string name)
    signal saveReceipt (string name, string desc)
    signal noNewReceipt
    signal showReceipt (int id)
    signal closeReceipt
    signal backup
    signal closeBackup

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

    Loader {
        id: pageLoader
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: title.bottom
        anchors.bottom: parent.bottom

        Connections {
            target: pageLoader.item
            ignoreUnknownSignals: true
            onNewReceipt: pageLoader.setSource('NewReceipt.qml', {receiptName: name})
            onNoNewReceipt: openMainPage()
            onSavedReceipt: pageLoader.setSource('ShowReceipt.qml', {receiptId: receiptId})
            onShowReceipt: pageLoader.setSource('ShowReceipt.qml', {receiptId: id})
            onCloseReceipt: openMainPage()
            onBackup: pageLoader.setSource('Backup.qml')
            onCloseBackup: openMainPage()
        }
    }

    function openMainPage() {
        pageLoader.setSource('ReceiptsList.qml');
    }

    Component.onCompleted: {
        Storage.initDatabase();
        openMainPage();
    }

}
