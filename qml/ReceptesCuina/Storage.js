.import QtQuick.LocalStorage 2.0 as Sql

function getDatabase() {
    var db = Sql.LocalStorage.openDatabaseSync('ReceptesCuina',"1.0",'ReceptesCuina',100 * 1024);
    var db = Sql.LocalStorage.openDatabaseSync('ReceptesCuina',"1.0",'ReceptesCuina',1000 * 1024);
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
                rs = tx.executeSql('SELECT * FROM receipts WHERE instr(UPPER(name),UPPER(?))',[filter]);
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
                model.append({id: rs.rows.item(i).id, desc: rs.rows.item(i).desc, ord: rs.rows.item(i).ord, type:'show'});
            }
        });
    model.append(newIngredientForModel());
    return model;
}

function listStepsFromReceipt (idreceipt,model) {
    getDatabase().readTransaction(
        function(tx) {
            var rs = tx.executeSql('SELECT * FROM stepsReceipts WHERE receipt=? ORDER BY ord',[idreceipt]);
            for (var i=0; i<rs.rows.length; i++) {
                model.append({id: rs.rows.item(i).id,desc: rs.rows.item(i).desc, ord: rs.rows.item(i).ord, type: 'show'});
            }
        });
    model.append({id: 0,desc: 'Insereix una passa', ord: 0, type: 'create'});
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

// New elements

function saveNewReceipt (name,desc) {
    var idReceipt = 0;
    getDatabase().transaction(
        function(tx) {
            var rs = tx.executeSql('INSERT INTO receipts (name,desc) VALUES (?,?)',[name,desc]);
            idReceipt = rs.rowId;
        });
    return idReceipt;
}

function newIngredientForModel() {
    return {id: 0, desc: qsTr('Insereix un ingredient'), type: 'create'};
}

function newStepForModel() {
    return {id: 0, desc: qsTr('Insereix una passa'), type: 'create'};
}

function saveNewIngredient(desc,receiptId,model) {
    return saveNewElement('ingredientsReceipts',newIngredientForModel(),desc,receiptId,model);
}

function saveNewStep(desc,receiptId,model) {
    return saveNewElement('stepsReceipts',newStepForModel(),desc,receiptId,model);
}

function saveNewElement(table,newElement,desc,receiptId,model) {
    var idx;
    getDatabase().transaction(
        function(tx) {
            var ord;
            var rs = tx.executeSql('SELECT max(ord) AS ord FROM ' + table + ' WHERE receipt=?',[receiptId]);
            ord = (rs.rows.length==0) ? 1 : rs.rows.item(0).ord + 1;
            rs = tx.executeSql('INSERT INTO ' + table + ' (receipt,ord,desc) VALUES (?,?,?)',[receiptId,ord,desc]);
            idx = model.count-1;
            model.set(idx,{id: rs.rowId, desc: desc, ord: ord, type:'show'});
            model.append(newElement);
        });
    return idx;
}

// Remove elements
function removeIngredient(ingredientId,receiptId,model,idx) {
    console.log('Ingredient at '+idx);
    removeElement('ingredientsReceipts',ingredientId,receiptId,model,idx);
}

function removeStep(stepId,receiptId,model,idx) {
    console.log('Step at '+idx);
    removeElement('stepsReceipts',stepId,receiptId,model,idx);
}

function removeElement(table,elementId,receiptId,model,idx) {
    getDatabase().transaction(
        function (tx) {
            var rs = tx.executeSql('DELETE FROM ' + table + ' WHERE id=? AND receipt=?',[elementId,receiptId]);
            // Errors should be checked
            model.remove(idx);
        });
}
