import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.1
import 'qrc:///core' as Core


Rectangle {
    id: showReceipt
    property string receiptId: ''
    signal closeReceipt

    property bool editMode: editButton.checked

    anchors.fill: parent

    Core.UseUnits { id: units }

    ColumnLayout {
        anchors.fill: parent

        Rectangle {
            anchors.margins: units.nailUnit
            Layout.fillWidth: true
            Layout.preferredHeight: units.fingerUnit

            RowLayout {
                anchors.fill: parent
                spacing: units.nailUnit
                Button {
                    id: editButton
                    Layout.fillHeight: true
                    anchors.margins: units.nailUnit
                    text: qsTr('Edita')
                    checkable: true
                    checked: false
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
                    visible: editMode
                    Layout.fillHeight: true
                    anchors.margins: units.nailUnit
                    text: qsTr('Elimina')
                }
            }
        }

        ListView {
            Layout.fillWidth: true
            Layout.preferredHeight: units.fingerUnit * 5
            model: imagesModel
            delegate: Image {
                source: model.image
                height: units.fingerUnit * 5
                width: units.fingerUnit * 5
            }
            Component.onCompleted: imagesModel.setReference('receipt',receiptId);
        }
        Button {
            text: qsTr('Nova imatge')
            visible: editMode
            Layout.fillWidth: true
            Layout.preferredHeight: (visible)?units.fingerUnit:0
            onClicked: {}
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
                            font.pixelSize: units.readUnit
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
                            var dades = receiptsModel.getObject(receiptId);
                            receiptName.text = dades.name;
                            receiptDesc.text = dades.desc;
                        }
                    }

                    CommonList {
                        id: ingr
                        caption: qsTr('Ingredients')
                        newelement: qsTr('Afegeix un altre ingredient')
                        model: ingredientsModel
                        visibleNewButton: editMode
                        delegate: ReceiptElement {
                            elementId: model.id
                            elementOrd: model.ord
                            elementDesc: model.desc
                            elementIndex: model.index
                            onRemoveElementRequested: {
                                ingredientsModel.removeObjectWithKeyValue(elementId);
                                ingredientsModel.select();
                            }
                            onSaveElementRequested: {
                                console.log('Desaaaa');
                                ingredientsModel.updateObject({id: elementId, desc: desc, receipt: showReceipt.receiptId, ord: elementIndex + 1});
                            }
                        }
                        onNewElementRequested: {
                            ingredientsModel.insertObject({desc: '', receipt: showReceipt.receiptId, ord: ingredientsModel.count+1});
                            ingredientsModel.select();
                        }
                        Component.onCompleted: {
                            ingredientsModel.setReference('receipt',receiptId);
                            ingredientsModel.select();
                        }
                    }

                    CommonList {
                        id: elab
                        caption: qsTr('Elaboració')
                        newelement: qsTr('Afegeix una altra passa')
                        model: stepsModel
                        visibleNewButton: editMode
                        delegate: ReceiptElement {
                            elementId: model.id
                            elementOrd: model.ord
                            elementDesc: model.desc
                            elementIndex: model.index
                            onRemoveElementRequested: {
                                stepsModel.removeObjectWithKeyValue(elementId);
                                stepsModel.select();
                            }
                            onSaveElementRequested: {
                                console.log('Desaaaa');
                                stepsModel.updateObject({id: elementId, desc: desc, receipt: showReceipt.receiptId, ord: elementIndex + 1});
                            }
                        }
                        onNewElementRequested: {
                            stepsModel.insertObject({desc: '', receipt: showReceipt.receiptId, ord: stepsModel.count+1});
                            stepsModel.select();
                        }
                        Component.onCompleted: {
                            stepsModel.setReference('receipt',receiptId);
                            stepsModel.select();
                        }
                    }

                }
            }
        }
    }
}
