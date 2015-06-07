import QtQuick 2.4
import QtQuick.Window 2.2
import "FieldCollisionAndObjects.js" as Field

Rectangle {
    id: game
    width: 448
    height: 526
    color: "black"

    property int pacmanSpawnX : 4
    property int pacmanSpawnY : 14 * 16 - 4
    property bool needToTurn : false
    property string currentRotation: "right"
    property string prefferedRotation: ""

    // Map implemantation
    Image {
        source: "qrc:/images/Images/field.png"

        width: 448
        height: 496
        anchors{
            right: parent.right
            left: parent.left
            top: parent.top
        }

        GridView{
            id: idField
            width: 448
            height: 496
            interactive: false
            anchors{
                right: parent.right
                left: parent.left
                top: parent.top
            }

            cellHeight: Field.tiles["tileheight"]
            cellWidth: Field.tiles["tilewidth"]
            model: TileField.tilesNumber()
            delegate: Item {
                width: idField.cellWidth;
                height: idField.cellHeight
                objectName: "objectOnMap" + model.index

                Image{
                    objectName: "myImg"
                    anchors.fill: parent
                    cache: false
                    source: TileField.tileHasDot(index) ?
                                "qrc:/images/Images/dot.png" : TileField.tileHasEnergizer(index) ?
                                    "qrc:/images/Images/energizer.png" :
                                    TileField.tileHasFruit(index) ? "qrc:/images/Images/fruit.png" : ""
                    visible: !TileField.tileIsWall(index) || !TileField.tileIsEmptyPass(index)
                }
            }
        }
    }

    GameScoreItem {
        id: scoreItem
        anchors {
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
        }
    }

    GameButton {
        id: gbUp
        text:"Up"
        onClicked: {
            if(game.currentRotation.localeCompare("up") !== 0){
                game.needToTurn = true
                game.prefferedRotation = "up"
            }
            eating.running = true
            sprite.checkPacmanState()
        }
        x: 150
        y: 280
    }

    GameButton {
        id: gbDown
        text:"Down"
        onClicked: {
            if(game.currentRotation.localeCompare("down") !== 0){
                game.needToTurn = true
                game.prefferedRotation = "down"
            }
            eating.running = true
            sprite.checkPacmanState()
        }
        x: 150
        y: 320
    }

    GameButton {
        id: gbRight
        text:"Right"
        onClicked: {
            if(game.currentRotation.localeCompare("right") !== 0){
                game.needToTurn = true
                game.prefferedRotation = "right"
            }
            eating.running = true
            sprite.checkPacmanState()
        }

        x: 180
        y: 300
    }

    GameButton {
        id: gbLeft
        text:"Left"
        onClicked: {
            if(game.currentRotation.localeCompare("left") !== 0){
                game.needToTurn = true
                game.prefferedRotation = "left"
            }
            eating.running = true
            sprite.checkPacmanState()
        }
        x: 120
        y: 300
    }

    Item {
        id: sprite
        width: 24
        height: 24
        x: game.pacmanSpawnX
        y: game.pacmanSpawnY
        visible: true
        rotation: 0
        property alias eating: eating.frameDuration
        signal dotEaten()
        signal energizerEaten()
        signal fruitEaten()

        function increaseScoreBy(number){

            var newNumber = parseInt(scoreItem.scoreText, "10") + number
            var s = "0000" + newNumber;
            scoreItem.scoreText = s.substr(s.length-4);
        }

        function startAnimation(rotation){
            switch(rotation){
            case "right":
                sprite.rotation =  0
                right.start();
                break;
            case "left":
                sprite.rotation =  180
                left.start();
                break;
            case "up":
                sprite.rotation =  270
                up.start();
                break;
            case "down":
                sprite.rotation =  90
                down.start();
                break;
            }
        }

        function stopAnimation(rotation){
            switch(rotation){
            case "right":
                right.stop();
                break;
            case "left":
                left.stop();
                break;
            case "up":
                up.stop();
                break;
            case "down":
                down.stop();
                break;
            }
        }

        function eatObject(index, objectType){
            for(var i = index - 1; i < index + 1; ++i) {
                var item = idField.contentItem.children[i];
                if (!item.objectName.localeCompare("objectOnMap" + index)){
                    for(var j = 0; j < item.children.length; ++j) {
                        var image = item.children[j];
                        if (!image.objectName.localeCompare("myImg")){
                            image.visible = false
                        }
                    }
                }
            }

            switch(objectType){
            case "dot":
                dotEaten()
                break;
            case "fruit":
                fruitEaten()
                break;
            case "energizer":
                energizerEaten()
                break;
            }
        }

        function isInTileCenter(){
            console.log((sprite.x + 4) + " " + (sprite.y + 4))
            if((sprite.x + 4) % 16 === 0 && (sprite.y + 4) % 16 === 0)
                return true;
            return false;
        }

        function checkOperation(oper, rotation, index){

            // const int cMapWall = 0;
            // const int cMapEmpty = 1;
            // const int cMapDot = 2;
            // const int cMapEnergizer = 3;
            // const int cMapFruit = 4;
            // const int cMapDotAndWall = 5;
            // const int cMapEnergizerAndWall = 6;
            // const int cMapFruitAndWall = 7;

            switch(oper){
            case 0:
                sprite.stopAnimation(rotation)
                if(!game.needToTurn)
                    game.currentRotation = "";
                break;
            case 1:
                if(game.prefferedRotation.localeCompare(rotation) === 0){
                    game.needToTurn = false
                    game.prefferedRotation = ""
                    game.currentRotation = rotation
                }
                sprite.startAnimation(rotation)
                break;
            case 2:
                if(game.prefferedRotation.localeCompare(rotation) === 0){
                    game.needToTurn = false
                    game.prefferedRotation = ""
                    game.currentRotation = rotation
                }
                sprite.eatObject(index, "dot")
                sprite.startAnimation(rotation)
                break;
            case 3:
                if(game.prefferedRotation.localeCompare(rotation) === 0){
                    game.needToTurn = false
                    game.prefferedRotation = ""
                    game.currentRotation = rotation
                }
                sprite.eatObject(index, "energizer")
                sprite.startAnimation(rotation)
                break;
            case 4:
                if(game.prefferedRotation.localeCompare(rotation) === 0){
                    game.needToTurn = false
                    game.prefferedRotation = ""
                    game.currentRotation = rotation
                }
                sprite.eatObject(index, "fruit")
                sprite.startAnimation(rotation)
                break;
            case 5:
                sprite.eatObject(index, "dot")
                sprite.stopAnimation(rotation)
                if(!game.needToTurn)
                    currentRotation = ""
                break;
            case 6:
                sprite.eatObject(index, "energizer")
                sprite.stopAnimation(rotation)
                if(!game.needToTurn)
                    currentRotation = ""
                break;
            case 7:
                sprite.eatObject(index, "fruit")
                sprite.stopAnimation(rotation)
                if(!game.needToTurn)
                    currentRotation = ""
                break;
            }
        }

        function checkPacmanState(){
            var rotation
            if(game.needToTurn)
                rotation = game.prefferedRotation;
            else
                rotation = game.currentRotation;

            TileField.checkPacmanState(sprite.x + 12, sprite.y + 12, rotation)
            var result = TileField.operIndexList()
            var oper = result[0]
            var index = result[1]

            if(game.needToTurn){
                if(sprite.isInTileCenter())
                    console.log("needToTurn + isInTileCenter + oper: " + oper)
                    sprite.checkOperation(oper, rotation, index);
//                if(oper === 1 || oper === 2 || oper === 3 || oper === 4){
//                    if(sprite.isInTileCenter()){
//                        game.needToTurn = false
//                        game.prefferedRotation = ""
//                        game.currentRotation = rotation
//                        switch(rotation){
//                        case "right":
//                            sprite.rotation =  0
//                            right.start()
//                            return;
//                        case "left":
//                            sprite.rotation =  180
//                            left.start()
//                            return;
//                        case "up":
//                            sprite.rotation =  270
//                            up.start()
//                            return;
//                        case "down":
//                            sprite.rotation = 90
//                            down.start()
//                            return;
//                        }
//                    }
//                }

                TileField.checkPacmanState(sprite.x + 12, sprite.y + 12, game.currentRotation)
                var oper_ = TileField.operIndexList()[0]
                var index_ = TileField.operIndexList()[1]
                checkOperation(oper_, game.currentRotation, index_)
            }
            else
                checkOperation(oper, rotation, index)
        }

        AnimatedSprite {
            id: eating
            source: "qrc:images/PacmanSprite.png"
            anchors.fill: sprite
            frameHeight: 32
            frameWidth: 32
            running: true
            frameCount: 18
            frameDuration: 18
            width: 24
            height: 24

            Component.onCompleted: {
                right.start()
            }
        }

        NumberAnimation on y {
            id: up
            to: sprite.y - 4
            duration: 100
            running: false

            onStopped: {
                sprite.checkPacmanState();
            }

            //            onStopped: {
            //                sprite.checkPacmanState("up");
            //            }
        }

        NumberAnimation on y {
            id: down
            to: sprite.y + 4
            duration: 100
            running: false

            onStopped: {
                sprite.checkPacmanState();
            }

            //            onStopped: {
            //                sprite.checkPacmanState("down");
            //            }
        }

        NumberAnimation on x {
            id: left
            to: sprite.x - 4
            duration: 100
            running: false

            onStopped: {
                sprite.checkPacmanState();
            }

            //            onStopped: {
            //                sprite.checkPacmanState("left");
            //            }
        }

        NumberAnimation on x {
            id: right
            to: sprite.x + 4
            duration: 100
            running: false

            onStopped: {
                sprite.checkPacmanState();
            }

            //            onStopped: {
            //                sprite.checkPacmanState("right");
            //            }
        }
    }

    ItemForGhost {
        id: blinky
        x: game.width / 2 - 30
        y: game.height / 2 - 40
        frameX: 0
        frameY: 80
        speed: 100
        running: true
    }

    ItemForGhost {
        id: pinky
        x: game.width / 2 + 30
        y: game.height / 2 - 40
        frameX: 0
        frameY: 100
        speed: 200
        running: true
    }

    ItemForGhost {
        id: inky
        x: game.width / 2 - 30
        y: game.height / 2 - 20
        frameX: 0
        frameY: 120
        speed: 150
        running: true
    }
    ItemForGhost {
        id: clyde
        x: game.width / 2 + 30
        y: game.height / 2 - 20
        frameX: 0
        frameY: 140
        speed: 300
        running: true
    }

    GameButton {
        id: back
        text: "Back"
        onClicked: {
            loader.source = "MainMenu.qml"
            introMusic.stop()
            settings.music ? gameMusic.play() : gameMusic.stop()
        }
        x: 35
        y: game.height - 30
    }

    GameButton {
        text: "Pause"
        onClicked: {

            if(eating.running == true)
            {
                introMusic.stop()
                eating.running = false
                game.currentRotation = ""
                game.prefferedRotation = ""
                game.needToTurn = false
                gbUp.enabled = false
                gbDown.enabled = false
                gbLeft.enabled = false
                gbRight.enabled = false
                Keys.enabled = false


                /*inky.moveUp = false
                inky.moveDown = false
                inky.moveLeft = false
                inky.moveRight = false

                pinky.moveUp = false
                pinky.moveDown = false
                pinky.moveLeft = false
                pinky.moveRight = false

                blinky.moveUp = false
                blinky.moveDown = false
                blinky.moveLeft = false
                blinky.moveRight = false

                clyde.moveUp = false
                clyde.moveDown = false
                clyde.moveLeft = false
                clyde.moveRight = false*/
            }
            else
            {
                gbUp.enabled = true
                gbDown.enabled = true
                gbLeft.enabled = true
                gbRight.enabled = true
                Keys.enabled = true

                if(sprite.rotation == 0)
                {
                    if(game.currentRotation.localeCompare("right") !== 0){
                        game.needToTurn = true
                        game.prefferedRotation = "right"
                    }
                    eating.running = true
                    sprite.checkPacmanState()
                }

                else if(sprite.rotation == 180)
                {
                    if(game.currentRotation.localeCompare("left") !== 0){
                        game.needToTurn = true
                        game.prefferedRotation = "left"
                    }
                    eating.running = true
                    sprite.checkPacmanState()
                }

                else if(sprite.rotation == 90)
                {
                    if(game.currentRotation.localeCompare("down") !== 0){
                        game.needToTurn = true
                        game.prefferedRotation = "down"
                    }
                    eating.running = true
                    sprite.checkPacmanState()
                }

                else if(sprite.rotation == 270)
                {
                    if(game.currentRotation.localeCompare("up") !== 0){
                        game.needToTurn = true
                        game.prefferedRotation = "up"
                    }
                    eating.running = true
                    sprite.checkPacmanState()
                }
            }
        }
        x:20
        y: 20
    }

    Keys.onUpPressed: {
        sprite.rotation =  270
        up.running = true
        down.running = false
        left.running = false
        right.running = false
    }

    Keys.onDownPressed:{
        sprite.rotation = 90
        up.running = false
        down.running = true
        left.running = false
        right.running = false
    }

    Keys.onLeftPressed: {
        sprite.rotation = 180
        up.running = false
        down.running = false
        left.running = true
        right.running = false
    }

    Keys.onRightPressed: {
        sprite.rotation = 0
        up.running = false
        down.running = false
        left.running = false
        right.running = true
    }

    Item {
        Timer {
            id: timer
            running: false
            interval: 10000

            onTriggered: {
                sprite.scale = 1
                sprite.eating = 18
                blinky.frameX = 0
                blinky.frameY = 80
                pinky.frameX = 0
                pinky.frameY = 100
                inky.frameX = 0
                inky.frameY = 120
                clyde.frameX = 0
                clyde.frameY = 140
            }
        }

        Timer {
            id: timer2
            running: false
            interval: 7000

            onTriggered: {
                sprite.scale = 1
                sprite.eating = 18
                blinky.frameX = 20
                blinky.frameY = 160
                pinky.frameX = 20
                pinky.frameY = 160
                inky.frameX = 20
                inky.frameY = 160
                clyde.frameX = 20
                clyde.frameY = 160
            }
        }
    }

    focus: true

    Connections {
        target: sprite

        onDotEaten: {
            sprite.increaseScoreBy(10)
            settings.soundEffects ? dotEatenMusic.play() : dotEatenMusic.stop()
        }

        onEnergizerEaten: {
            sprite.increaseScoreBy(40)
            settings.soundEffects ? fruitEnergizerEatenMusic.play() : fruitEnergizerEatenMusic.stop()
            sprite.scale = 1.2
            sprite.eating = 10
            timer.start()
            timer2.start()
            inky.frameX = 0
            inky.frameY = 160
            blinky.frameX = 0
            blinky.frameY = 160
            pinky.frameX = 0
            pinky.frameY = 160
            clyde.frameX = 0
            clyde.frameY = 160
        }

        onFruitEaten: {
            sprite.increaseScoreBy(200)
            settings.soundEffects ? fruitEnergizerEatenMusic.play() : fruitEnergizerEatenMusic.stop()
        }
    }
}
