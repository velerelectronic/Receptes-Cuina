#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QSqlDatabase>
#include <QDebug>
#include <QQmlContext>

#include "sqltablemodel.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    app.setApplicationName("Receptes de cuina");
    app.setOrganizationName("joanmiquelpayerascrespi");
    app.setApplicationVersion("1.0");

    QQmlApplicationEngine engine;

    qDebug() << QString("----->")  << app.applicationVersion();

    QSqlDatabase db;
    db = QSqlDatabase::addDatabase("QSQLITE");

    qDebug() << engine.offlineStoragePath();
    db.setDatabaseName(engine.offlineStoragePath() + "/Databases/982e3d0179df85ab6e1c5d705ad596ea.sqlite");

    SqlTableModel receiptsModel;
    SqlTableModel ingredientsModel;
    SqlTableModel stepsModel;
    SqlTableModel imagesModel;

    engine.rootContext()->setContextProperty("receiptsModel",&receiptsModel);
    engine.rootContext()->setContextProperty("ingredientsModel",&ingredientsModel);
    engine.rootContext()->setContextProperty("stepsModel",&stepsModel);
    engine.rootContext()->setContextProperty("imagesModel",&imagesModel);

    engine.load(QUrl(QStringLiteral("qrc:///qml/main.qml")));

    return app.exec();
}
