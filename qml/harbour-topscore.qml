import QtQuick 2.0
import Sailfish.Silica 1.0
import "pages"

ApplicationWindow {
    property alias scoreStore: theStore

    ScoreStore { id: theStore }

    initialPage: Component { Topscore { } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: defaultAllowedOrientations
}
