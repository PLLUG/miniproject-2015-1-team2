import QtQuick 2.4

Rectangle {
    property alias text: txt.text
    width: 100
    height: 20
    radius: 10
    color: "black"
    Text {
        id: txt
        color: "white"
        anchors.centerIn: parent
    }
    MouseArea {
        id: mousearea
        anchors.fill: parent
        hoverEnabled: true
        onEntered: parent.color = "grey"
        onExited: parent.color = "black"
    }
}


