import QtQuick 2.0
import QtQuick.Controls 1.0
import "Storage.js" as Storage

Rectangle {
    id: backup
    anchors.fill: parent
    anchors.margins: 20

    signal closeBackup

    Item {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: backbutton.top
        anchors.margins: 10

        Item {
            id: exportArea
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.verticalCenter
            Text {
                id: exportLabel
                text: qsTr('Exporta')
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.margins: 10
            }
            TextArea {
                id: exportContents
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: exportLabel.bottom
                anchors.bottom: exportButton.top
                focus: true
                wrapMode: TextEdit.WrapAnywhere
                readOnly: true
                font.pointSize: 12
                inputMethodHints: Qt.ImhNoPredictiveText
            }
            Button {
                id: exportButton
                text: 'Exporta'
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                onClicked: exportContents.text = Storage.exportDatabaseToText()
            }
        }
        Item {
            id: importArea
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.verticalCenter
            anchors.bottom: parent.bottom
            Text {
                id: importLabel
                text: qsTr('Importa')
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
            }
            TextArea {
                id: importContents
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: importLabel.bottom
                anchors.bottom: importButton.top
                focus: true
                wrapMode: TextEdit.WrapAnywhere
                readOnly: false
                font.pointSize: 12
                inputMethodHints: Qt.ImhNoPredictiveText
            }
            Button {
                id: importButton
                text: 'Importa'
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                onClicked: {
                    var error = Storage.importDatabaseFromText(importContents.text);
                    if (error != '')
                        importContents.text = 'Error '
                    else {
                        importContents.text = 'OK'
                        text = 'Inserides!'
                    }
                }
            }
        }

    }

    Button {
        id: backbutton
        text: 'Torna'
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        onClicked: backup.closeBackup()
    }
}
