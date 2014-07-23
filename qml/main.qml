import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtQuick.Window 2.0
import 'qrc:///core' as Core
import "qrc:///qml/Storage.js" as Storage

Window {
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

    Core.UseUnits {
        id: units
    }

    Text {
        id: title
        text: "Receptes de cuina"
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        height: contentHeight + 2 * units.nailUnit

        color: "#000000"
        font.italic: false
        font.bold: true
        font.pixelSize: units.readUnit
        verticalAlignment: Text.AlignVCenter
        font.family: "Tahoma"
        MouseArea {
            anchors.fill: parent
            onClicked: openMainPage()
        }
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
            onNewReceipt: openSubPage('NewReceipt', {receiptName: name})
            onNoNewReceipt: openMainPage()
            onSavedReceipt: openSubPage('ShowReceipt', {receiptId: receiptId})
            onShowReceipt: openSubPage('ShowReceipt', {receiptId: id})
            onCloseReceipt: openMainPage()
            onBackup: openSubPage('Backup',{})
            onCloseBackup: openMainPage()
        }
    }

    function openSubPage(page,param) {
        pageLoader.setSource('' + page + '.qml',param);
    }

    function openMainPage() {
        openSubPage('ReceiptsList',{});
    }

    Component.onCompleted: {
        receiptsModel.setQuery('CREATE TABLE IF NOT EXISTS receipts (id INTEGER PRIMARY KEY, name TEXT, desc TEXT, image TEXT)');
        receiptsModel.tableName = 'receipts';
        receiptsModel.fieldNames = ['id', 'name', 'desc', 'image'];

        ingredientsModel.setQuery('CREATE TABLE IF NOT EXISTS ingredientsReceipts (id INTEGER PRIMARY KEY,receipt INTEGER,ord INTEGER,desc TEXT)')
        ingredientsModel.tableName = 'ingredientsReceipts';
        ingredientsModel.fieldNames = ['id', 'receipt','ord','desc'];

        stepsModel.setQuery('CREATE TABLE IF NOT EXISTS stepsReceipts (id INTEGER PRIMARY KEY,receipt INTEGER,ord INTEGER,desc TEXT)');
        stepsModel.tableName = 'stepsReceipts';
        stepsModel.fieldNames = ['id','receipt','ord','desc'];

        imagesModel.setQuery('CREATE TABLE IF NOT EXISTS imagesReceipts (id INTEGER PRIMARY KEY,receipt INTEGER,ord INTEGER,image TEXT)');
        imagesModel.tableName = 'imagesReceipts';
        imagesModel.fieldNames = ['id','receipt','ord','image'];

        mainApp.openMainPage();
    }

//    focus: true
    Keys.onReleased: {
        if (event.key == Qt.Key_Back) {
            event.accepted = true;
            mainApp.openMainPage();
        }
    }

    visible: true
}