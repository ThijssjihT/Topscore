import QtQuick 2.0
import Sailfish.Silica 1.0

CoverBackground {
    Column {
        anchors.centerIn:   parent
        spacing:            Theme.paddingSmall
        width:              parent.width

        Label {
            anchors.horizontalCenter:   parent.horizontalCenter
            text:                       qsTr("Top Score")
            color:                      Theme.secondaryColor
        }
        Label {
            anchors.horizontalCenter:   parent.horizontalCenter
            text:                       qsTr("Current game:")
            color:                      Theme.secondaryColor
        }
        Label {
            anchors.horizontalCenter:   parent.horizontalCenter
            text:                       scoreStore.currentTotal
            font.pixelSize:             Theme.fontSizeHuge
            color:                      Theme.primaryColor
        }
        Label {
            anchors.horizontalCenter:   parent.horizontalCenter
            visible:                    scoreStore.currentTotal > 0
            //: %1 = player's rank, 1 = best ever
            text:                       qsTr("rank %1").arg(scoreStore.currentRank)
            color:                      Theme.highlightColor
        }
    }
}
