import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.1
import "Storage.js" as Storage
import 'qrc:///core' as Core

Rectangle {
    id: newReceipt
    anchors.fill: parent

    property alias receiptName: receiptName.text
    signal savedReceipt(int receiptId)
    signal noNewReceipt()

    Core.UseUnits { id: units }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: units.nailUnit
        spacing: units.nailUnit

        Text {
            Layout.fillWidth: true
            font.bold: true
            font.pixelSize: units.readUnit
            text: qsTr('Nom de la recepta')
        }
        Rectangle {
            Layout.preferredHeight: childrenRect.height
            Layout.fillWidth: true
            border.color: "black"

            TextField {
                id: receiptName
                focus: true
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                font.pixelSize: units.readUnit
                inputMethodHints: Qt.ImhNoPredictiveText
                text: ''
            }
        }
        Text {
            Layout.fillWidth: true
            font.bold: true
            font.pixelSize: units.readUnit
            text: qsTr('Descripció')
        }
        Rectangle {
            Layout.fillHeight: true
            Layout.fillWidth: true
            border.color: "black"

            TextArea {
                id: receiptDesc
                anchors.fill: parent

                wrapMode: TextEdit.WordWrap
                font.pixelSize: units.readUnit
                inputMethodHints: Qt.ImhNoPredictiveText
                text: ''
            }
        }
        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: childrenRect.height
            spacing: units.nailUnit
            Button {
                Layout.preferredHeight: units.fingerUnit
                text: qsTr('Desa')
                onClicked: newReceipt.savedReceipt(Storage.saveNewReceipt(receiptName.text,receiptDesc.text))
            }
            Button {
                Layout.preferredHeight: units.fingerUnit
                text: qsTr('Cancela')
                onClicked: newReceipt.noNewReceipt()
            }
        }
    }
}
