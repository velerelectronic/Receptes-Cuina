import QtQuick 2.0
import "Storage.js" as Storage

Rectangle {
    id: receiptsWidget
    signal newReceipt (string name)
    signal showReceipt (int id)

    property alias searchString: textCercador.text

    Rectangle {
        id: cercador
        border.color: "black"
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 10
        height: 40
        radius: height / 2

        Timer {
            id: waitTimer
            interval: 500
            running: false
            onTriggered: cercador.updateList()
        }

        TextInput {
            id: textCercador
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            text: ''
            font.pixelSize: 16
            anchors.margins: parent.height / 4
            inputMethodHints: Qt.ImhNoPredictiveText

            onAccepted: {
                waitTimer.stop()
                cercador.updateList()
                focus = false
                focus = true
            }

            onTextChanged: {
                waitTimer.restart()
            }
        }

        function updateList() {
            Storage.listReceiptsWithFilter(receiptsModel,textCercador.text);
        }

    }

    ListModel {
        id: receiptsModel
    }

    ListView {
        id: receiptsList
        clip: true

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: cercador.bottom
        anchors.bottom: parent.bottom
        model: receiptsModel
        delegate: Rectangle {
            width: parent.width
//            height: 50
            clip: true
            gradient: Gradient {
                GradientStop { position: 0.9; color: "white" }
                GradientStop { position: 1.0; color: "black" }
            }

            Row {
                anchors.margins: 10
                anchors.left: parent.left
                anchors.right: parent.right
                height: name.height + desc.height
                Column {
                    Text {
                        text: name
                        font.bold: true
                        font.pointSize: 18
                    }
                    Text {
                        text: desc
                        font.pointSize: 12
                    }
                }
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (type=='create') {
                        receiptsWidget.newReceipt(receiptsWidget.searchString);
                    } else {
                        console.log('Id ' + id);
                        receiptsWidget.showReceipt(id);
                    }
                }
            }
        }
    }

    Component.onCompleted: Storage.listReceipts(receiptsModel)

}
