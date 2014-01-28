.import QtQuick.LocalStorage 2.0 as Sql

function getDatabase() {
    var db = Sql.LocalStorage.openDatabaseSync('receptesCuina_',"1.0",'Receptes de cuina',100 * 1024);
    db.setVersion
    return db;
}

function initDatabase() {
    var db = getDatabase();
    db.transaction(
            function(tx) {
                tx.executeSql('CREATE TABLE IF NOT EXISTS receipts (id INTEGER PRIMARY KEY, name TEXT, desc TEXT)');
                tx.executeSql('CREATE TABLE IF NOT EXISTS ingredientsReceipts (id INTEGER PRIMARY KEY,receipt INTEGER,ord INTEGER,desc TEXT)');
                tx.executeSql('CREATE TABLE IF NOT EXISTS stepsReceipts (id INTEGER PRIMARY KEY,receipt INTEGER,ord INTEGER,desc TEXT)');
            });
}

function destroyTables() {
    getDatabase().transaction(
        function(tx) {
            tx.executeSql('DROP TABLE IF EXISTS receipts');
            tx.executeSql('DROP TABLE IF EXISTS ingredientsReceipts');
            tx.executeSql('DROP TABLE IF EXISTS stepsReceipts');
        });
}

function listReceipts (model) {
    return listReceiptsWithFilter(model,'');
}

function listReceiptsWithFilter (model,filter) {
    getDatabase().readTransaction(
        function(tx) {
            var rs;
            if (filter=='') {
                rs = tx.executeSql('SELECT * FROM receipts');
            } else {
                rs = tx.executeSql('SELECT * FROM receipts WHERE instr(name,?)',[filter]);
            }

            model.clear();
            for (var i=0; i<rs.rows.length; i++) {
                model.append({id: rs.rows.item(i).id, name: rs.rows.item(i).name, desc: rs.rows.item(i).desc,type:'show'});
            }

            if (filter=='') {
                model.append({id: 0, name: qsTr('Afegeix una recepta'), desc: '', type:'create'});
            } else {
                model.append({id: 0, name: qsTr('Afegeix nova recepta'), desc: 'amb el nom «' + filter + '»',type:'create'});
            }
        });
    return model;
}

function listIngredientsFromReceipt (idreceipt,model) {
    getDatabase().readTransaction(
        function(tx) {
            var rs = tx.executeSql('SELECT * FROM ingredientsReceipts WHERE receipt=? ORDER BY ord',[idreceipt]);
            for (var i=0; i<rs.rows.length; i++) {
                model.append({id: rows.item(i).id,desc: rows.item(i).desc,type:'show'});
            }
        });
    return model;
}

function listStepsFromReceipt (idreceipt,model) {
    getDatabase().readTransaction(
        function(tx) {
            var rs = tx.executeSql('SELECT * FROM stepsReceipts WHERE receipt=? ORDER BY ord',[idreceipt]);
            for (var i=0; i<rs.rows.length; i++) {
                model.append({id: rows.item(i).id,desc: rows.item(i).desc});
            }
        });
}

function getReceiptNameAndDesc (idReceipt) {
    var data = {};
    getDatabase().readTransaction(
        function(tx) {
            var rs = tx.executeSql('SELECT name, desc FROM receipts WHERE id=?',[idReceipt]);
            if (rs.rows.length>0) {
                data = {name: rs.rows.item(0).name, desc: rs.rows.item(0).desc};
            }
        });
    return data;
}

// New receipts

function saveNewReceipt (name,desc) {
    getDatabase().transaction(
        function(tx) {
            var rs = tx.executeSql('INSERT INTO receipts (name,desc) VALUES (?,?)',[name,desc]);
        });
}
