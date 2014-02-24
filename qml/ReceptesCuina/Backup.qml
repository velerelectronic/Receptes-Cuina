import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.1
import 'core' as Core
import "Storage.js" as Storage

ColumnLayout {
    id: backup
    anchors.fill: parent
    anchors.margins: units.nailUnit * 2

    signal closeBackup

    Core.BasicWidget {
        id: units
    }

    Rectangle {
        Layout.fillHeight: true
        Layout.fillWidth: true

        anchors.margins: units.nailUnit
        color: 'yellow'

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: units.nailUnit
            Text {
                id: exportLabel
                text: qsTr('Exporta')
                Layout.fillWidth: true
                anchors.margins: units.nailUnit
            }
            TextArea {
                id: exportContents
                Layout.fillWidth: true
                Layout.fillHeight: true
                focus: true
                wrapMode: TextEdit.WrapAnywhere
                readOnly: true
                font.pointSize: 12
                inputMethodHints: Qt.ImhNoPredictiveText
            }
            RowLayout {
                id: exportButtonsRow
                height: units.fingerUnit

                Button {
                    text: qsTr('Exporta a JSON')
                    onClicked: exportContents.text = Storage.exportDatabaseToText()
                }

                Button {
                    text: qsTr('Copia al clipboard')
                    onClicked: {
                        exportContents.selectAll()
                        exportContents.copy()
                    }
                }
            }
            Text {
                id: importLabel
                text: qsTr('Importa')
                Layout.fillWidth: true
            }
            TextArea {
                id: importContents
                Layout.fillWidth: true
                Layout.fillHeight: true
                focus: true
                wrapMode: TextEdit.WrapAnywhere
                readOnly: false
                font.pointSize: 12
                inputMethodHints: Qt.ImhNoPredictiveText
            }
            RowLayout {
                id: importButtonsRow
                height: units.fingerUnit

                Button {
                    text: qsTr('Enganxa del clipboard')
                    onClicked: importContents.paste()
                }

                Button {
                    text: qsTr('Importa des de JSON')
                    onClicked: {
                        var error = Storage.importDatabaseFromText(importContents.text);
                        if (error != '')
                            importContents.text = error
                        else {
                            importContents.text = 'OK'
                            text = qsTr('Inserides!')
                        }
                    }
                }
            }

        }
    }

    Button {
        text: qsTr('Torna')
        height: units.fingerUnit
        Layout.fillWidth: true
        onClicked: backup.closeBackup()
    }
}
