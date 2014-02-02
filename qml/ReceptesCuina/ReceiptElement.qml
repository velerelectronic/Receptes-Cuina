import QtQuick 2.0
import QtQuick.Controls 1.0

// Element that represents:
// * a single ingredient
// * or a single step for a receipt

Rectangle {
    id: elementBox
    property alias elementDesc: desc.text
    property int elementId: -1
    property string elementType: ''
    property int elementOrd: 0
    property int elementIndex: -1

    signal createElement
    signal saveElement(int elementId,string desc,int index)
    signal changeElement(int elementId,string desc,int index)
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
        height: paintedHeight + 10
    }

    Text {
        id: desc
        text: elementDesc
        font.pointSize: 12
        anchors.top: parent.top
        anchors.left: ord.right
        anchors.right: parent.right
        anchors.margins: 10
        height: paintedHeight + 10
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere

        MouseArea {
            id: area
            anchors.fill: parent
            onClicked: {
                if (type=='create') {
                    createElement();
                    editBox.sourceComponent = newElement
//                    area.enabled = false
                } else {
                    changeElement(elementId,elementDesc,elementIndex);
                    editBox.sourceComponent = newElement
                    editBox.item.newDesc = elementDesc
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
            property alias newDesc: desc.text

            TextArea {
                id: desc
                anchors.top: parent.top
                width: parent.width
                height: 100
                text: ''
                focus: true
                wrapMode: TextEdit.WrapAtWordBoundaryOrAnywhere
                font.pointSize: 16
                inputMethodHints: Qt.ImhNoPredictiveText
            }

            Row {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: desc.bottom
                height: childrenRect.height
                Button {
                    text: 'Desa'
                    onClicked: {
                        elementBox.saveElement(elementId,desc.text,elementIndex)
                        editBox.sourceComponent = blankObject
                    }
                }
                Button {
                    text: 'Cancela'
                    onClicked: {
                        editBox.sourceComponent = blankObject
//                        area.enabled = true;
                    }
                }
            }
            Component.onCompleted: desc.forceActiveFocus()
        }
    }
}
