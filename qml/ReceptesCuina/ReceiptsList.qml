import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.1
import "Storage.js" as Storage
import 'core' as Core


ColumnLayout {
    id: receiptsWidget
    anchors.fill: parent

    signal newReceipt (string name)
    signal showReceipt (int id)
    signal backup

    Core.BasicWidget {
        id: units
    }

    Rectangle {
        height: units.fingerUnit
        Layout.fillWidth: true

        RowLayout {
            anchors.fill: parent
            Button {
                Layout.fillHeight: true
                anchors.margins: units.nailUnit
                text: qsTr('Nova')
                onClicked: receiptsWidget.newReceipt(searchBox.text)
            }

            Core.SearchBox {
                id: searchBox
                Layout.fillWidth: true
                Layout.fillHeight: true
                anchors.margins: units.nailUnit
                onPerformSearch: Storage.listReceiptsWithFilter(receiptsModel,text)
            }
            Button {
                text: qsTr('Edita')
                Layout.fillHeight: true
            }
        }
        Component.onCompleted: console.log('Rectangle height ' + height + '-' + units.fingerUnit)
    }

    ListView {
        id: receiptsList
        clip: true

        Layout.fillWidth: true
        Layout.fillHeight: true
        anchors.margins: units.nailUnit

        model: ListModel { id: receiptsModel }

        delegate: Rectangle {
            width: parent.width
            height: units.fingerUnit * 2
            clip: true

            Rectangle {
                anchors.fill: parent
                opacity: 0.5

                gradient: Gradient {
                    GradientStop { position: 0.9; color: "white" }
                    GradientStop { position: 1.0; color: "black" }
                }
            }

            Row {
                id: rowReceipt
                anchors.margins: units.nailUnit
                height: childrenRect.height + 10
                z: 2
                // height: 100
                Column {
                    Text {
                        id: nameReceipt
                        text: (type=='show')? name + ' ' : desc
                        font.bold: true
                        font.pointSize: 18
                        wrapMode: Text.NoWrap
                        clip: true
                        opacity: 1
                    }
                    Text {
                        width: parent.width
                        text: desc.replace(/[\n\r]/g,' ') + ' '
                        font.pointSize: 12
                        wrapMode: Text.Wrap
                        height: nameReceipt.height
                        clip: true
                        opacity: 1
                    }
                }
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (type=='create') {
                        receiptsWidget.newReceipt(name);
                    } else {
                        receiptsWidget.showReceipt(id);
                    }
                }
            }
        }
        Image {
            id: mainImage
            source: 'res/cooking-pot-159470_1280.png'
            width: parent.height / 2
            height: parent.height / 2
            fillMode: Image.PreserveAspectFit
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.margins: parent.height / 8
        }
    }

    Rectangle {
        id: backupArea
        Layout.fillWidth:true
        height: units.fingerUnit

        Text {
            text: 'Backup'
            anchors.centerIn: parent
        }

        MouseArea {
            anchors.fill: parent
            onClicked: receiptsWidget.backup()
        }
    }

    Component.onCompleted: Storage.listReceipts(receiptsModel)

}
