import QtQuick 2.0
import "Storage.js" as Storage

Rectangle {
    id: receiptsWidget
    signal newReceipt (string name)
    signal showReceipt (int id)
    signal backup

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

    ListModel {
        id: receiptsModel
    }

    ListView {
        id: receiptsList
        clip: true

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: cercador.bottom
        anchors.bottom: backupArea.top
        anchors.margins: 10

        model: receiptsModel
        delegate: Rectangle {
            width: parent.width
            height: rowReceipt.height
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
                anchors.margins: 10
                height: childrenRect.height + 10
                z: 2
                // height: 100
                Column {
                    Text {
                        id: nameReceipt
                        text: name + ' '
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
                        receiptsWidget.newReceipt(receiptsWidget.searchString);
                    } else {
                        receiptsWidget.showReceipt(id);
                    }
                }
            }
        }
    }

    Rectangle {
        id: backupArea
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 50

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
