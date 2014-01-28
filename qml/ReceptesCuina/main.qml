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
            onNewReceipt: {
                pageLoader.setSource('NewReceipt.qml')
                pageLoader.item.receiptName = name
            }
            onNoNewReceipt: openMainPage()
            onSaveReceipt: {
                Storage.saveNewReceipt(name,desc);
                openMainPage()
            }
            onShowReceipt: {
                pageLoader.setSource('ShowReceipt.qml')
                pageLoader.item.fillReceipt(id)
            }
            onCloseReceipt: openMainPage()
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
