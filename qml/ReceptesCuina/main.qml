import QtQuick 2.0
import QtQuick.Layouts 1.1
import 'core' as Core
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

    Core.BasicWidget {
        id: units
    }

    RowLayout {
        anchors.fill: parent
        Text {
            id: title
            text: "Receptes de cuina"
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter

            color: "#000000"
            font.italic: false
            font.bold: true
            font.pixelSize: units.fingerUnit
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
                onNewReceipt: openSubPage('NewReceipt.qml', {receiptName: name})
                onNoNewReceipt: openMainPage()
                onSavedReceipt: openSubPage('ShowReceipt.qml', {receiptId: receiptId})
                onShowReceipt: openSubPage('ShowReceipt.qml', {receiptId: id})
                onCloseReceipt: openMainPage()
                onBackup: openSubPage('Backup.qml',{})
                onCloseBackup: openMainPage()
            }
        }

    }
    function openSubPage(page,param) {
        pageLoader.setSource(page,param);
    }

    function openMainPage() {
        openSubPage('ReceiptsList.qml',{});
    }

    Component.onCompleted: {
        Storage.initDatabase();
        mainApp.openMainPage();
    }

    focus: true
    Keys.onReleased: {
        if (event.key == Qt.Key_Back) {
            event.accepted = true;
            mainApp.openMainPage();
        }
    }
}
