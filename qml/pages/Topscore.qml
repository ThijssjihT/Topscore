import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id:                     page
    allowedOrientations:    Orientation.All
    onGameCompleteChanged:  if (gameComplete) finishTimer.start()
    Component.onCompleted:  scoreStore.setCurrent(0)
    onGrandTotalValChanged: scoreStore.setCurrent(grandTotalVal)

    property var    diceModel: ListModel {
        ListElement { value: 1; selected: false }
        ListElement { value: 1; selected: false }
        ListElement { value: 1; selected: false }
        ListElement { value: 1; selected: false }
        ListElement { value: 1; selected: false }
    }
    property var    scoreModel: ListModel {
        ListElement { key: "ones";          label: qsTr("Ones");            hint: qsTr("Total 1's");        section: 1; score: -1; filled: false }
        ListElement { key: "twos";          label: qsTr("Twos");            hint: qsTr("Total 2's");        section: 1; score: -1; filled: false }
        ListElement { key: "threes";        label: qsTr("Threes");          hint: qsTr("Total 3's");        section: 1; score: -1; filled: false }
        ListElement { key: "fours";         label: qsTr("Fours");           hint: qsTr("Total 4's");        section: 1; score: -1; filled: false }
        ListElement { key: "fives";         label: qsTr("Fives");           hint: qsTr("Total 5's");        section: 1; score: -1; filled: false }
        ListElement { key: "sixes";         label: qsTr("Sixes");           hint: qsTr("Total 6's");        section: 1; score: -1; filled: false }
        ListElement { key: "3ofakind";      label: qsTr("Three of a Kind"); hint: qsTr("Sum of all dice");  section: 2; score: -1; filled: false }
        ListElement { key: "4ofakind";      label: qsTr("Four of a Kind");  hint: qsTr("Sum of all dice");  section: 2; score: -1; filled: false }
        ListElement { key: "fullhouse";     label: qsTr("Full House");      hint: qsTr("25 points");        section: 2; score: -1; filled: false }
        ListElement { key: "smallstraight"; label: qsTr("Small Straight");  hint: qsTr("30 points");        section: 2; score: -1; filled: false }
        ListElement { key: "largestraight"; label: qsTr("Large Straight");  hint: qsTr("40 points");        section: 2; score: -1; filled: false }
        ListElement { key: "topscore";      label: qsTr("Top Score");       hint: qsTr("50 points");        section: 2; score: -1; filled: false }
        ListElement { key: "chance";        label: qsTr("Chance");          hint: qsTr("Sum of all dice");  section: 2; score: -1; filled: false }
    }

    property int            scoreTick:          0
    property int            pendingIndex:       -1   // -1 = nothing pending
    property bool           gameStarted:        false
    property bool           rollAnimation:      false
    property int            rollTime:           0
    property int            rollNumber:         0
    readonly property int   part1Subtotal:      (scoreTick, sumSection(1))
    readonly property int   part1Bonus:         part1Subtotal >= 63 ? 35 : 0
    readonly property int   part1Total:         part1Subtotal + part1Bonus
    readonly property int   part2Total:         (scoreTick, sumSection(2))
    readonly property int   grandTotalVal:      part1Total + part2Total
    readonly property bool  gameComplete:       (scoreTick, allScoresFilled())

    RemorsePopup {
        id:             commitRemorse
        onCanceled:     pendingIndex = -1
    }

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        anchors.fill:           parent
        anchors.bottomMargin:   diceView.visibleSize
        clip:                   true

        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        PullDownMenu {
 //           MenuItem {
 //               text: qsTr("Settings")
 //               onClicked: pageStack.animatorPush(Qt.resolvedUrl("Settings.qml"))
 //           }
            MenuItem {
                text: qsTr("Top scores")
                onClicked: pageStack.animatorPush(Qt.resolvedUrl("Scores.qml"))
            }
        }

        // Tell SilicaFlickable the height of its content.
        contentHeight:  column.height

        // Place our content in a Column.  The PageHeader is always placed at the top
        // of the page, followed by our content.
        Column {
            id:                 column
            width:              parent.width -2 * Theme.horizontalPageMargin
            x:                  Theme.horizontalPageMargin
            spacing:            Theme.paddingSmall

            PageHeader { title: qsTr("Top Score") }
            SectionHeader { text: qsTr("Part 1") }
            Repeater {
                model: scoreModel
                delegate: ScoreRow {
                    visible:    section === 1
                    labelText:  label
                    hintText:   hint
                    scoreText:  filled ? score.toString() : "…"
                    scoreColor: filled ? Theme.primaryColor : Theme.secondaryColor
                    clickable:  true
                    onClicked:  commitScore(index)
                }
            }
            ScoreRow {
                labelText:  qsTr("Total points")
                hintText:   "→"
                scoreText:  part1Subtotal
            }
            ScoreRow {
                labelText:  qsTr("Bonus on 63 or more")
                hintText:   qsTr("35 points")
                scoreText:  part1Bonus
            }
            ScoreRow {
                labelText:  qsTr("Total part 1")
                hintText:   "→"
                scoreText:  part1Total
            }

            SectionHeader { text: qsTr("Part 2") }
            Repeater {
                model: scoreModel
                delegate: ScoreRow {
                    visible:    section === 2
                    labelText:  label
                    hintText:   hint
                    scoreText:  filled ? score.toString() : "…"
                    scoreColor: filled ? Theme.primaryColor : Theme.secondaryColor
                    clickable:  true
                    onClicked:  commitScore(index)
                }
            }
            ScoreRow {
                labelText:  qsTr("Total part 2")
                hintText:   "→"
                scoreText:  part2Total
            }

            SectionHeader { text: qsTr("Grand Total") }
            ScoreRow {
                labelText:  qsTr("Total part 1")
                scoreText:  part1Total
            }
            ScoreRow {
                labelText:  qsTr("Total part 2")
                scoreText:  part2Total
            }
            ScoreRow {
                labelText:  qsTr("Grand Total")
                scoreText:  grandTotalVal
            }

            Separator {
                width:                  parent.width
                color:                  Theme.primaryColor
                horizontalAlignment:    Qt.AlignHCenter
            }

            Button {
                id:                         rollButton
                text:                       qsTr("1st Roll")
                anchors.horizontalCenter:   parent.horizontalCenter
                enabled:                    rollNumber !== 3 && pendingIndex < 0
                onClicked: function() {
                    rollNumber ++
                    diceView.show()
                    rollTime = 20
                    rollTimer.start()
                    switch(rollNumber) {
                    case 1:
                        rollButton.text = qsTr("2nd Roll")
                        break
                    case 2:
                        rollButton.text = qsTr("Last roll")
                        break
                    case 3:
                        rollButton.text = qsTr("Enter score")
                        break
                    }
                }
            }
            Item {                       // breathing room so the button clears the dock
                            width:  1
                            height: Theme.paddingLarge
            }
        }
    }

    DockedPanel {
        id:         diceView
        width:      parent.width
        height:     diceRow.height + 2 * Theme.paddingMedium
        dock:       Dock.Bottom

        Rectangle {
            anchors.fill:   parent
            color:          Theme.highlightBackgroundColor
            opacity:        Theme.highlightBackgroundOpacity
        }

        Row {
            id:                             diceRow
            anchors.horizontalCenter:       parent.horizontalCenter
            anchors.verticalCenter:         parent.verticalCenter
            anchors.verticalCenterOffset:   -Theme.paddingLarge
            spacing:                        Theme.paddingMedium
            Repeater {
                id:     diceRepeater
                model:  diceModel
                Switch {
                    enabled:            pendingIndex < 0
                    checked:            model.selected
                    onCheckedChanged:   diceModel.setProperty(index, "selected", checked)
                    icon.source:        "../assets/" + model.value + ".svg"
                    icon.width:         Theme.iconSizeMedium
                    icon.height:        Theme.iconSizeMedium
                }
            }
        }
    }

    Timer {
        id:         rollTimer
        interval:   1
        repeat:     true
        onTriggered: function() {

            for (var i = 0; i < 5; i++) {
                if (!diceModel.get(i).selected) {
                    diceModel.setProperty(i, "value", rollDie())
                }
            }
            rollTime--
            if (rollTime == 0) { rollTimer.stop() }
        }
    }

    Timer {
        id:         finishTimer
        interval:   800
        onTriggered: {
            scoreStore.addScore(grandTotalVal)
            var rank = scoreStore.rankFor(grandTotalVal)
            pageStack.animatorReplace(Qt.resolvedUrl("Scores.qml"), {
                justFinishedScore: grandTotalVal,
                justFinishedRank:  rank
            })
        }
    }

    function rollDie() {
        return Math.floor(Math.random() * 6) + 1
    }

    function diceValues() {
        var d = []
        for (var i = 0; i < 5; i++) d.push(diceModel.get(i).value)
        return d
    }

    function countFace(dice, face) {
        var n = 0
        for (var i = 0; i < dice.length; i++) if (dice[i] === face) n++
        return n
}

    function sumDice(dice) {
        var t = 0
        for (var i = 0; i < dice.length; i++) t += dice[i]
        return t
    }

    function allSame(dice) {
        for (var i = 1; i < dice.length; i++) if (dice[i] !== dice[0]) return false
        return true
    }

    function hasNOfAKind(dice, n) {
        for (var face = 1; face <= 6; face++) {
            if (countFace(dice, face) >= n) return true
        }
        return false
    }

    function isFullHouse(dice) {
        var d = dice.slice().sort()
        if (allSame(d)) return false
        return d[0] === d[1] && d[3] === d[4]
               && (d[1] === d[2] || d[2] === d[3])
    }

    // Returns sorted unique values.
    function uniqueSorted(dice) {
        var d = dice.slice().sort()
        var u = [d[0]]
        for (var i = 1; i < d.length; i++) {
            if (d[i] !== d[i-1]) u.push(d[i])
        }
        return u
    }

    function isLargeStraight(dice) {
        var u = uniqueSorted(dice)
        return u.length === 5 && (u[4] - u[0]) === 4
    }

    function isSmallStraight(dice) {
        var u = uniqueSorted(dice)
        if (u.length < 4) return false
        // Check every 4-long window.
        for (var i = 0; i + 3 < u.length; i++) {
            if (u[i+3] - u[i] === 3) return true
        }
        return false
    }

    function scoreFor(key, dice) {
        switch (key) {
        case "ones":            return countFace(dice, 1) * 1
        case "twos":            return countFace(dice, 2) * 2
        case "threes":          return countFace(dice, 3) * 3
        case "fours":           return countFace(dice, 4) * 4
        case "fives":           return countFace(dice, 5) * 5
        case "sixes":           return countFace(dice, 6) * 6
        case "chance":          return sumDice(dice)
        case "topscore":        return allSame(dice) ? 50 : 0
        case "3ofakind":        return hasNOfAKind(dice, 3) ? sumDice(dice) : 0
        case "4ofakind":        return hasNOfAKind(dice, 4) ? sumDice(dice) : 0
        case "fullhouse":       return isFullHouse(dice) ? 25 : 0
        case "smallstraight":   return isSmallStraight(dice) ? 30 : 0
        case "largestraight":   return isLargeStraight(dice) ? 40 : 0
        }
        return 0
    }

    function commitScore(index) {
        if (rollNumber === 0) return
        var entry = scoreModel.get(index)
        if (entry.filled) return    // ← prevents overwriting

        var s = scoreFor(entry.key, diceValues())
        pendingIndex = index
        commitRemorse.execute(
            //: %1 = category name (e.g. "Fives"), %2 = points
            qsTr("Scoring %1: %2").arg(entry.label).arg(s),
            function() {
                scoreModel.setProperty(index, "score",  s)
                scoreModel.setProperty(index, "filled", true)
                scoreTick++
                pendingIndex = -1
                resetTurn()
            },
            3000
        )
    }

    function resetTurn() {
        rollNumber = 0
        rollButton.text = qsTr("1st Roll")
        for (var i = 0; i < 5; i++) {
            diceRepeater.itemAt(i).checked = false
        }
        diceView.hide()
    }

    function sumSection(sec) {
        var t = 0
        for (var i = 0; i < scoreModel.count; i++) {
            var e = scoreModel.get(i)
            if (e.section === sec && e.filled) t += e.score
        }
        return t
    }

    function allScoresFilled() {
        for (var i = 0; i < scoreModel.count; i++) {
            if (!scoreModel.get(i).filled) return false
        }
        return true
    }
}
