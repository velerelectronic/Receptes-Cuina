import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.1
import QtGraphicalEffects 1.0
import 'qrc:///core' as Core

Rectangle {
    id: receiptsWidget

    signal newReceipt (string name)
    signal showReceipt (int id)
    signal backup


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
    }

    Item {
        id: buttons
        anchors.top: title.bottom
        height: units.fingerUnit
        anchors.left: parent.left
        anchors.right: parent.right

        RowLayout {
            anchors.fill: parent
            spacing: units.nailUnit
            Button {
                Layout.fillHeight: true
                text: qsTr('Nova')
                onClicked: receiptsWidget.newReceipt(searchBox.text)
            }
            Button {
                id: editButton
                text: qsTr('Edita')
                checkable: true
                checked: false
                Layout.fillHeight: true
                onClicked: editBox.state = (checked)?'show':'hidden'
            }

            Core.SearchBox {
                id: searchBox
                Layout.fillWidth: true
                Layout.fillHeight: true
                onPerformSearch: receiptsModel.filterFields(['name','desc'],searchBox.text)
            }

            Button {
                id: placesButton
                Layout.fillHeight: true
                text: qsTr('Llocs')
                menu: Menu {
                    title: qsTr('Llocs on cercar')
                    MenuItem {
                        id: titlesOption
                        checkable: true
                        checked: true
                        text: qsTr('Als titols')
                    }
                    MenuItem {
                        id: descriptionsOption
                        checkable: true
                        text: qsTr('A les descripcions')
                    }
                    MenuItem {
                        id: ingredientsOption
                        checkable: true
                        text: qsTr('Als ingredients')
                    }
                    MenuItem {
                        id: stepsOption
                        checkable: true
                        text: qsTr('A les passes')
                    }
                }
            }
            Button {
                text: qsTr('Backup')
                onClicked: receiptsWidget.backup()
            }
        }
        Component.onCompleted: console.log('Rectangle height ' + height + '-' + units.fingerUnit)
    }

    Core.EditBox {
        id: editBox
        maxHeight: units.fingerUnit
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: buttons.bottom

        state: (editButton.checked)?'show':'hidden'
        onCancel: {
            editButton.checked = false
        } // annotationsList.unselectAll()
        onDeleteItems: {
            editButton.checked = false
            // annotationsList.deleteSelected()
        }
    }

    Image {
        id: mainImage
        z: 1
        source: 'qrc:///images/cooking-pot-159470_1280.png'
        fillMode: Image.PreserveAspectFit
        anchors.fill: receiptsList
        anchors.margins: parent.height / 8
    }

    GridView {
        id: receiptsList
        clip: true

        z: 2

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: editBox.bottom
        anchors.bottom: parent.bottom
        anchors.margins: units.nailUnit

        model: receiptsModel

        cellHeight: width / 4
        cellWidth: width / 3

        delegate: Item {
            width: receiptsList.cellWidth
            height: receiptsList.cellHeight
//            width: parent.width
//            height: Math.min(units.fingerUnit * 2, itemRect.height) + 2 * units.nailUnit
            z: 5
//                opacity: 0.5

            Rectangle {
                id: itemRect
                border.color: 'black'
                color: 'white'
                anchors.fill: parent
                anchors.margins: units.nailUnit
                z: 5

                Image {
                    anchors.fill: parent
                    source: (model.image)?model.image:''
                }

                Rectangle {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.margins: 1
                    height: receiptColumn.height + 2 * units.nailUnit

                    color: 'white'
                    opacity: 0.7
                }
                ColumnLayout {
                    id: receiptColumn
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    height: nameReceipt.height + descReceipt.height + spacing
                    anchors.margins: units.nailUnit
                    spacing: units.nailUnit

                    Text {
                        id: nameReceipt
                        Layout.preferredHeight: contentHeight
                        Layout.fillWidth: true
                        text: name
                        font.bold: true
                        font.pixelSize: units.readUnit
                        wrapMode: Text.NoWrap
                    }
                    Text {
                        id: descReceipt
                        Layout.preferredHeight: contentHeight
                        Layout.fillWidth: true
                        text: desc.replace(/[\n\r]/g,' ') + ' '
                        font.pixelSize: units.readUnit
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    }
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: receiptsWidget.showReceipt(id)
            }
        }
    }

    Component.onCompleted: {
        receiptsModel.select();
    }
}

