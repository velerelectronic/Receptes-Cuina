import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtQuick.Window 2.0
import QtQuick.Controls 1.3

import 'qrc:///core' as Core

Window {
    id: mainApp

    width: Screen.desktopAvailableWidth
    height: Screen.desktopAvailableHeight

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

    StackView {
        id: pageStack
        anchors.fill: parent

        initialItem: Qt.resolvedUrl('ReceiptsList.qml')

        Connections {
            target: pageStack.currentItem
            ignoreUnknownSignals: true
            onNewReceipt: openSubPage('NewReceipt', {receiptName: name})
            onNoNewReceipt: pageStack.pop()
            onSaveReceiptRequested: {
                receiptsModel.insertObject({name: name, desc: desc});
                pageStack.pop();
            }
            onNoReceipt: pageStack.pop()
            onShowReceipt: openSubPage('ShowReceipt', {receiptId: id})
            onCloseReceipt: pageStack.pop()
            onBackup: openSubPage('Backup',{})
            onCloseBackup: pageStack.pop()
        }
    }

    function openSubPage(page,param) {
        pageStack.push({item: Qt.resolvedUrl(page + '.qml'), properties: param});
    }

    Component.onCompleted: {
        /*
        receiptsModel.setQuery('DROP TABLE receipts');
        ingredientsModel.setQuery('DROP TABLE ingredientsReceipts');
        stepsModel.setQuery('DROP TABLE stepsReceipts');
        imagesModel.setQuery('DROP TABLE imagesReceipts');
        */

        receiptsModel.setQuery('CREATE TABLE IF NOT EXISTS receipts (id INTEGER PRIMARY KEY, name TEXT, desc TEXT, image BLOB)');
        receiptsModel.tableName = 'receipts';
        receiptsModel.fieldNames = ['id', 'name', 'desc', 'image'];
        receiptsModel.setSort(1,Qt.AscendingOrder);

        ingredientsModel.setQuery('CREATE TABLE IF NOT EXISTS ingredientsReceipts (id INTEGER PRIMARY KEY,receipt INTEGER,ord INTEGER,desc TEXT)')
        ingredientsModel.tableName = 'ingredientsReceipts';
        ingredientsModel.fieldNames = ['id', 'receipt','ord','desc'];
        ingredientsModel.setSort(2,Qt.AscendingOrder);

        stepsModel.setQuery('CREATE TABLE IF NOT EXISTS stepsReceipts (id INTEGER PRIMARY KEY,receipt INTEGER,ord INTEGER,desc TEXT)');
        stepsModel.tableName = 'stepsReceipts';
        stepsModel.fieldNames = ['id','receipt','ord','desc'];
        stepsModel.setSort(2,Qt.AscendingOrder);

        imagesModel.setQuery('CREATE TABLE IF NOT EXISTS imagesReceipts (id INTEGER PRIMARY KEY,receipt INTEGER,ord INTEGER,image BLOB)');
        imagesModel.tableName = 'imagesReceipts';
        imagesModel.fieldNames = ['id','receipt','ord','image'];
        imagesModel.setSort(2,Qt.AscendingOrder);
    }

//    focus: true
    Keys.onReleased: {
        if (event.key == Qt.Key_Back) {
            event.accepted = true;
            pageStack.pop()
        }
    }

    visible: true
}
