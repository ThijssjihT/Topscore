import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id:                     page
    allowedOrientations:    Orientation.All

    property int            justFinishedScore: -1
    property int            justFinishedRank:  -1

    property var            top: []

    Component.onCompleted:  top = scoreStore.topScores(10)

    SilicaListView {
        anchors.fill:   parent
        model:          top

        PullDownMenu {
            MenuItem {
                text:       qsTr("New game")
                onClicked:  pageStack.animatorReplace(
                                Qt.resolvedUrl("Topscore.qml"))
            }
        }

        header: Column {
            width:      page.width
            spacing:    Theme.paddingMedium

            PageHeader { title: qsTr("Top scores") }

            Item {
                visible:    justFinishedScore >= 0
                width:      parent.width
                height:     finishedCol.height + 2 * Theme.paddingLarge

                Column {
                    id:                 finishedCol
                    anchors.centerIn:   parent
                    spacing:            Theme.paddingSmall

                    Label {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text:   qsTr("Your score")
                        color:  Theme.secondaryHighlightColor
                    }
                    Label {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text:           justFinishedScore
                        font.pixelSize: Theme.fontSizeHuge
                        color:          Theme.highlightColor
                    }
                    Label {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text:   qsTr("Rank %1").arg(justFinishedRank)
                        color:  Theme.secondaryHighlightColor
                    }
                }
            }

            SectionHeader {
                visible: top.length > 0
                text:    qsTr("Best of all time")
            }
        }

        delegate: ListItem {
            contentHeight:  Theme.itemSizeSmall
            width:          page.width

            Label {
                id:                     rankLbl
                anchors.left:           parent.left
                anchors.leftMargin:     Theme.horizontalPageMargin
                anchors.verticalCenter: parent.verticalCenter
                width:                  Theme.itemSizeExtraSmall
                horizontalAlignment:    Text.AlignRight
                text:                   (index + 1) + "."
                color:                  Theme.secondaryColor
            }
            Label {
                anchors.left:           rankLbl.right
                anchors.leftMargin:     Theme.paddingLarge
                anchors.verticalCenter: parent.verticalCenter
                text:                   modelData.score
                color:                  Theme.primaryColor
            }
            Label {
                anchors.right:          parent.right
                anchors.rightMargin:    Theme.horizontalPageMargin
                anchors.verticalCenter: parent.verticalCenter
                text:                   new Date(modelData.date)
                                            .toLocaleDateString(
                                                Qt.locale(),
                                                Locale.ShortFormat)
                color:                  Theme.secondaryColor
            }
        }
    }
}
