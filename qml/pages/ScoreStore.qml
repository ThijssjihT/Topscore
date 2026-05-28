import QtQuick 2.0
import QtQuick.LocalStorage 2.0

QtObject {

    id: store
    Component.onCompleted: loadPrevious()

    property int    currentTotal:   0
    property int    currentRank:    1
    property int    previousTotal:  0
    property int    previousRank:   0

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
        currentTotal    = score
        currentRank     = rankFor(score)
        previousTotal   = score
        previousRank    = currentRank   // same as just-computed currentRank
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

    function rankFor(score) {
        _ensure()
        var r = 1
        _db().readTransaction(function(tx) {
            var rs = tx.executeSql(
                'SELECT COUNT(*) AS c FROM scores WHERE score > ?', [score])
            r = rs.rows.item(0).c + 1
        })
        return r
    }

    function topScores(limit) {
        _ensure()
        var out = []
        _db().readTransaction(function(tx) {
            var rs = tx.executeSql(
                'SELECT score, date FROM scores ' +
                'ORDER BY score DESC, date ASC LIMIT ?', [limit])
            for (var i = 0; i < rs.rows.length; i++) {
                out.push({
                    score: rs.rows.item(i).score,
                    date:  rs.rows.item(i).date
                })
            }
        })
        return out
    }

    function setCurrent(score) {
        currentTotal = score
        currentRank  = rankFor(score)
    }

    function loadPrevious() {
        _ensure()
        _db().readTransaction(function(tx) {
            var rs = tx.executeSql(
                'SELECT score FROM scores ORDER BY date DESC LIMIT 1')
            if (rs.rows.length > 0) {
                previousTotal = rs.rows.item(0).score
                previousRank  = rankFor(previousTotal)
            }
        })
    }
}
