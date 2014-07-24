import QtQuick 2.2
import QtMultimedia 5.2
import PersonalTypes 1.0
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.1
import 'qrc:///core' as Core

Rectangle {
    signal saveImage(string contents)
    signal cancelImage

    Core.UseUnits { id: units }

    Camera {
        id: camera
        captureMode: Camera.CaptureStillImage
        imageCapture {
            onImageSaved: {
                console.log(path);
                imageData.source = path;
            }
        }
    }

    VideoOutput {
        anchors.fill: parent
        source: camera
        focus: visible
        autoOrientation: true

        MouseArea {
            id: shootArea
            enabled: imageFromCamera.source == ''
            anchors.fill: parent
            onClicked: camera.imageCapture.capture()
        }
    }

    ImageData {
        id: imageData
        onSourceChanged: {
            imageFromCamera.source = dataURL;
        }
    }

    Image {
        id: imageFromCamera
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        RowLayout {
            visible: imageFromCamera.source != ''
            anchors.fill: parent
            spacing: units.nailUnit
            Item {
                Layout.fillWidth: true
            }

            Button {
                text: qsTr('Accepta')
                onClicked: saveImage(imageFromCamera.source)
            }
            Button {
                text: qsTr('Cancela')
                onClicked: cancelImage()
            }
            Button {
                text: qsTr('Torna a fer-la')
                onClicked: imageFromCamera.source = ''
            }
            Item {
                Layout.fillWidth: true
            }
        }
    }
}
