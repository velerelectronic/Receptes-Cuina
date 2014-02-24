import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.1
import 'core' as Core
import "Storage.js" as Storage


Rectangle {
    id: showReceipt
    property string receiptId: ''
    signal closeReceipt

    anchors.fill: parent

    Core.BasicWidget { id: units }

    ColumnLayout {
        anchors.fill: parent
        Rectangle {
            anchors.margins: units.nailUnit
            Layout.fillWidth: true
            Layout.preferredHeight: units.fingerUnit
            RowLayout {
                anchors.fill: parent
                Button {
                    id: editButton
                    Layout.fillHeight: true
                    anchors.margins: units.nailUnit
                    text: qsTr('Edita')
                    checkable: true
                    checked: false
                    onClicked: {
                        deleteButton.visible = checked
                        ingr.visibleNewButton = checked
                        elab.visibleNewButton = checked
                    }
                }

                Button {
                    Layout.fillHeight: true
                    anchors.margins: units.nailUnit
                    text: qsTr('Torna')
                    onClicked: showReceipt.closeReceipt()
                }

                Item {
                    Layout.fillWidth: true
                }

                Button {
                    id: deleteButton
                    visible: false
                    Layout.fillHeight: true
                    anchors.margins: units.nailUnit
                    text: qsTr('Elimina')
                }
            }
        }

        Flickable {
            id: flickarea
            Layout.fillWidth: true
            Layout.fillHeight: true
            anchors.margins: units.nailUnit
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
                    height: childrenRect.height + units.nailUnit * 2

                    Rectangle {
                        id: dadesGenerals
                        color: '#99ff99'
                        border.color: 'green'
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.margins: units.nailUnit
                        Layout.preferredHeight: height
                        height: childrenRect.height + units.nailUnit * 2

                        // Print the name
                        Text {
                            id: receiptName
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.top: parent.top
                            anchors.margins: units.nailUnit
                            wrapMode: Text.WordWrap
                            font.pixelSize: units.fingerUnit
                            font.bold: true
                        }

                        // Print the contents
                        Text {
                            id: receiptDesc
                            anchors.top: receiptName.bottom
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.margins: units.nailUnit
                            wrapMode: Text.WordWrap
                            font.pixelSize: units.nailUnit * 2
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
                        newelement: qsTr('Afegeix un altre ingredient')
                        model: ListModel { id: ingredientsModel }
                        delegate: ReceiptElement {
                            elementId: model.id
                            elementOrd: model.ord
                            elementDesc: model.desc
                            elementType: model.type
                            elementIndex: index
                            onRemoveElementRequested: Storage.removeIngredient(elementId,showReceipt.receiptId,ingredientsModel,elementIndex)
                            onSaveElementRequested: Storage.saveNewIngredient(elementId,desc,showReceipt.receiptId,ingredientsModel,elementIndex)
                        }
                        onNewElementRequested: Storage.saveNewIngredient(-1,'',showReceipt.receiptId,ingredientsModel,-1)
                        Component.onCompleted: Storage.listIngredientsFromReceipt(receiptId,ingredientsModel)
                    }

                    CommonList {
                        id: elab
                        caption: qsTr('Elaboració')
                        newelement: qsTr('Afegeix una altra passa')
                        model: ListModel { id: stepsModel }
                        delegate: ReceiptElement {
                            elementId: model.id
                            elementOrd: model.ord
                            elementDesc: model.desc
                            elementType: model.type
                            elementIndex: index
                            onRemoveElementRequested: Storage.removeStep(elementId,showReceipt.receiptId,stepsModel,elementIndex)
                            onSaveElementRequested: Storage.saveNewStep(elementId,desc,showReceipt.receiptId,stepsModel,elementIndex)
                        }
                        onNewElementRequested: Storage.saveNewStep(-1,'',showReceipt.receiptId,stepsModel,-1)
                        Component.onCompleted: Storage.listStepsFromReceipt(receiptId,stepsModel)
                    }

                }
            }
        }
    }
}
