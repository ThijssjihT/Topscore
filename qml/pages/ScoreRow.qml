import QtQuick 2.0
import Sailfish.Silica 1.0

// A single scoring row: label on the left, hint in the middle, score on the
// right.  The score column has a fixed reserved width so that every row across
// every section lines up.  The label takes whatever remains and elides if a
// translation is too long.
Item {
    id:                     row

    property string         labelText
    property string         hintText
    property string         scoreText

    property color          labelColor:        Theme.highlightColor
    property color          hintColor:         Theme.secondaryHighlightColor
    property color          scoreColor:        Theme.primaryColor

    property bool           clickable:         false
    property real           scoreColumnWidth:  Theme.itemSizeExtraSmall

    signal                  clicked()

    anchors.left:           parent ? parent.left  : undefined
    anchors.right:          parent ? parent.right : undefined
    height:                 Math.max(labelLbl.height, hintLbl.height, scoreLbl.height)

    Label {
        id:                     scoreLbl
        anchors.right:          parent.right
        anchors.verticalCenter: parent.verticalCenter
        width:                  row.scoreColumnWidth
        horizontalAlignment:    Text.AlignRight
        text:                   row.scoreText
        color:                  row.scoreColor
    }

    Label {
        id:                     hintLbl
        anchors.right:          scoreLbl.left
        anchors.rightMargin:    Theme.paddingLarge
        anchors.verticalCenter: parent.verticalCenter
        text:                   row.hintText
        color:                  row.hintColor
    }

    Label {
        id:                     labelLbl
        anchors.left:           parent.left
        anchors.right:          hintLbl.left
        anchors.rightMargin:    Theme.paddingLarge
        anchors.verticalCenter: parent.verticalCenter
        text:                   row.labelText
        color:                  row.labelColor
        elide:                  Text.ElideRight
    }

    MouseArea {
        anchors.fill:           parent
        enabled:                row.clickable
        onClicked:              row.clicked()
    }
}
