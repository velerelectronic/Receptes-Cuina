import QtQuick 2.0

Rectangle {
    property alias caption: inner.text
    width: childrenRect.width
    height: childrenRect.height
    Text {
        id: inner
        font.bold: true
    }
}
