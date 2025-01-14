import QtQuick 6.5
import QtQuick.Shapes 1.8
import QtQuick.Layouts 1.5
import QtQuick.Controls 6.5

ApplicationWindow {
    id: main_window
    visible: true
    width: 1000
    height: 600
    color: "#8B5A2B" // Background color for the entire window


    function moveToOpponentHitTray(marbleObject) {
        console.log("Moving marble:", marbleObject, "to opponent hit tray.");

        if (!marbleObject || !marbleObject.Drag || !marbleObject.Drag.keys || marbleObject.Drag.keys.length === 0) {
        console.log("Error: Invalid marble object or Drag.keys is undefined.");
        return;
        }

        // Add the marble to the opponent_hit tray's draggableList
        let marbleName = marbleObject.Drag.keys[0]; // Example: "Marble_Dark_1"
        // Use specific IDs or aliases for known draggable items
        let hitMarble = null;
        if (draggable_Marble_Light_1.Drag.keys.includes(marbleName)) {
            hitMarble = draggable_Marble_Light_1;
        } else if (draggable_Marble_Light_2.Drag.keys.includes(marbleName)) {
            hitMarble = draggable_Marble_Light_2;
        } else if (draggable_Marble_Light_3.Drag.keys.includes(marbleName)) {
            hitMarble = draggable_Marble_Light_3;
        // } else if (draggable_Marble_Light_4.Drag.keys.includes(marbleName)) {
        //     hitMarble = draggable_Marble_Light_4;
        // } else if (draggable_Marble_Light_5.Drag.keys.includes(marbleName)) {
        //     hitMarble = draggable_Marble_Light_5;
        // } else if (draggable_Marble_Light_6.Drag.keys.includes(marbleName)) {
        //     hitMarble = draggable_Marble_Light_6;
        // } else if (draggable_Marble_Light_7.Drag.keys.includes(marbleName)) {
        //     hitMarble = draggable_Marble_Light_7;
        // } else if (draggable_Marble_Light_8.Drag.keys.includes(marbleName)) {
        //     hitMarble = draggable_Marble_Light_8;
        // } else if (draggable_Marble_Light_9.Drag.keys.includes(marbleName)) {
        //     hitMarble = draggable_Marble_Light_9;
        // } else if (draggable_Marble_Light_10.Drag.keys.includes(marbleName)) {
        //     hitMarble = draggable_Marble_Light_10;
        // } else if (draggable_Marble_Light_11.Drag.keys.includes(marbleName)) {
        //     hitMarble = draggable_Marble_Light_11;
        // } else if (draggable_Marble_Light_12.Drag.keys.includes(marbleName)) {
        //     hitMarble = draggable_Marble_Light_12;
        } else if (draggable_Marble_Dark_1.Drag.keys.includes(marbleName)) {
            hitMarble = draggable_Marble_Dark_1;
        } else if (draggable_Marble_Dark_2.Drag.keys.includes(marbleName)) {
            hitMarble = draggable_Marble_Dark_2;
        } else if (draggable_Marble_Dark_3.Drag.keys.includes(marbleName)) {
            hitMarble = draggable_Marble_Dark_3;
        // } else if (draggable_Marble_Dark_4.Drag.keys.includes(marbleName)) {
        //     hitMarble = draggable_Marble_Dark_4;
        // } else if (draggable_Marble_Dark_5.Drag.keys.includes(marbleName)) {
        //     hitMarble = draggable_Marble_Dark_5;
        // } else if (draggable_Marble_Dark_6.Drag.keys.includes(marbleName)) {
        //     hitMarble = draggable_Marble_Dark_6;
        // } else if (draggable_Marble_Dark_7.Drag.keys.includes(marbleName)) {
        //     hitMarble = draggable_Marble_Dark_7;
        // } else if (draggable_Marble_Dark_8.Drag.keys.includes(marbleName)) {
        //     hitMarble = draggable_Marble_Dark_8;
        // } else if (draggable_Marble_Dark_9.Drag.keys.includes(marbleName)) {
        //     hitMarble = draggable_Marble_Dark_9;
        // } else if (draggable_Marble_Dark_10.Drag.keys.includes(marbleName)) {
        //     hitMarble = draggable_Marble_Dark_10;
        // } else if (draggable_Marble_Dark_11.Drag.keys.includes(marbleName)) {
        //     hitMarble = draggable_Marble_Dark_11;
        // } else if (draggable_Marble_Dark_12.Drag.keys.includes(marbleName)) {
        //     hitMarble = draggable_Marble_Dark_12;
        } else {
            console.log("Marble not found for:", marbleName);
        }

        if (!hitMarble) {
            console.log("Error: Marble not found for:", marbleName);
            return;
        }

        // Add the marble to the opponent_hit tray's draggableList
        if (!opponent_hit.draggableList.includes(marbleName)) {
            opponent_hit.draggableList.push(marbleName);
            console.log("Added marble to opponent_hit tray:", marbleName);
        } else {
            console.log("Marble already in opponent_hit tray:", marbleName);
        }
        // Position the marble inside the opponent_hit tray
        let marbleCount = opponent_hit.draggableList.length;
        hitMarble.x = opponent_hit.x + (opponent_hit.width - hitMarble.width) / 2 + 7;
        hitMarble.y = opponent_hit.y + opponent_hit.height - (hitMarble.height * marbleCount);

        console.log("Moved marble:", marbleName, "to opponent_hit tray at position:", hitMarble.x, hitMarble.y);
    }

    // Outer border
    Rectangle {
        id: borderContainer
        anchors.fill: parent
        border.color: "black"
        border.width: 5
        color: "#A0522D" // Border color around the boards

        RowLayout {
            id: mainLayout
            anchors.fill: parent
            anchors.margins: 10 // Add margins to create spacing around inner content
            spacing: 10 // Increased spacing between the elements

            Side_Tray {
                id: leftBearOff
                dropName: "left BearOff"
                width: 50
                Layout.fillHeight: true
            }
            // First Board Container
            Rectangle {
                id: board1Container
                Layout.fillHeight: true
                Layout.fillWidth: true
                border.color: "black"
                border.width: 3
                color: "#D2691E" // Light brown color for the first board

                // First MainPage
                MainPage {
                    id: instance1
                    anchors.fill: parent // Fill the container
                    backgroundColor: "blue"

                    // Drop area settings
                    dropArea_A1.dropName: "1"
                    dropArea_A2.dropName: "2"
                    dropArea_A3.dropName: "3"
                    dropArea_A4.dropName: "4"
                    dropArea_A5.dropName: "5"
                    dropArea_A6.dropName: "6"
                    dropArea_B1.dropName: "13"
                    dropArea_B2.dropName: "14"
                    dropArea_B3.dropName: "15"
                    dropArea_B4.dropName: "16"
                    dropArea_B5.dropName: "17"
                    dropArea_B6.dropName: "18"
                }
            }

            Side_Tray {
                id: opponent_hit
                dropName: "left BearOff"
                width: 50
                Layout.fillHeight: true
            }

            // Second Board Container
            Rectangle {
                id: board2Container
                Layout.fillHeight: true
                Layout.fillWidth: true
                border.color: "black"
                border.width: 3
                color: "#D2691E" // Light brown color for the second board

                // Second MainPage
                MainPage {
                    id: instance2
                    anchors.fill: parent // Fill the container
                    backgroundColor: "green"

                    // Drop area settings
                    dropArea_A1.dropName: "7"
                    dropArea_A2.dropName: "8"
                    dropArea_A3.dropName: "9"
                    dropArea_A4.dropName: "10"
                    dropArea_A5.dropName: "11"
                    dropArea_A6.dropName: "12"
                    dropArea_B1.dropName: "19"
                    dropArea_B2.dropName: "20"
                    dropArea_B3.dropName: "21"
                    dropArea_B4.dropName: "22"
                    dropArea_B5.dropName: "23"
                    dropArea_B6.dropName: "24"
                }
            }

            // Right Drop Area (Rectangle)
            Side_Tray {
                id: rightBearOff
                dropName: "right BearOff"
                width: 50
                Layout.fillHeight: true
            }
        }
    }

    
    Draggable_Marble_Light {
        id: draggable_Marble_Light_1
        x: 100
        y: 100
        width: main_window.width / 20
        height: main_window.width / 20
        Drag.keys: ["Marble_Light_1"]
    }

    Draggable_Marble_Light {
        id: draggable_Marble_Light_2
        x: 200
        y: 200
        width: main_window.width / 20
        height: main_window.width / 20
        Drag.keys: ["Marble_Light_2"]
    }
    
    Draggable_Marble_Light {
        id: draggable_Marble_Light_3
        x: 100
        y: 100
        width: main_window.width / 20
        height: main_window.width / 20
        Drag.keys: ["Marble_Light_3"]
    }

    Draggable_Marble_Dark {
        id: draggable_Marble_Dark_1
        is_turn: false
        x: 500
        y: 500
        width: main_window.width / 20
        height: main_window.width / 20
        Drag.keys: ["Marble_Dark_1"]
    }

    Draggable_Marble_Dark {
        id: draggable_Marble_Dark_2
        is_turn: false
        is_yours: true
        x: 333
        y: 333
        width: main_window.width / 20
        height: main_window.width / 20
        Drag.keys: ["Marble_Dark_2"]
    }
    Draggable_Marble_Dark {
        id: draggable_Marble_Dark_3
        is_turn: true
        is_yours: true
        x: 333
        y: 333
        width: main_window.width / 20
        height: main_window.width / 20
        Drag.keys: ["Marble_Dark_2"]
    }
}

