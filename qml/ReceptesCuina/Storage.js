.import QtQuick.LocalStorage 2.0 as Sql

function getDatabase() {
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
                model.append({id: -1, name: qsTr('Afegeix una recepta'), desc: '', type:'create'});
            } else {
                model.append({id: -1, name: qsTr('Afegeix nova recepta'), desc: 'amb el nom «' + filter + '»',type:'create'});
            }
        });
    return model;
}

function listIngredientsFromReceipt (receiptId,model) {
    listElementsFromReceipt('ingredientsReceipts',newIngredientForModel(),receiptId,model);
}

function listStepsFromReceipt (receiptId,model) {
    listElementsFromReceipt('stepsReceipts',newStepForModel(),receiptId,model);
}

function listElementsFromReceipt(table,newElement,receiptId,model) {
    getDatabase().readTransaction(
        function(tx) {
            var rs = tx.executeSql('SELECT * FROM ' + table + ' WHERE receipt=? ORDER BY ord',[receiptId]);
            for (var i=0; i<rs.rows.length; i++) {
                model.append({id: rs.rows.item(i).id, desc: rs.rows.item(i).desc, ord: rs.rows.item(i).ord, type:'show'});
            }
        });
    model.append(newElement);
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
            idReceipt = rs.insertId;
        });
    return idReceipt;
}

function newIngredientForModel() {
    return {id: -1, desc: qsTr('Insereix un ingredient'), ord: 0, type: 'create'};
}

function newStepForModel() {
    return {id: -1, desc: qsTr('Insereix una passa'), ord: 0, type: 'create'};
}

function saveNewIngredient(ingredientId,desc,receiptId,model,ingredientIndex) {
    return saveNewElement('ingredientsReceipts',newIngredientForModel(),ingredientId,desc,receiptId,model,ingredientIndex);
}

function saveNewStep(stepId,desc,receiptId,model,stepIndex) {
    return saveNewElement('stepsReceipts',newStepForModel(),stepId,desc,receiptId,model,stepIndex);
}

function saveNewElement(table,newElement,elementId,desc,receiptId,model,elementIndex) {
    getDatabase().transaction(
        function(tx) {
            if (elementId == -1) {
                // The element does not exist in the database, so it must be inserted
                // Get the last number used 'ord' plus one
                var rs = tx.executeSql('SELECT max(ord) AS ord FROM ' + table + ' WHERE receipt=?',[receiptId]);
                var ord = (rs.rows.length==0) ? 1 : rs.rows.item(0).ord + 1;
                rs = tx.executeSql('INSERT INTO ' + table + ' (receipt,ord,desc) VALUES (?,?,?)',[receiptId,ord,desc]);
                var newId = parseInt(rs.insertId);
                if (newId>0) {
                    model.set(elementIndex,{id: newId, desc: desc, ord: ord, type: 'show'});
                    model.append(newElement);
                } else {
                    console.log('Element not inserted in table «' + table + '»');
                }
            } else {
                // The element it exists, so it must be updated
                var rs = tx.executeSql('UPDATE ' + table + ' SET desc=? WHERE id=? AND receipt=?',[desc,elementId,receiptId]);
                if (rs.rowsAffected==1) {
                    model.setProperty(elementIndex,'desc',desc);
                } else {
                    console.log('Element not updated in table «' + table + '»');
                }
            }
        });
}

// Remove elements
function removeIngredient(ingredientId,receiptId,model,idx) {
    removeElement('ingredientsReceipts',ingredientId,receiptId,model,idx);
}

function removeStep(stepId,receiptId,model,idx) {
    removeElement('stepsReceipts',stepId,receiptId,model,idx);
}

function removeElement(table,elementId,receiptId,model,idx) {
    getDatabase().transaction(
        function (tx) {
            var rs = tx.executeSql('DELETE FROM ' + table + ' WHERE id=? AND receipt=?',[elementId,receiptId]);
            if (rs.rowsAffected == 1) {
                model.remove(idx);
            } else {
                console.log('Element not removed from table «' + table + '»');
            }
        });
}


// Export to other formats

function exportDatabaseToText() {
    var exportSql = '';
    getDatabase().readTransaction(
        function (tx) {
            var rs = tx.executeSql("SELECT tbl_name FROM sqlite_master WHERE type='table'");
            for (var i=0; i<rs.rows.length; i++) {
                var tblname = rs.rows.item(i).tbl_name;
                var rs2 = tx.executeSql('SELECT * FROM ' + tblname);
                for (var j=0; j<rs2.rows.length; j++) {
                    var row = rs2.rows.item(j);
                    var fields = [];
                    var values = [];
                    for (var col in row) {
                        fields.push(col);
                        values.push('"' + row[col].toString().replace(/\"/g,'""') + '"');
                    }
                    exportSql += 'INSERT INTO ' + tblname + '(' + fields.join(',') + ') VALUES (' + values.join(',') +');\n';
                }
            }
        });
    return exportSql;
}

function importDatabaseFromText(text) {
    var msgError = '';
    getDatabase().transaction(
        function (tx) {
            var queries = text.split(/\r\n|\r|\n/g);
            for (var i=0; i<queries.length; i++) {
                if (queries[i] != '') {
                    try {
                        var rs = tx.executeSql(queries[i], []);
                    }
                    catch(error) {
                        msgError += 'Ups! Error ha estat '+error+')\n';
                    }
                }
            }
        });
    return msgError;
}

