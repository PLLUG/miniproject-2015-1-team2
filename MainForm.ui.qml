import QtQuick 2.3



Rectangle {

    property alias mouseArea: mouseArea

    width: 360
    height: 360

    MouseArea {
        id: mouseArea
        anchors.fill: parent
    }

    Text {
        // Using of pacman font
        font.family: pacmanFont.name

        color: "red"
        anchors.centerIn: parent
        text: "Main Menu"

    }
}
