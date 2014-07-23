TEMPLATE = app

QT += qml quick sql

SOURCES += main.cpp \
    sqltablemodel.cpp

RESOURCES += qml.qrc \
    core.qrc \
    images.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS += \
    sqltablemodel.h

OTHER_FILES += \
    android/AndroidManifest.xml
