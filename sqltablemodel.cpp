#include "sqltablemodel.h"

#include <QDebug>
#include <QSqlField>
#include <QSqlIndex>
#include <QSqlRecord>
#include <QSqlQuery>
#include <QMap>
#include <QSqlError>

SqlTableModel::SqlTableModel(QObject *parent, QSqlDatabase db) :
    QSqlRelationalTableModel(parent,db)
{
    setEditStrategy(QSqlTableModel::OnFieldChange);
    connect(this,SIGNAL(rowsInserted(QModelIndex,int,int)),this,SLOT(select()));
}

QSqlRecord SqlTableModel::buildRecord(const QVariantMap &object,bool autoValue) {
    QSqlRecord record;
    QVariantMap::const_iterator i = object.constBegin();
    while (i != object.constEnd()) {
        QSqlField field(i.key(),QVariant::String);
        field.setValue(i.value());
        record.append(field);
        ++i;
    }
    if (autoValue) {
        QSqlField idfield("id",QVariant::Int);
        idfield.setAutoValue(true);
        record.append(idfield);
    }
    return record;
}

int SqlTableModel::count() {
    return rowCount();
}

const QStringList &SqlTableModel::fieldNames() {
    return innerFieldNames;
}

const QString &SqlTableModel::filter() {
    return QSqlRelationalTableModel::filter();
}

const QString &SqlTableModel::tableName() {
    return innerTableName;
}

bool SqlTableModel::setData(const QModelIndex &item, const QVariant &value, int role) {
    qDebug() << "Set data";
    return true;
}

void SqlTableModel::setFieldNames(QStringList fields) {
    innerFieldNames = fields;
    fieldNamesChanged();
}

void SqlTableModel::setFilter(const QString &filter) {
    QSqlRelationalTableModel::setFilter(filter);
    filterChanged();
}

void SqlTableModel::setTableName(const QString &tableName) {
    innerTableName = tableName;
    setTable(tableName);
    generateRoleNames();
    tableNameChanged();

    setSort(0,Qt::DescendingOrder);
    setFilter("");
}

bool SqlTableModel::setQuery(const QString query) {
    qDebug() << "Query... " << query;
    QSqlRelationalTableModel::setQuery(QSqlQuery(query));
    submitAll();
}

QVariant SqlTableModel::data(const QModelIndex &index, int role) const {
    if (index.row() >= rowCount())
        return QString("");

    if (role < Qt::UserRole)
        return QSqlQueryModel::data(index, role);
    else {
        // search for relationships
        int nbCols = columnCount();

        if (role == Qt::UserRole + nbCols + 1) {
            return subselectedRows.contains(index.row());
        } else {
            for (int i = 0; i < nbCols; i++) {
                if (this->relation(i).isValid()) {
                    return record(index.row()).value(QString(roles.value(role)));
                }
            }
            // if no valid relationship was found
            return QSqlQueryModel::data(this->index(index.row(), role - Qt::UserRole - 1), Qt::DisplayRole);
        }
    }
}

QString SqlTableModel::order() {
    return QSqlRelationalTableModel::orderByClause();
}

QHash<int, QByteArray> SqlTableModel::roleNames() const {
    return roles;
}

void SqlTableModel::setOrder(const QString &newOrder) {

}

void SqlTableModel::setSort(int column, Qt::SortOrder order) {
    QSqlRelationalTableModel::setSort(column,order);
}

void SqlTableModel::filterFields(const QStringList &fields, QString text) {
    QString filter("0=1");
    QStringList::const_iterator i = fields.constBegin();
    while (i != fields.constEnd()) {
        filter += " OR instr(UPPER(" + *i + "),UPPER('" + text + "'))";
        ++i;
    }
    setFilter(filter);
}

QVariantMap SqlTableModel::getObject(QString key) const {
    QSqlRecord searchRecord;
    bool found = false;
    int row=0;
    while ((!found) && (row<rowCount())) {
        searchRecord = this->record(row);
        if (searchRecord.value(primaryKey().fieldName(0))==key)
            found = true;
        else
            row++;
    }

    QVariantMap result;
    if (found) {
        for (int i=0; i<searchRecord.count(); i++) {
            result.insert(searchRecord.fieldName(i),searchRecord.value(i));
        }
    }

    return result;
}

bool SqlTableModel::insertObject(const QVariantMap &object) {
    QSqlRecord record = buildRecord(object,true);
    bool result = insertRowIntoTable(record);
    select();
    return result;
}

int SqlTableModel::searchRowWithKeyValue(const QVariant &value) {
    QSqlRecord searchRecord;
    int row=0;
    bool found = false;
    while ((!found) && (row<rowCount())) {
        searchRecord = this->record(row);
        QString pk = primaryKey().fieldName(0);
        if (searchRecord.value(pk)==value)
            found = true;
        else
            row++;
    }
    return (found)?row:-1;
}

bool SqlTableModel::removeObjectInRow(int row) {
    return removeRows(row,1);
}

bool SqlTableModel::removeObjectWithKeyValue(const QVariant &value) {
    int row = searchRowWithKeyValue(value);

    if (row>-1)
        return removeRows(row,1);
    else
        return false;
}

bool SqlTableModel::select() {
    qDebug() << "Select";
    deselectAllObjects();
    countChanged();
    return QSqlRelationalTableModel::select();
}

bool SqlTableModel::setReference(const QString &field, const QString &keyRef) {
    setFilter(field + "='" + keyRef + "'");
}

bool SqlTableModel::updateObject(const QVariantMap &object) {
    int row = searchRowWithKeyValue(object.value(this->primaryKey().fieldName(0)));

    bool result = false;
    if (row>-1) {
        QSqlRecord record = buildRecord(object,false);
        result = updateRowInTable(row,record);
        selectRow(row);
        select();
    }
    return result;
}

void SqlTableModel::generateRoleNames() {
    qDebug() << "Defining role names";
    roles.clear();
    qDebug() << this->columnCount();
    int nbCols = this->columnCount();
    for (int i = 0; i < nbCols; i++) {
        roles[Qt::UserRole + i + 1] = QVariant(this->headerData(i, Qt::Horizontal).toString()).toByteArray();
    }
    roles[Qt::UserRole + nbCols + 1] = QByteArray("selected");

#ifndef HAVE_QT5
//    setRoleNames(roles);
#endif

}


int SqlTableModel::removeSelectedObjects() {
    int i = 0;
    QMap<int,bool>::iterator row = subselectedRows.end();
    while (row != subselectedRows.begin()) {
        --row;
        if (removeObjectWithKeyValue(row.key()))
            i++;
    }
    subselectedRows.clear();
    select();
    return i;
}

void SqlTableModel::selectObject(const int &row,bool activate) {
    qDebug() << "Selecting " << row;
    if (activate)
        subselectedRows.insert(row,true);
    else
        subselectedRows.remove(row);
    QModelIndex index = this->createIndex(row,Qt::UserRole + columnCount() + 1);
    this->dataChanged(index,index);
}

void SqlTableModel::deselectAllObjects() {
    subselectedRows.clear();
    QModelIndex indexStart = this->createIndex(0,Qt::UserRole + columnCount() + 1);
    QModelIndex indexEnd = this->createIndex(rowCount(),Qt::UserRole + columnCount() + 1);
    this->dataChanged(indexStart,indexEnd);
}

bool SqlTableModel::isSelectedObject(const int &row) {
    return subselectedRows.contains(row);
}
