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
        contentHeight: childrenRect.height
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
                height: childrenRect.height

                Rectangle {
                    id: nameRect
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.margins: 10
                    height: receiptName.height

                    color: 'yellow'
                    Text {
                        id: receiptName
                        anchors.left: parent.left
                        anchors.right: parent.right
                        wrapMode: Text.WordWrap
                    }
                }

                Rectangle {
                    id: descRect
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.margins: 10
                    height: receiptDesc.height

                    color: 'yellow';
                    Text {
                        id: receiptDesc
                        wrapMode: Text.WordWrap
                    }
                }
                RLabel {
                    id: labelIngredients
                    caption: qsTr('Ingredients')
                    anchors.left: parent.left
                    anchors.right: parent.right
                }



                ListView {
                    id: listIngredients
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: contentHeight
                    model: ListModel { id: ingredientsModel }
                    interactive: false
                    delegate: IngredientBox {
                        ingredientId: id
                        ingredientDesc: desc
                        ingredientType: type
                        onCreateIngredient: console.log('CreateIngredient');
//                        onChangeIngredient: console.log('Change ingredient '+ingredientId)
                        onSaveIngredient: Storage.saveNewIngredient(desc,showReceipt.receiptId);
                    }

                    Component.onCompleted: Storage.listIngredientsFromReceipt(receiptId,ingredientsModel)
                }

                RLabel {
                    caption: qsTr('Elaboració')
                    anchors.left: parent.left
                    anchors.right: parent.right
                }

                ListView {
                    id: listSteps
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: contentHeight
                    interactive: false
                    model: ListModel { id: stepsModel }

                    delegate: Row {
                        height: childrenRect.height
                        Text {
                            font.bold: true
                            font.pointSize: 14
                            color: "green"
                            text: (type=='show')?ord:''
                            // anchors.left: parent.left
                        }
                        Text {
                            id: stepsDesc
                            font.pointSize: 12
                            text: desc
                        }
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

    function fillReceipt(id) {
        receiptId = id;
        console.log('RI'+receiptId);
        var dades = Storage.getReceiptNameAndDesc(receiptId);
        receiptName.text = dades.name;
        receiptDesc.text = dades.desc;
    }

}
