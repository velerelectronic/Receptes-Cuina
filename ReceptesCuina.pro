TEMPLATE = app

QT += \
    qml \
    quick \
    sql \
    multimedia

SOURCES += main.cpp \
    sqltablemodel.cpp \
    imagedata.cpp \
    databasebackup.cpp

RESOURCES += qml.qrc \
    core.qrc \
    images.qrc \
    icons.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS += \
    sqltablemodel.h \
    imagedata.h \
    databasebackup.h

OTHER_FILES += \
    android/AndroidManifest.xml
