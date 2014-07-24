import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.1
import 'qrc:///core' as Core

// Element that represents:
// * a single ingredient
// * or a single step for a receipt

Rectangle {
    id: elementBox
    property alias elementDesc: desc.text
    property int elementId: -1
    property int elementOrd: 0
    property int elementIndex: -1

    signal createElementRequested
    signal saveElementRequested(int elementId,string desc,int index)
    signal changeElementRequested(int elementId,string desc,int index)
    signal removeElementRequested(int elementId,int index)

    width: parent.width
    height: mainLayout.height + 2 * mainLayout.anchors.margins

    Core.UseUnits { id: units }

    RowLayout {
        id: mainLayout
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: units.nailUnit
        height: Math.max(ord.height, desc.height, units.fingerUnit)
        spacing: units.nailUnit

        Text {
            id: ord
            Layout.preferredWidth: units.fingerUnit
            Layout.preferredHeight: contentHeight
            verticalAlignment: Text.AlignTop
            font.pixelSize: units.readUnit
            font.bold: true
            text: elementOrd
        }

        Text {
            id: desc
            Layout.fillWidth: true
            Layout.preferredHeight: Math.max(contentHeight,editBox.height)
            verticalAlignment: Text.AlignTop
            font.pixelSize: units.readUnit
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            text: elementDesc

            Loader {
                id: editBox
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                height: 0
                asynchronous: false
                visible: false

                Connections {
                    target: editBox.item
                    ignoreUnknownSignals: true
                    onCloseEditor: {
                        editBox.visible = false;
                        editBox.sourceComponent = undefined;
                        editBox.height = 0;
                    }
                }
            }
        }
    }
    MouseArea {
        id: area
        enabled: !editBox.visible
        anchors.fill: parent
        onClicked: {
            console.log('Canviar');
            changeElementRequested(elementId,elementDesc,elementIndex); // signaling
            editBox.sourceComponent = newElement;
            editBox.item.newDesc = elementDesc;
            editBox.height = units.fingerUnit * 5;
            editBox.visible = true;
        }

        onPressAndHold: {
            removeElementRequested(elementId,elementIndex);
        }
    }


    Component {
        id: newElement

        Rectangle {
            id: rectElement
//            anchors.fill: parent

            property alias newDesc: desc.text
            signal closeEditor

            ColumnLayout {
                anchors.fill: parent
                TextArea {
                    id: desc
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    text: ''
                    focus: true
                    wrapMode: TextEdit.WrapAtWordBoundaryOrAnywhere
                    font.pixelSize: units.readUnit
                    inputMethodHints: Qt.ImhNoPredictiveText
                }
                RowLayout {
                    Layout.fillWidth: true
                    Layout.preferredHeight: childrenRect.height
                    Button {
                        height: units.fingerUnit
                        text: 'Desa'
                        onClicked: {
                            elementBox.saveElementRequested(elementId,desc.text,elementIndex)
                            rectElement.closeEditor();
                        }
                    }
                    Button {
                        height: units.fingerUnit
                        text: 'Cancela'
                        onClicked: {
                            rectElement.closeEditor();
                        }
                    }
                }
            }

            Component.onCompleted: desc.forceActiveFocus()
        }
    }    
}
