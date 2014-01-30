import QtQuick 2.0
import QtQuick.Controls 1.0

// Element that represents:
// * a single ingredient
// * or a single step for a receipt

Rectangle {
    id: elementBox
    property alias elementDesc: desc.text
    property int elementId: 0
    property string elementType: ''
    property int elementOrd: 0
    property int elementIndex: 0

    signal createElement
    signal saveElement(string desc)
    signal changeElement(int elementId,string desc)
    signal removeElement(int elementId,int index)

    anchors.left: parent.left
    anchors.right: parent.right
    height: childrenRect.height
    anchors.margins: 40

    Text {
        id: ord
        text: (elementOrd==0 || type=='create') ? '' : elementOrd
        font.pointSize: 14
        font.bold: true
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.margins: 10
    }

    Text {
        id: desc
        text: elementDesc
        font.pointSize: 12
        anchors.top: parent.top
        anchors.left: ord.right
        anchors.right: parent.right
        anchors.margins: 10

        MouseArea {
            id: area
            anchors.fill: parent
            onClicked: {
                if (type=='create') {
                    createElement();
                    editBox.sourceComponent = newElement
//                    area.enabled = false
                } else {
                    changeElement(elementId);
                }
            }

            onPressAndHold: {
                if (type=='show') {
                    removeElement(elementId,elementIndex);
                }
            }

        }
/*
        PinchArea {
            id: pincharea
            anchors.fill: parent
            pinch.target: desc
            onPinchStarted: console.log('Pinch')
        }
        */
    }

    Loader {
        id: editBox
        anchors.top: desc.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: childrenRect.height
    }

    Component {
        id: blankObject

        Item {
            height: 0
        }
    }

    Component {
        id: newElement

        Rectangle {
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
                        elementBox.saveElement(desc.text)
                        editBox.sourceComponent = blankObject
                        area.enabled = true
                    }
                }
                Button {
                    text: 'Cancela'
                    onClicked: {
                        editBox.sourceComponent = blankObject
                        area.enabled = true;
                    }
                }
            }
        }
    }
}
