import QtQuick 2.2
import QtQuick.Controls 1.1


Rectangle {
    property alias model: photoList.model
    property bool editMode: false
    signal getNewPhoto
    signal processPhoto(int index,string photo)

    ListView {
        id: photoList
        anchors.top: parent.top
        anchors.bottom: newImageButton.top
        anchors.left: parent.left
        anchors.right: parent.right
        orientation: ListView.Horizontal

        delegate: Item {
            height: photoList.height
            width: photoList.height
            Image {
                source: model.image
                anchors.fill: parent
                anchors.margins: units.nailUnit
                fillMode: Image.PreserveAspectFit
                MouseArea {
                    anchors.fill: parent
                    onPressAndHold: processPhoto(model.index,model.image)
                }
            }
        }
    }
    Button {
        id: newImageButton
        text: qsTr('Nova imatge')
        visible: editMode
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: (visible)?units.fingerUnit:0
        onClicked: getNewPhoto()
    }

}
