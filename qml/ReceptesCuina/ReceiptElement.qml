import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.1
import 'core' as Core

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

    signal createElementRequested
    signal saveElementRequested(int elementId,string desc,int index)
    signal changeElementRequested(int elementId,string desc,int index)
    signal removeElementRequested(int elementId,int index)

    anchors.left: parent.left
    anchors.right: parent.right
    height: childrenRect.height
    anchors.margins: units.fingerUnit

    Core.BasicWidget { id: units }

    RowLayout {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: childrenRect.height

        Text {
            id: ord
            text: (elementOrd==0 || type=='create') ? '' : elementOrd
            font.pixelSize: units.fingerUnit
            font.bold: true
            anchors.margins: units.nailUnit
            height: paintedHeight
        }

        Text {
            id: desc
            text: elementDesc
            font.pixelSize: units.fingerUnit
            Layout.fillWidth: true
            anchors.margins: units.nailUnit
            height: paintedHeight
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere

            MouseArea {
                id: area
                anchors.fill: parent
                onClicked: {
                    if (type=='create') {
                        createElementRequested(); // signaling
                        editBox.sourceComponent = newElement
                        editBox.visible = true
                    } else {
                        changeElementRequested(elementId,elementDesc,elementIndex); // signaling
                        desc.visible = false
                        editBox.sourceComponent = newElement
                        editBox.item.newDesc = elementDesc
                        editBox.visible = true
                    }
                }

                onPressAndHold: {
                    if (type=='show') {
                        removeElementRequested(elementId,elementIndex);
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
            Layout.fillWidth: true
            height: childrenRect.height
            Connections {
                target: editBox.item
                ignoreUnknownSignals: true
                onCloseEditor: {
                    editBox.visible = false;
                    editBox.sourceComponent = blankObject;
                    desc.visible = true
                }
            }
        }
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
            id: rectElement
            height: childrenRect.height
            property alias newDesc: desc.text
            signal closeEditor

            TextArea {
                id: desc
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: units.fingerUnit * 2
                text: ''
                focus: true
                wrapMode: TextEdit.WrapAtWordBoundaryOrAnywhere
                font.pointSize: units.fingerUnit
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
                        elementBox.saveElementRequested(elementId,desc.text,elementIndex)
                        rectElement.closeEditor();
                    }
                }
                Button {
                    text: 'Cancela'
                    onClicked: {
                        rectElement.closeEditor();
                    }
                }
            }

            Component.onCompleted: desc.forceActiveFocus()
        }
    }    
}
