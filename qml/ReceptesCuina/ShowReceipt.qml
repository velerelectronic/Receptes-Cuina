import QtQuick 2.0
import QtQuick.Controls 1.0
import "Storage.js" as Storage


Rectangle {
    id: showReceipt
    property string receiptId: ''
    signal closeReceipt

    Flickable {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: boto.top
        contentWidth: width

        Rectangle {
            anchors.fill: parent
            Rectangle {
                id: nameRect
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
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
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: nameRect.bottom
                anchors.margins: 10
                height: receiptDesc.height

                color: 'yellow';
                Text {
                    id: receiptDesc
                    wrapMode: Text.WordWrap
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
