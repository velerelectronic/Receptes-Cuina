#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QSqlDatabase>
#include <QDebug>
#include <QQmlContext>
#include <QtQml>
#include <QDir>
#include <QStandardPaths>

#include "sqltablemodel.h"
#include "imagedata.h"
#include "databasebackup.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    app.setApplicationName("Receptes de cuina");
    app.setOrganizationName("joanmiquelpayerascrespi");
    app.setApplicationVersion("1.0");

    QQmlApplicationEngine engine;

    QString specificPath("ReceptesCuina");
    QDir dir(QStandardPaths::writableLocation(QStandardPaths::GenericDataLocation));
    if (!dir.exists(specificPath)) {
        dir.mkdir(specificPath);
    }

    QSqlDatabase db;
    if (dir.cd(specificPath)) {
        db = QSqlDatabase::addDatabase("QSQLITE");
        db.setDatabaseName(dir.absolutePath() + "/mainDatabase.sqlite");
    }

    SqlTableModel receiptsModel;
    SqlTableModel ingredientsModel;
    SqlTableModel stepsModel;
    SqlTableModel imagesModel;

    qmlRegisterType<ImageData>("PersonalTypes", 1, 0, "ImageData");
    qmlRegisterType<DatabaseBackup>("PersonalTypes", 1, 0, "DatabaseBackup");

    engine.rootContext()->setContextProperty("receiptsModel",&receiptsModel);
    engine.rootContext()->setContextProperty("ingredientsModel",&ingredientsModel);
    engine.rootContext()->setContextProperty("stepsModel",&stepsModel);
    engine.rootContext()->setContextProperty("imagesModel",&imagesModel);

    engine.load(QUrl(QStringLiteral("qrc:///qml/main.qml")));

    return app.exec();
}
