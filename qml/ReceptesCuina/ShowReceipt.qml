import QtQuick 2.0
import QtQuick.Controls 1.0
import "Storage.js" as Storage


Rectangle {
    id: showReceipt
    property string receiptId: ''
    signal closeReceipt

    anchors.fill: parent

    Flickable {
        id: flickarea
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: boto.top
        contentWidth: width
        contentHeight: contentItem.childrenRect.height
        interactive: true
        clip: true

        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            height: childrenRect.height

            Column {
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                spacing: 10
//                height: childrenRect.height

                Rectangle {
                    id: dadesGenerals
                    color: '#99ff99'
                    border.color: 'green'
                    anchors.left: parent.left
                    anchors.right: parent.right
//                    anchors.top: parent.top
                    anchors.margins: 20
                    height: childrenRect.height + 20

                    Text {
                        id: receiptName
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.margins: 10
                        wrapMode: Text.WordWrap
                        font.pointSize: 20
                        font.bold: true
                    }

                    Text {
                        id: receiptDesc
                        anchors.top: receiptName.bottom
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.margins: 10
                        wrapMode: Text.WordWrap
                        font.pointSize: 18
                    }
                    Component.onCompleted: {
                        var dades = Storage.getReceiptNameAndDesc(receiptId);
                        receiptName.text = dades.name;
                        receiptDesc.text = dades.desc;
                    }
                }

                CommonList {
                    id: ingr
                    caption: qsTr('Ingredients')
                    model: ListModel { id: ingredientsModel }
                    delegate: ReceiptElement {
                        elementId: id
                        elementDesc: desc
                        elementType: type
                        elementIndex: index
                        onCreateElement: console.log('Create Ingredient')
                        onRemoveElement: Storage.removeIngredient(elementId,showReceipt.receiptId,ingredientsModel,elementIndex)
                        onSaveElement: Storage.saveNewIngredient(desc,showReceipt.receiptId,ingredientsModel)
                    }
                    Component.onCompleted: Storage.listIngredientsFromReceipt(receiptId,ingredientsModel)
                }

                CommonList {
                    id: elab
                    caption: qsTr('Elaboració')
                    model: ListModel { id: stepsModel }
                    delegate: ReceiptElement {
                        elementId: id
                        elementOrd: ord
                        elementDesc: desc
                        elementType: type
                        elementIndex: index
                        onCreateElement: console.log('Create Step')
                        onRemoveElement: Storage.removeStep(elementId,showReceipt.receiptId,stepsModel,elementIndex)
                        onSaveElement: Storage.saveNewStep(desc,showReceipt.receiptId,stepsModel)
                    }
                    Component.onCompleted: Storage.listStepsFromReceipt(receiptId,stepsModel)
                }
            }
        }
    }

    Button {
        id: boto
        anchors.bottom: parent.bottom
        text: 'Torna'
        onClicked: showReceipt.closeReceipt()
    }

    Component.onCompleted: {
    }

}
