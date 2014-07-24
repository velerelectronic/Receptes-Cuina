import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.1
import Qt.labs.folderlistmodel 2.1
import 'qrc:///core' as Core
import PersonalTypes 1.0

Item {
    id: backup

    signal closeBackup

    Core.UseUnits {
        id: units
    }

    DatabaseBackup {
        id: fileDb
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: units.nailUnit * 2

        Text {
            id: exportLabel
            text: qsTr('Exporta')
            Layout.fillWidth: true
            Layout.preferredHeight: contentHeight
            anchors.margins: units.nailUnit
        }
        TextArea {
            id: exportContents
            Layout.fillWidth: true
            Layout.preferredHeight: units.fingerUnit * 2
            focus: true
            wrapMode: TextEdit.WrapAnywhere
            readOnly: true
            font.pointSize: 12
            inputMethodHints: Qt.ImhNoPredictiveText
        }
        RowLayout {
            id: exportButtonsRow
            Layout.fillWidth: true
            Layout.preferredHeight: units.fingerUnit

            Button {
                text: qsTr('Exporta a JSON')
                onClicked: exportContents.text = fileDb.saveContents(fileDb.homePath)
            }

            Button {
                text: qsTr('Copia al clipboard')
                onClicked: {
                    exportContents.selectAll()
                    exportContents.copy()
                }
            }

            Button {
                text: qsTr('Desa a fitxer')
                onClicked: {
                    if (fileDb.saveContents(fileDb.homePath + "/database-")) {
                        exportContents.readOnly = false;
                        exportContents.text = 'Desat';
                        exportContents.readOnly = true;
                    } else {
                        exportContents.readOnly = false;
                        exportContents.text = 'No desat';
                        exportContents.readOnly = true;
                    }
                }
            }
        }
        Text {
            id: importLabel
            text: qsTr('Importa')
            Layout.fillWidth: true
            Layout.preferredHeight: contentHeight
        }

        ListView {
            Layout.fillHeight: true
            Layout.fillWidth: true
            model: folderList
            clip: true
            delegate: Rectangle {
                border.color: 'black'
                color: 'white'
                height: Math.max(units.fingerUnit * 2,file.height)
                width: parent.width

                RowLayout {
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: Math.max(file.height,details.height)
                    Text {
                        id: file
                        Layout.fillWidth: true
                        Layout.preferredHeight: contentHeight
                        Layout.alignment: Text.AlignVCenter
                        verticalAlignment: Text.AlignVCenter
                        text: model.fileName
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    }
                    Text {
                        id: details
                        Layout.preferredWidth: contentWidth
                        Layout.fillHeight: true
                        verticalAlignment: Text.AlignVCenter
                        text: model.fileModified
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (!fileDb.readContents(fileDb.homePath + '/' + model.fileName))
                            console.log(model.fileURL);
                    }
                }
            }
        }

        RowLayout {
            id: importButtonsRow
            Layout.fillWidth: true
            Layout.preferredHeight: units.fingerUnit

            Button {
                text: qsTr('Enganxa del clipboard')
                onClicked: importContents.paste()
            }

        }

        Button {
            text: qsTr('Torna')
            Layout.preferredHeight:  units.fingerUnit
            Layout.fillWidth: true
            onClicked: backup.closeBackup()
        }


    }
    FolderListModel {
        id: folderList
        folder: 'file://' + fileDb.homePath
        sortField: FolderListModel.Name
        // nameFilters: ['*.backup']
        showDirs: false
        showFiles: true
    }
}
