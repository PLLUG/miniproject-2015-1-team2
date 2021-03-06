import QtQuick 2.4
import QtQuick.Window 2.2

Rectangle {
    id: mainMenu
    visible: true
    color: "black"
    anchors.fill: parent

    property alias mmItem: mmItem

    Item {
        id: mmItem
        anchors.fill: parent

        LogoItem {

            x : parent.width / 2
            y : 25
        }
        Column {

            anchors.centerIn: parent
            spacing: 10

            ItemForButton {

                text: "New Game"

                onClicked: {

                    loader.source = "NewGame.qml"
                }
            }

            ItemForButton {

                text: "Options"

                onClicked: {

                    loader.source = "Options.qml"
                }
            }

            ItemForButton {

                text: "High Scores"

                onClicked: {

                    loader.source = "HighScores.qml"
                }
            }

            ItemForButton {

                text: "Legend"

                onClicked: {

                    loader.source = "Legend1.qml"
                }
            }



             ItemForButton {
                 text: "Exit"

                 onClicked: {
                     loader.item.enabled = false
                     loaderForExitWindow.source = "Exit.qml"
                 }

             }
        }

    }
}

