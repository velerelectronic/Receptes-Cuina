import QtQuick 2.0
import QtQuick.Controls 1.0

Rectangle {
    id: ingredientBox
    property alias ingredientDesc: label.text
    property int ingredientId: 0
    property string ingredientType: ''
    signal createIngredient
    signal saveIngredient(string desc)
    signal changeIngredient(int ingredientId,string desc)

    anchors.left: parent.left
    anchors.right: parent.right
    height: childrenRect.height
    anchors.margins: 10

    Text {
        id: label
        text: desc
        font.pointSize: 12
    }

    MouseArea {
        id: area
        anchors.fill: parent
        onClicked: {
            if (type=='create') {
                createIngredient();
//                newBox.asynchronous = false
                newBox.sourceComponent = newIngredient

                area.enabled = false
//                newBox.height = newBox.item.height
//                ingredientBox.height = ingredientBox.childrenRect.height
            } else {
                changeIngredient(ingredientId);
            }
        }
    }

    Loader {
        id: newBox
        anchors.top: label.bottom
        anchors.left: parent.left
        anchors.right: parent.right
    }

    Component {
        id: newIngredient

        Rectangle {
//            width: parent.width
            height: childrenRect.height

            TextArea {
                id: desc
                anchors.top: parent.top
                width: parent.width
                height: 100
                text: ''
                wrapMode: TextEdit.WordWrap
                font.pointSize: 16
            }

            Row {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: desc.bottom
                height: childrenRect.height
                Button {
                    text: 'Desa'
                    onClicked: {
                        ingredientBox.ingredientDesc = desc.text
                        ingredientBox.saveIngredient(desc.text)
                        newBox.sourceComponent = undefined;
                        area.enabled = true
                    }
                }
                Button {
                    text: 'Cancela'
                    onClicked: {
                        parent.parent.visible = false;
                        newBox.sourceComponent = undefined;
                        area.enabled = true;
                    }
                }
            }
        }
    }
}
