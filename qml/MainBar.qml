import QtQuick 2.0
import 'qrc:///core' as Core

Rectangle {
    Core.UseUnits { id: units }
    signal goBack()

    Text {
        anchors {
            left: parent.left
            top: parent.top
            bottom: parent.bottom
            margins: units.nailUnit
        }
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: units.readUnit
        text: qsTr('< Enrere')
        MouseArea {
            anchors.fill: parent
            onClicked: goBack()
        }
    }
}

