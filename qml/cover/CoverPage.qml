import QtQuick 2.0
import Sailfish.Silica 1.0

CoverBackground {
    Image {
        anchors.fill:   parent
        source:         "../assets/coverdie.png"
        fillMode:       Image.PreserveAspectFit
        opacity:        0.35
    }

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
            visible:                    scoreStore.currentTotal > 0
        }
        Label {
            anchors.horizontalCenter:   parent.horizontalCenter
            visible:                    scoreStore.currentTotal > 0
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

        Label {
            anchors.horizontalCenter:   parent.horizontalCenter
            visible:                    !(scoreStore.currentTotal > 0)
            text:                       qsTr("Last finished game:")
            color:                      Theme.secondaryColor
        }
        Label {
            anchors.horizontalCenter:   parent.horizontalCenter
            visible:                    !(scoreStore.currentTotal > 0)
            text:                       scoreStore.previousTotal
            font.pixelSize:             Theme.fontSizeHuge
            color:                      Theme.primaryColor
        }
        Label {
            anchors.horizontalCenter:   parent.horizontalCenter
            visible:                    !(scoreStore.currentTotal > 0)
            //: %1 = player's rank, 1 = best ever
            text:                       qsTr("rank %1").arg(scoreStore.previousRank)
            color:                      Theme.highlightColor
        }
    }
}
