import QtQuick 2.0
import QtQuick.LocalStorage 2.0

QtObject {
    id: store

    function _db() {
        return LocalStorage.openDatabaseSync(
            "Topscore", "1.0", "High scores", 100000)
    }

    function _ensure() {
        _db().transaction(function(tx) {
            tx.executeSql(
                'CREATE TABLE IF NOT EXISTS scores (' +
                '  score INTEGER NOT NULL,' +
                '  date  TEXT    NOT NULL' +
                ')')
        })
    }

    function addScore(score) {
        _ensure()
        var iso = new Date().toISOString()
        _db().transaction(function(tx) {
            tx.executeSql('INSERT INTO scores VALUES (?, ?)', [score, iso])
        })
    }

    function allScores() {
        _ensure()
        var out = []
        _db().readTransaction(function(tx) {
            var rs = tx.executeSql(
                'SELECT score, date FROM scores ORDER BY score DESC, date ASC')
            for (var i = 0; i < rs.rows.length; i++) {
                out.push({
                    score: rs.rows.item(i).score,
                    date:  rs.rows.item(i).date
                })
            }
        })
        return out
    }
}
