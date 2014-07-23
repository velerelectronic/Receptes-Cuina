import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.1
import QtGraphicalEffects 1.0

import "Storage.js" as Storage
import 'qrc:///core' as Core

Rectangle {
    id: receiptsWidget

    signal newReceipt (string name)
    signal showReceipt (int id)
    signal backup


    Core.UseUnits {
        id: units
    }

    Item {
        id: buttons
        anchors.top: parent.top
        height: units.fingerUnit
        anchors.left: parent.left
        anchors.right: parent.right

        RowLayout {
            anchors.fill: parent
            Button {
                Layout.fillHeight: true
                anchors.margins: units.nailUnit
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
                anchors.margins: units.nailUnit
                onPerformSearch: Storage.listReceiptsWithFilter(receiptsModel,text)
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

    ListView {
        id: receiptsList
        clip: true

        z: 2

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: editBox.bottom
        anchors.bottom: parent.bottom
        anchors.margins: units.nailUnit

        model: receiptsModel

        delegate: Item {
            width: parent.width
            height: Math.min(units.fingerUnit * 2, itemRect.height) + 2 * units.nailUnit
            z: 5
//                opacity: 0.5

            Rectangle {
                anchors.fill: itemRect
                color: 'white'
                opacity: 0.5
            }

            Rectangle {
                id: itemRect
                border.color: 'black'
                color: 'transparent'
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: units.nailUnit
                height: receiptColumn.height + units.nailUnit * 2
                z: 5

                ColumnLayout {
                    id: receiptColumn
                    height: nameReceipt.height + descReceipt.height + units.nailUnit
                    anchors.margins: units.nailUnit
                    spacing: units.nailUnit

                    Text {
                        id: nameReceipt
                        Layout.preferredHeight: height
                        height: contentHeight
                        Layout.fillWidth: true
                        text: name
                        font.bold: true
                        font.pixelSize: units.readUnit
                        wrapMode: Text.NoWrap
                    }
                    Text {
                        id: descReceipt
                        Layout.preferredHeight: height
                        height: contentHeight
                        Layout.fillWidth: true
                        text: desc.replace(/[\n\r]/g,' ') + ' '
                        font.pixelSize: units.readUnit
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    }
                }

                Image {
                    anchors.fill: parent
                    source: (model.image)?model.image:''
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
        // Storage.listReceipts(receiptsModel)
    }
}

