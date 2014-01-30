#include <QtGui/QGuiApplication>
#include "qtquick2applicationviewer.h"
#include <QQmlEngine>
#include <QDebug>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    app.setApplicationName("Receptes de cuina");
    app.setOrganizationName("joanmiquelpayerascrespi");
    app.setApplicationVersion("1.0");

    QtQuick2ApplicationViewer viewer;

    viewer.setMainQmlFile(QStringLiteral("qml/ReceptesCuina/main.qml"));

    QString str = (viewer.engine())->offlineStoragePath();
    qDebug() << QString("----->") << str << app.applicationVersion();

    viewer.showExpanded();

    return app.exec();
}
