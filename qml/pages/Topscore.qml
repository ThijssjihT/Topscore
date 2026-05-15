import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id:                     page
    allowedOrientations:    Orientation.All

    property bool   gameStarted:    false
    property bool   rollAnimation:  false
    property int    rollTime:       0
    property int    rollNumber:     0
    property var    diceModel: ListModel {
        ListElement { value: 1; selected: false }
        ListElement { value: 1; selected: false }
        ListElement { value: 1; selected: false }
        ListElement { value: 1; selected: false }
        ListElement { value: 1; selected: false }
    }

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        anchors.fill: parent

        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        PullDownMenu {
            MenuItem {
                text: qsTr("Settings")
                onClicked: pageStack.animatorPush(Qt.resolvedUrl("Settings.qml"))
            }
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
            width:              parent.width
            anchors.left:       parent.left
            anchors.right:      parent.right
            anchors.margins:    Theme.horizontalPageMargin
            spacing:            Theme.paddingSmall

            PageHeader { title: qsTr("Top Score") }
            SectionHeader { text: qsTr("Part 1") }
            Row {
                spacing: Theme.paddingLarge
                Column {
                    Label {
                        text:   qsTr("Ones")
                        color:  Theme.highlightColor
                    }
                    Label {
                        text:   qsTr("Twos")
                        color:  Theme.highlightColor
                    }
                    Label {
                        text:   qsTr("Threes")
                        color:  Theme.highlightColor
                    }
                    Label {
                        text:   qsTr("Fours")
                        color:  Theme.highlightColor
                    }
                    Label {
                        text:   qsTr("Fives")
                        color:  Theme.highlightColor
                    }
                    Label {
                        text:   qsTr("Sixes")
                        color:  Theme.highlightColor
                    }
                    Label {
                        text:   qsTr("Total points")
                        color:  Theme.highlightColor
                    }
                    Label {
                        text:   qsTr("Bonus on 63 or more")
                        color:  Theme.highlightColor
                    }
                    Label {
                        text:   qsTr("Total part 1")
                        color:  Theme.highlightColor
                    }

                }
                Column {
                    Label {
                        text:   qsTr("Total 1's")
                        color:  Theme.secondaryHighlightColor
                    }
                    Label {
                        text:   qsTr("Total 2's")
                        color:  Theme.secondaryHighlightColor
                    }
                    Label {
                        text:   qsTr("Total 3's")
                        color:  Theme.secondaryHighlightColor
                    }
                    Label {
                        text:   qsTr("Total 4's")
                        color:  Theme.secondaryHighlightColor
                    }
                    Label {
                        text:   qsTr("Total 5's")
                        color:  Theme.secondaryHighlightColor
                    }
                    Label {
                        text:   qsTr("Total 6's")
                        color:  Theme.secondaryHighlightColor
                    }
                    Label {
                        text:   "→"
                        color:  Theme.secondaryHighlightColor
                    }
                    Label {
                        text:   qsTr("35 points")
                        color:  Theme.secondaryHighlightColor
                    }
                    Label {
                        text:   "→"
                        color:  Theme.secondaryHighlightColor
                    }
                }
                Column {
                    Label {
                        id:     score1
                        text:   "..."
                        color:  Theme.primaryColor

                        MouseArea {
                            anchors.fill:   parent
                            onClicked:      calculateAndFill("ones")
                        }
                    }
                    Label {
                        id:     score2
                        text:   "..."
                        color:  Theme.primaryColor

                        MouseArea {
                            anchors.fill:   parent
                            onClicked:      calculateAndFill("twos")
                        }
                    }
                    Label {
                        id:     score3
                        text:   "..."
                        color:  Theme.primaryColor

                        MouseArea {
                            anchors.fill:   parent
                            onClicked:      calculateAndFill("threes")
                        }
                    }
                    Label {
                        id:     score4
                        text:   "..."
                        color:  Theme.primaryColor

                        MouseArea {
                            anchors.fill:   parent
                            onClicked:      calculateAndFill("fours")
                        }
                    }
                    Label {
                        id:     score5
                        text:   "..."
                        color:  Theme.primaryColor

                        MouseArea {
                            anchors.fill:   parent
                            onClicked:      calculateAndFill("fives")
                        }
                    }
                    Label {
                        id:     score6
                        text:   "..."
                        color:  Theme.primaryColor

                        MouseArea {
                            anchors.fill:   parent
                            onClicked:      calculateAndFill("sixes")
                        }
                    }
                    Label {
                        id:     subtotal
                        text:   "0"
                        color:  Theme.primaryColor
                    }

                    Label {
                        id:     bonus
                        text:   "0"
                        color:  Theme.primaryColor
                    }
                    Label {
                        id:     totalPart1
                        text:   "0"
                        color:  Theme.primaryColor
                    }
                }
            }
            SectionHeader { text: qsTr("Part 2") }
            Row {
                spacing: Theme.paddingLarge
                Column {
                    Label {
                        text:   qsTr("Three of a Kind")
                        color:  Theme.highlightColor
                    }
                    Label {
                        text:   qsTr("Four of a Kind")
                        color:  Theme.highlightColor
                    }
                    Label {
                        text:   qsTr("Full House")
                        color:  Theme.highlightColor
                    }
                    Label {
                        text:   qsTr("Small Straight")
                        color:  Theme.highlightColor
                    }
                    Label {
                        text:   qsTr("Large Straight")
                        color:  Theme.highlightColor
                    }
                    Label {
                        text:   qsTr("Top Score")
                        color:  Theme.highlightColor
                    }
                    Label {
                        text:   qsTr("Chance")
                        color:  Theme.highlightColor
                    }
                    Label {
                        text:   qsTr("Total part 2")
                        color:  Theme.highlightColor
                    }
                }
                Column {
                    Label {
                        text:   qsTr("Sum of all dice")
                        color:  Theme.secondaryHighlightColor
                    }
                    Label {
                        text:   qsTr("Sum of all dice")
                        color:  Theme.secondaryHighlightColor
                    }
                    Label {
                        text:   qsTr("25 points")
                        color:  Theme.secondaryHighlightColor
                    }
                    Label {
                        text:   qsTr("30 points")
                        color:  Theme.secondaryHighlightColor
                    }
                    Label {
                        text:   qsTr("40 points")
                        color:  Theme.secondaryHighlightColor
                    }
                    Label {
                        text:   qsTr("50 points")
                        color:  Theme.secondaryHighlightColor
                    }
                    Label {
                        text:   qsTr("Sum of all dice")
                        color:  Theme.secondaryHighlightColor
                    }
                    Label {
                        text:   "→"
                        color:  Theme.secondaryHighlightColor
                    }
                }
                Column {
                    Label {
                        id:     score3ofaKind
                        text:   "..."
                        color:  Theme.primaryColor

                        MouseArea {
                            anchors.fill:   parent
                            onClicked:      calculateAndFill("3ofakind")
                        }
                    }
                    Label {
                        id:     score4ofaKind
                        text:   "..."
                        color:  Theme.primaryColor

                        MouseArea {
                            anchors.fill:   parent
                            onClicked:      calculateAndFill("4ofakind")
                        }
                    }
                    Label {
                        id:     scoreFullHouse
                        text:   "..."
                        color:  Theme.primaryColor

                        MouseArea {
                            anchors.fill:   parent
                            onClicked:      calculateAndFill("fullhouse")
                        }
                    }
                    Label {
                        id:     scoreSmallStr
                        text:   "..."
                        color:  Theme.primaryColor

                        MouseArea {
                            anchors.fill:   parent
                            onClicked:      calculateAndFill("smallstraight")
                        }
                    }
                    Label {
                        id:     scoreLargeStr
                        text:   "..."
                        color:  Theme.primaryColor

                        MouseArea {
                            anchors.fill:   parent
                            onClicked:      calculateAndFill("largestraight")
                        }
                    }
                    Label {
                        id:     scoreTopScore
                        text:   "..."
                        color:  Theme.primaryColor

                        MouseArea {
                            anchors.fill:   parent
                            onClicked:      calculateAndFill("topscore")
                        }
                    }
                    Label {
                        id:     scoreChance
                        text:   "..."
                        color:  Theme.primaryColor

                        MouseArea {
                            anchors.fill:   parent
                            onClicked:      calculateAndFill("chance")
                        }
                    }
                    Label {
                        id:     totalPart2
                        text:   "0"
                        color:  Theme.primaryColor
                    }
                }
            }
            SectionHeader { text: qsTr("Grand Total") }
            Row {
                spacing: Theme.paddingLarge
                Column {
                    Label {
                        text:   qsTr("Total part 1")
                        color:  Theme.highlightColor
                    }
                    Label {
                        text:   qsTr("Total part 2")
                        color:  Theme.highlightColor
                    }
                    Label {
                        text:   qsTr("Grand Total")
                        color:  Theme.highlightColor
                    }
                }
                Column {
                    Label {
                        text:   ""
                        color:  Theme.secondaryHighlightColor
                    }
                    Label {
                        text:   ""
                        color:  Theme.secondaryHighlightColor
                    }
                    Label {
                        text:   ""
                        color:  Theme.secondaryHighlightColor
                    }
                }
                Column {
                    Label {
                        id:     grandTotalPart1
                        text:   "0"
                        color:  Theme.primaryColor
                    }
                    Label {
                        id:     grandTotalPart2
                        text:   "0"
                        color:  Theme.primaryColor
                    }
                    Label {
                        id:     grandTotal
                        text:   "0"
                        color:  Theme.primaryColor
                    }
                }
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
                enabled:                    rollNumber !== 3
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
                        rollButton.enabled = false
                        break
                    }
                }
            }
        }
    }

    DockedPanel {
        id:         diceView
        width:      parent.width
        height:     Theme.itemSizeExtraLarge + Theme.paddingLarge
        dock:       Dock.Bottom

        Rectangle {
            anchors.fill:   parent
            color:          Theme.highlightBackgroundColor
            opacity:        Theme.highlightBackgroundOpacity
        }

        Row {
            anchors.centerIn:   parent
            spacing:            Theme.paddingMedium
            Repeater {
                id:     diceRepeater
                model:  diceModel
                Switch {
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

    function rollDie() {
        return Math.floor(Math.random() * 6) + 1
    }

    function calculateAndFill(category) {
        if (rollNumber === 0) return
        var score = 0
        switch(category) {
        case "ones":
            for (var i = 0; i < 5; i++) {
                if (diceModel.get(i).value === 1) score += 1
            }
            score1.text = score
            break
        case "twos":
            for (var i = 0; i < 5; i++) {
                if (diceModel.get(i).value === 2) score += 2
            }
            score2.text = score
            break
        case "threes":
            for (var i = 0; i < 5; i++) {
                if (diceModel.get(i).value === 3) score += 3
            }
            score3.text = score
            break
        case "fours":
            for (var i = 0; i < 5; i++) {
                if (diceModel.get(i).value === 4) score += 4
            }
            score4.text = score
            break
        case "fives":
            for (var i = 0; i < 5; i++) {
                if (diceModel.get(i).value === 5) score += 5
            }
            score5.text = score
            break
        case "sixes":
            for (var i = 0; i < 5; i++) {
                if (diceModel.get(i).value === 6) score += 6
            }
            score6.text = score
            break

        case "chance":
            for (var i = 0; i < 5; i++) {
                score += diceModel.get(i).value
            }
            scoreChance.text = score
            break
        case "topscore":
            var validitycheck = true
            for (var i = 0; i < 4; i++) {
                if (diceModel.get(i).value !== diceModel.get(i+1).value) validitycheck = false
            }
            if (validitycheck) { scoreTopScore.text = 50 } else { scoreTopScore.text = 0 }
            break
        }




        rollNumber = 0
        rollButton.text = qsTr("1st Roll")
        rollButton.enabled = true
        for (var i = 0; i < 5; i++) {
            diceRepeater.itemAt(i).checked = false
        }
        diceView.hide()
    }
}
