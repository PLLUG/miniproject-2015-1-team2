import QtQuick 2.4
import QtQuick.Window 2.2
import PacmanSettings 1.0
import QtMultimedia 5.0

Window {

    visible: true
    width: 448
    height: 526
    id: mainWindow

    property string playerName: ""
    property int playerScore: 0

    FontLoader {
        id: pacmanFont
        source: "qrc:/font/Font/PAC-FONT.TTF"
    }

    Audio {
            id: gameMusic
            source: "qrc:/music/Music/Dendy_Music.wav"
            loops: Audio.Infinite
    }

    Audio {
        id: introMusic
        source:"qrc:/music/Music/pacman_beginning.wav"
        loops:0;
    }

    Audio {
        id: dotEatenMusic
        source:"qrc:/music/Music/pacman_chomp.wav"
        loops:0;
    }

    Audio {
        id: fruitEnergizerEatenMusic
        source:"qrc:/music/Music/pacman_eatfruit.wav"
        loops:0;
    }

    // Contains settings for game
    Settings{
        id: settings

        Component.onCompleted: {
            mainWindow.visibility =  settings.fullscreen ? Window.FullScreen : Window.Windowed
            settings.music ? gameMusic.play() : gameMusic.stop()
            gameMusic.volume = settings.volume / 100
            introMusic.volume = settings.volume / 100
            dotEatenMusic.volume = settings.volume / 100
            fruitEnergizerEatenMusic.volume = settings.volume / 100
        }
    }

    // Loads main menu and menu items
    Loader {
        id : loader
        source : "MainMenu.qml"
        anchors.fill: parent

        Connections{
            target : loader.item

            ignoreUnknownSignals: true

            onOptionsClosed: {
                settings.saveSettings()
            }

            onDifficultyChanged: {
                settings.setDifficulty(changedLevel)
            }

            onVolumeChanged: {
                settings.setVolume(changedVolume)
            }

            onFullscreenChanged: {
                settings.setFullscreen(changedFullscreen)
            }

            onMusicChanged: {
                settings.setMusic(changedMusic)
            }

            onSoundEffectsChanged: {
                settings.setSoundEffects(changedSoundEffects)
            }
        }
    }

    // Loader only for Exit!
    Loader {
        anchors.centerIn: parent
        id: loaderForExitWindow
    }

    Connections {
        target : settings

        onFullscreenChanged: {
            mainWindow.visibility =  settings.fullscreen ? Window.FullScreen : Window.Windowed
        }

        onDifficultyChanged: {

        }

        onVolumeChanged: {
            gameMusic.volume = settings.volume / 100
        }

        onMusicChanged: {
            settings.music ? gameMusic.play() : gameMusic.stop()
        }

        onSoundEffectsChanged: {

        }
    }
}

