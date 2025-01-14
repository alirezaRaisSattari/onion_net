import QtQuick 6.5
import QtQuick.Shapes 1.8
import QtQuick.Layouts 1.5
import QtQuick.Controls 6.5
import Pyside_handler 1.0

ApplicationWindow {
    id: main_window
    visible: true
    width: 1000
    height: 600
    color: "#8B5A2B" // Background color for the entire window

    function parseMessage(message) {
    // Regular expression to capture marbles, positions, and dice values
        var regex = /moved\s+(\S+)\s+to\s+(\S+)\s+and\s+(\S+)\s+to\s+(\S+)\s+dice(\d)(\d)/;
        var match = message.match(regex);

        if (match) {
            return {
                marble1: match[1], // First marble
                position1: match[2], // First position
                marble2: match[3], // Second marble
                position2: match[4], // Second position
                dice1: parseInt(match[5]), // First dice value
                dice2: parseInt(match[6])  // Second dice value
            };
        } else {
            console.error("Message format is incorrect.");
            return null;
        }
    }


    Pyside_handler_class {
        id: pyside_backend
        onUpdateSignal: {
            console.log("hiiiiiiiiiiiiiiiiiiiiiiiii")
            // random_lable.text = "Received value: " + message
            console.log(request_opponent_move_backend)
            var result = parseMessage(request_opponent_move_backend);
            // main_window.simulateDrop(draggable_Marble_Dark_2, instance2.dropArea_A6);
            if (result) {
                console.log("Marble 1: " + result.marble1);     // Output: Marble_Dark_2
                console.log("Position 1: " + result.position1); // Output: A1
                console.log("Marble 2: " + result.marble2);     // Output: Marble_Light_2
                console.log("Position 2: " + result.position2); // Output: B3
                console.log("dice1: " + result.dice1)
                console.log("dice2: " + result.dice2)
            }
            dice1_text.text = result.dice1
            dice2_text.text = result.dice2
            main_window.simulateDrop2(result.marble1, result.position1)
        }
    }

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



    function simulateDrop(draggable, dropArea) {
        console.log("///////////////////SIMULATE DROP/////////////////////////");
        let marbleName = draggable.Drag.keys[0]; // Example: "Marble_Light_1"
        console.log("draggable is:", draggable)
        console.log("dropArea is:", dropArea)
        // Check if the draggable or drop area is invalid
        if (!draggable || !dropArea) {
            console.log("Error: Draggable or Drop Area not found!");
            return;
        }

        // Check if the marble is already in the drop area's list
        if (dropArea.draggableList.includes(marbleName)) {
            console.log("Draggable already in drop area:", marbleName);
            return;
        }

        // Handle color-based logic for marbles
        if (dropArea.current_color !== "None") {
            if (dropArea.current_color === "Light") {
                console.log("Current color is Light. Marble count:", dropArea.draggableList.length);

                if (dropArea.draggableList.length === 1) {
                    if (marbleName.includes("Dark")) {
                        // "Hit" scenario: Replace Light with Dark
                        console.log("Hit: Replacing Light with Dark marble.");
                        let removedMarbleName = dropArea.draggableList.pop();
                        console.log("Removed marble:", removedMarbleName);

                        let oldMarble = findMarbleByName(removedMarbleName);

                        if (oldMarble) {
                            main_window.moveToOpponentHitTray(oldMarble);
                        } else {
                            console.log("Could not find marble object for:", removedMarbleName);
                        }

                        dropArea.draggableList.push(marbleName);
                        dropArea.current_color = "Dark"; // Update color to Dark
                        // positionMarbleInDropArea(draggable, dropArea);
                        let isUpsideDown = dropArea.dropName.includes("B"); // Example: Adjust based on naming convention
                        positionMarbleInDropArea(draggable, dropArea, isUpsideDown);
                        console.log("Added Dark marble to drop area after hit:", marbleName);
                    } else {
                        dropArea.draggableList.push(marbleName);
                        console.log("Added Light marble to drop area:", marbleName);
                    }
                } else {
                    if (marbleName.includes("Dark")) {
                        console.log("Cannot push Dark marble into a Light stack with more than 1 marble:", marbleName);
                        return;
                    } else {
                        dropArea.draggableList.push(marbleName);
                        console.log("Added Light marble to drop area:", marbleName);
                    }
                }
            } else if (dropArea.current_color === "Dark") {
                console.log("Current color is Dark. Marble count:", dropArea.draggableList.length);

                if (dropArea.draggableList.length === 1) {
                    if (marbleName.includes("Light")) {
                        // "Hit" scenario: Replace Dark with Light
                        console.log("Hit: Replacing Dark with Light marble.");
                        let removedMarbleName = dropArea.draggableList.pop();
                        console.log("Removed marble:", removedMarbleName);

                        let oldMarble = findMarbleByName(removedMarbleName);

                        if (oldMarble) {
                            main_window.moveToOpponentHitTray(oldMarble);
                        } else {
                            console.log("Could not find marble object for:", removedMarbleName);
                        }

                        dropArea.draggableList.push(marbleName);
                        dropArea.current_color = "Light"; // Update color to Light
                        // positionMarbleInDropArea(draggable, dropArea);
                        let isUpsideDown = dropArea.dropName.includes("B"); // Example: Adjust based on naming convention
                        positionMarbleInDropArea(draggable, dropArea, isUpsideDown);
                        console.log("Added Light marble to drop area after hit:", marbleName);
                    } else {
                        dropArea.draggableList.push(marbleName);
                        console.log("Added Dark marble to drop area:", marbleName);
                    }
                } else {
                    if (marbleName.includes("Light")) {
                        console.log("Cannot push Light marble into a Dark stack with more than 1 marble:", marbleName);
                        return;
                    } else {
                        dropArea.draggableList.push(marbleName);
                        console.log("Added Dark marble to drop area:", marbleName);
                    }
                }
            }
        } else {
            // No marbles in the drop area, determine color and add
            if (marbleName.includes("Light")) {
                dropArea.current_color = "Light";
            } else if (marbleName.includes("Dark")) {
                dropArea.current_color = "Dark";
            }
            dropArea.draggableList.push(marbleName);
            console.log("Added marble to empty drop area:", marbleName);
        }

        // positionMarbleInDropArea(draggable, dropArea);
        let isUpsideDown = dropArea.dropName.includes("B"); // Example: Adjust based on naming convention
        positionMarbleInDropArea(draggable, dropArea, isUpsideDown);
        console.log("Updated drop area stack:", dropArea.draggableList);
    }

    // function positionMarbleInDropArea(draggable, dropArea) {
    //     let stackIndex = dropArea.draggableList.length - 1;
    //     draggable.x = dropArea.x + (dropArea.width - draggable.width) / 2;
    //     draggable.y = dropArea.y + dropArea.height - draggable.height * (stackIndex + 1);
    // }
    // function positionMarbleInDropArea(draggable, dropArea) {/////////////////////////////
    //     // Map drop area position to the draggable's parent
    //     let targetPos = dropArea.mapToItem(draggable.parent, 0, 0);

    //     // Determine the stack position index
    //     let stackIndex = dropArea.draggableList.length - 1;

    //     // Calculate the new x and y positions
    //     draggable.x = targetPos.x + (dropArea.width - draggable.width) / 2; // Center horizontally
    //     draggable.y = targetPos.y + dropArea.height - draggable.height * (stackIndex + 1); // Stack vertically

    //     console.log(`Positioned ${draggable.Drag.keys[0]} at (${draggable.x}, ${draggable.y})`);
    // }

    function positionMarbleInDropArea(draggable, dropArea, isUpsideDown = false) {
        // Map drop area position to the draggable's parent
        let targetPos = dropArea.mapToItem(draggable.parent, 0, 0);

        // Determine the stack position index
        let stackIndex = dropArea.draggableList.length - 1;

        if (isUpsideDown) {
            // Upside-down triangle: Stack from top to bottom
            draggable.x = targetPos.x + (dropArea.width - draggable.width) / 2; // Center horizontally
            draggable.y = targetPos.y + draggable.height * stackIndex; // Stack downward
        } else {
            // Right-side-up triangle: Stack from bottom to top
            draggable.x = targetPos.x + (dropArea.width - draggable.width) / 2; // Center horizontally
            draggable.y = targetPos.y + dropArea.height - draggable.height * (stackIndex + 1); // Stack upward
        }

        console.log(
            `Positioned ${draggable.Drag.keys[0]} at (${draggable.x}, ${draggable.y}) in ${
                isUpsideDown ? "upside-down" : "right-side-up"
            } triangle`
        );
    }


    function findMarbleByName(marbleName) {
        console.log("Finding marble:", marbleName);

        let possibleNames = [
            "Marble_Light_1", "Marble_Light_2", "Marble_Light_3",
            // "Marble_Light_4", "Marble_Light_5", "Marble_Light_6",
            // "Marble_Light_7", "Marble_Light_8", "Marble_Light_9",
            // "Marble_Light_10", "Marble_Light_11", "Marble_Light_12",
            // "Marble_Light_13", "Marble_Light_14", "Marble_Light_15",
            "Marble_Dark_1", "Marble_Dark_2", "Marble_Dark_3",
            // "Marble_Dark_4", "Marble_Dark_5", "Marble_Dark_6",
            // "Marble_Dark_7", "Marble_Dark_8", "Marble_Dark_9",
            // "Marble_Dark_10", "Marble_Dark_11", "Marble_Dark_12",
            // "Marble_Dark_13", "Marble_Dark_14", "Marble_Dark_15"
        ];

        let possibleIds = [
            draggable_Marble_Light_1, draggable_Marble_Light_2, draggable_Marble_Light_3,
            // draggable_Marble_Light_4, draggable_Marble_Light_5, draggable_Marble_Light_6,
            // draggable_Marble_Light_7, draggable_Marble_Light_8, draggable_Marble_Light_9,
            // draggable_Marble_Light_10, draggable_Marble_Light_11, draggable_Marble_Light_12,
            // draggable_Marble_Light_13, draggable_Marble_Light_14, draggable_Marble_Light_15,
            draggable_Marble_Dark_1, draggable_Marble_Dark_2, draggable_Marble_Dark_3,
            // draggable_Marble_Dark_4, draggable_Marble_Dark_5, draggable_Marble_Dark_6,
            // draggable_Marble_Dark_7, draggable_Marble_Dark_8, draggable_Marble_Dark_9,
            // draggable_Marble_Dark_10, draggable_Marble_Dark_11, draggable_Marble_Dark_12,
            // draggable_Marble_Dark_13, draggable_Marble_Dark_14, draggable_Marble_Dark_15
        ];

        for (let i = 0; i < possibleNames.length; i++) {
            if (possibleNames[i] === marbleName) {
                console.log("Found marble:", marbleName);
                console.log("this is the marble:", possibleIds[i])
                return possibleIds[i];
            }
        }

        console.log("Marble not found for name:", marbleName);
        return null;
    }

    function findDropAreaByName(dropAreaName) {
        console.log("Finding drop area:", dropAreaName);

        // let possibleDropAreas = {
        //     "B1": instance1.dropArea_A1, "A2": dropArea_A2, "A3": dropArea_A3,
        //     "A4": dropArea_A4, "A5": dropArea_A5, "A6": dropArea_A6,
        //     "B1": dropArea_B1, "B2": dropArea_B2, "B3": dropArea_B3,
        //     "B4": dropArea_B4, "B5": dropArea_B5, "B6": dropArea_B6
        // };

        let possibleDropAreas = {
            // First Board (instance1)
            "B1": instance1.dropArea_A1, "B2": instance1.dropArea_A2, "B3": instance1.dropArea_A3,
            "B4": instance1.dropArea_A4, "B5": instance1.dropArea_A5, "B6": instance1.dropArea_A6,
            "A13": instance1.dropArea_B1, "A14": instance1.dropArea_B2, "A15": instance1.dropArea_B3,
            "A16": instance1.dropArea_B4, "A17": instance1.dropArea_B5, "A18": instance1.dropArea_B6,

            // Second Board (instance2)
            "B7": instance2.dropArea_A1, "B8": instance2.dropArea_A2, "B9": instance2.dropArea_A3,
            "B10": instance2.dropArea_A4, "B11": instance2.dropArea_A5, "B12": instance2.dropArea_A6,
            "A19": instance2.dropArea_B1, "A20": instance2.dropArea_B2, "A21": instance2.dropArea_B3,
            "A22": instance2.dropArea_B4, "A23": instance2.dropArea_B5, "A24": instance2.dropArea_B6
        };


        if (dropAreaName in possibleDropAreas) {
            console.log("Found drop area:", dropAreaName);
            console.log("drop area is:", possibleDropAreas[dropAreaName])
            return possibleDropAreas[dropAreaName];
        }

        console.log("Drop area not found for name:", dropAreaName);
        return null;
    }


    function simulateDrop2(marbleName, dropAreaName) {
        console.log("///////////////////SIMULATE DROP/////////////////////////");
        console.log(`Marble: ${marbleName}, Drop Area: ${dropAreaName}`);

        let draggable = findMarbleByName(marbleName); // Resolve marble object
        let dropArea = findDropAreaByName(dropAreaName); // Resolve drop area object

        // Check if the draggable or drop area is invalid
        if (!dropArea) {
            console.log("ErrorDrop Area not found!");
            return;
        }
        if (!draggable) {
            console.log("Error: Draggablenot found!");
            return;
        }

        // Check if the marble is already in the drop area's list
        if (dropArea.draggableList.includes(marbleName)) {
            console.log("Draggable already in drop area:", marbleName);
            return;
        }

        // Handle color-based logic for marbles
        if (dropArea.current_color !== "None") {
            if (dropArea.current_color === "Light") {
                console.log("Current color is Light. Marble count:", dropArea.draggableList.length);

                if (dropArea.draggableList.length === 1) {
                    if (marbleName.includes("Dark")) {
                        // "Hit" scenario: Replace Light with Dark
                        console.log("Hit: Replacing Light with Dark marble.");
                        let removedMarbleName = dropArea.draggableList.pop();
                        console.log("Removed marble:", removedMarbleName);

                        let oldMarble = findMarbleByName(removedMarbleName);

                        if (oldMarble) {
                            main_window.moveToOpponentHitTray(oldMarble);
                        } else {
                            console.log("Could not find marble object for:", removedMarbleName);
                        }

                        dropArea.draggableList.push(marbleName);
                        dropArea.current_color = "Dark"; // Update color to Dark
                        let isUpsideDown = dropArea.dropName.includes("B"); // Example: Adjust based on naming convention
                        positionMarbleInDropArea(draggable, dropArea, isUpsideDown);
                        console.log("Added Dark marble to drop area after hit:", marbleName);
                    } else {
                        dropArea.draggableList.push(marbleName);
                        console.log("Added Light marble to drop area:", marbleName);
                    }
                } else {
                    if (marbleName.includes("Dark")) {
                        console.log("Cannot push Dark marble into a Light stack with more than 1 marble:", marbleName);
                        return;
                    } else {
                        dropArea.draggableList.push(marbleName);
                        console.log("Added Light marble to drop area:", marbleName);
                    }
                }
            } else if (dropArea.current_color === "Dark") {
                console.log("Current color is Dark. Marble count:", dropArea.draggableList.length);

                if (dropArea.draggableList.length === 1) {
                    if (marbleName.includes("Light")) {
                        // "Hit" scenario: Replace Dark with Light
                        console.log("Hit: Replacing Dark with Light marble.");
                        let removedMarbleName = dropArea.draggableList.pop();
                        console.log("Removed marble:", removedMarbleName);

                        let oldMarble = findMarbleByName(removedMarbleName);

                        if (oldMarble) {
                            main_window.moveToOpponentHitTray(oldMarble);
                        } else {
                            console.log("Could not find marble object for:", removedMarbleName);
                        }

                        dropArea.draggableList.push(marbleName);
                        dropArea.current_color = "Light"; // Update color to Light
                        let isUpsideDown = dropArea.dropName.includes("B"); // Example: Adjust based on naming convention
                        positionMarbleInDropArea(draggable, dropArea, isUpsideDown);
                        console.log("Added Light marble to drop area after hit:", marbleName);
                    } else {
                        dropArea.draggableList.push(marbleName);
                        console.log("Added Dark marble to drop area:", marbleName);
                    }
                } else {
                    if (marbleName.includes("Light")) {
                        console.log("Cannot push Light marble into a Dark stack with more than 1 marble:", marbleName);
                        return;
                    } else {
                        dropArea.draggableList.push(marbleName);
                        console.log("Added Dark marble to drop area:", marbleName);
                    }
                }
            }
        } else {
            // No marbles in the drop area, determine color and add
            if (marbleName.includes("Light")) {
                dropArea.current_color = "Light";
            } else if (marbleName.includes("Dark")) {
                dropArea.current_color = "Dark";
            }
            dropArea.draggableList.push(marbleName);
            console.log("Added marble to empty drop area:", marbleName);
        }

        let isUpsideDown = dropArea.dropName.includes("B"); // Example: Adjust based on naming convention
        positionMarbleInDropArea(draggable, dropArea, isUpsideDown);
        console.log("Updated drop area stack:", dropArea.draggableList);
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
                    dropArea_A1.dropName: "B1"
                    dropArea_A2.dropName: "B2"
                    dropArea_A3.dropName: "B3"
                    dropArea_A4.dropName: "B4"
                    dropArea_A5.dropName: "B5"
                    dropArea_A6.dropName: "B6"
                    dropArea_B1.dropName: "A13"
                    dropArea_B2.dropName: "A14"
                    dropArea_B3.dropName: "A15"
                    dropArea_B4.dropName: "A16"
                    dropArea_B5.dropName: "A17"
                    dropArea_B6.dropName: "A18"
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
                    dropArea_A1.dropName: "B7"
                    dropArea_A2.dropName: "B8"
                    dropArea_A3.dropName: "B9"
                    dropArea_A4.dropName: "B10"
                    dropArea_A5.dropName: "B11"
                    dropArea_A6.dropName: "B12"
                    dropArea_B1.dropName: "A19"
                    dropArea_B2.dropName: "A20"
                    dropArea_B3.dropName: "A21"
                    dropArea_B4.dropName: "A22"
                    dropArea_B5.dropName: "A23"
                    dropArea_B6.dropName: "A24"
                }
            }

            // Right Drop Area (Rectangle)
            Side_Tray {
                id: rightBearOff
                dropName: "right BearOff"
                width: 50
                Layout.fillHeight: true
            }

            
            // Rectangle {


            //     id: game_status
            //     width: 50 // Fixed width for the right drop area
            //     Layout.fillHeight: true
            //     color: "brown" // Dark brown color for the right drop area
            //     border.width: 2

            //     columnLayout {

            //     }

            // }

            // Rectangle {
            //     id: game_status
            //     width: 50 // Fixed width for the right drop area
            //     Layout.fillHeight: true
            //     color: "brown" // Dark brown color for the right drop area
            //     border.width: 2
            //     ColumnLayout {
            //         id: columnLayout
            //         width: parent.width
            //         height: parent.height
            //         Rectangle {
            //             width: parent.width 
            //             height: parent.height / 3
            //             color: "blue"
            //             Text {
            //                 id: dice1
            //                 text: "dice is "
            //                 anchors.centerIn: parent
            //             }
            //         }

            //         Rectangle {
            //             width: parent.width 
            //             height: parent.height / 3
            //             color: "yellow"
            //             Text {
            //                 id: dice2
            //                 text: "dice is "
            //                 anchors.centerIn: parent
            //             }
            //         }

            //         Button {
            //             height: parent.height / 3
            //             width: parent.width
            //             text: "surrender"
            //         }
            //     }
            // }
            Rectangle {
                id: game_status
                width: 50 // Fixed width for the right drop area
                Layout.fillHeight: true
                color: "brown" // Dark brown color for the right drop area
                border.width: 2

                ColumnLayout {
                    id: columnLayout
                    width: parent.width - 10
                    anchors.fill: parent // Ensures the layout fills the parent rectangle
                    spacing: 0 // No gaps between elements (if needed)

                    Rectangle {
                        Layout.preferredHeight: parent.height / 3
                        Layout.fillWidth: true
                        color: "blue"
                        Text {
                            id: dice1_text
                            text: "dice is "
                            anchors.centerIn: parent
                        }
                    }

                    Rectangle {
                        Layout.preferredHeight: parent.height / 3
                        Layout.fillWidth: true
                        color: "yellow"
                        Text {
                            id: dice2_text
                            text: "dice is "
                            anchors.centerIn: parent
                        }
                    }

                    Button {
                        Layout.preferredHeight: parent.height / 3
                        Layout.fillWidth: true
                        text: "surrender"
                    }
                }
            }

        }
    }
        

    
    Draggable_Marble_Light {
        id: draggable_Marble_Light_1
        is_turn: true
        is_yours: true
        x: 444
        y: 444
        width: main_window.width / 20
        height: main_window.width / 20
        Drag.keys: ["Marble_Light_1"]
    }

    Draggable_Marble_Light {
        id: draggable_Marble_Light_2
        is_turn: true
        is_yours: true
        x: 200
        y: 200
        width: main_window.width / 20
        height: main_window.width / 20
        Drag.keys: ["Marble_Light_2"]
    }
    
    Draggable_Marble_Light {
        id: draggable_Marble_Light_3
                is_turn: true
        is_yours: true
        x: 100
        y: 100
        width: main_window.width / 20
        height: main_window.width / 20
        Drag.keys: ["Marble_Light_3"]
    }

    Draggable_Marble_Dark {
        id: draggable_Marble_Dark_1
        is_turn: true
        x: 500
        y: 500
        width: main_window.width / 20
        height: main_window.width / 20
        Drag.keys: ["Marble_Dark_1"]
    }

    Draggable_Marble_Dark {
        id: draggable_Marble_Dark_2
        is_turn: true
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
        Drag.keys: ["Marble_Dark_3"]
    }

    Button {
        text: "sample for movment"
        onClicked: {
            // main_window.simulateDrop(draggable_Marble_Dark_2, instance2.dropArea_A6);
            pyside_backend.request_opponent_move_backend = "get the opponent move" ////////////////////when my move are done I sould call this
        }
    }

    Text {
        id: random_lable
        text: "some random text"
    }
}

