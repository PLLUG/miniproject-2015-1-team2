import QtQuick 2.4
import QtQuick.Window 2.2

Window {

    visible: true
    width: 360
    height: 360

    FontLoader {
        id: pacmanFont
        source: "qrc:/font/Font/PAC-FONT.TTF"
    }

    // Loads main menu and menu items
    Loader {
        id : loader
        source : "MainMenu.qml"
    }

    // Loader only for Exit!
    Loader {

        id: loaderForExitWindow
    }
}

