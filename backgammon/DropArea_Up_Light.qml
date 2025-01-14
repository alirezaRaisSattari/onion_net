import QtQuick 2.15
import QtQuick.Shapes 1.8
import Pyside_handler 1.0


Rectangle {
    id: triangleContainer
    width: 120
    height: 300
    color: "transparent"

    property bool marbleHovered: false  // Tracks hover state
    property string dropName: ""

    property int marble_numbers: 0                  // Number of marbles
    property var draggableList: []                    // List of marble identifiers
    property string current_color: "None" 

    Pyside_handler_class {
        id: handler
    }
    
    Shape {
        id: triangle
        width: parent.width
        height: parent.height
        anchors.fill: parent

        ShapePath {
            strokeWidth: 2
            strokeColor: marbleHovered ? "gold" : "black" // Change color on hover
            fillGradient: LinearGradient {
                x1: 0; y1: 0
                x2: width; y2: height
                GradientStop { position: 0; color: marbleHovered ? "sienna" : "rosybrown" }
                GradientStop { position: 1; color: "tan" }
            }
            startX: width / 2; startY: 0
            PathLine { x: width; y: height }  // Bottom-right
            PathLine { x: 0; y: height }     // Bottom-left
            PathLine { x: width / 2; y: 0 } // Close back to the top
        }
    }

    DropArea {
        anchors.fill: parent
        onEntered: {
            marbleHovered = true;
            console.log("Drag entered drop area: ", dropName);
        }
        onDropped: {
            console.log("///////////////////DROP/////////////////////////");
            let droppedKeys = drag.source.Drag.keys;
            let marbleName = droppedKeys[0]; // Example: "Marble_Light_1"
            marbleHovered = false;

            // Check if the marble is already in the list
            if (draggableList.includes(marbleName)) {
                console.log("Draggable already in drop area:", marbleName);
                drag.source.x = drag.source.previousX;
                drag.source.y = drag.source.previousY;
                return;
            }

            if (current_color != "None")
            {
                if (current_color == "Light")
                {
                    console.log("current number is!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!", draggableList.length)
                    if (draggableList.length == 1) {
                        if (marbleName.includes("Dark")){
                            // put the one inside the draggableList in the middle
                            // put the black one in the drop area.
                            // "Hit" scenario: Replace Dark with Light
                            console.log("Hit: Replacing Light with Dark marble.");
                            let removedMarbleName = draggableList.pop(); // Remove the Dark marble's name
                            console.log("Removed marble:", removedMarbleName);

                            let oldMarble = null;
                            for (let child of drag.source.parent.children) {
                                if (child.Drag && child.Drag.keys.includes(removedMarbleName)) {
                                    oldMarble = child;
                                    break;
                                }
                            }
                            // Move the old marble to the desired position (e.g., middle of the board)
                            if (oldMarble) {
                                main_window.moveToOpponentHitTray(oldMarble);
                            } else {
                                console.log("Could not find marble object for:", removedMarbleName);
                            }
                            draggableList.push(marbleName); // Add the Light marble
                            current_color = "Dark"; // Update the current color

                            let targetPos = triangleContainer.mapToItem(drag.source.parent, 0, 0);
                            drag.source.x = targetPos.x + (triangleContainer.width - drag.source.width) / 2;
                            drag.source.y = targetPos.y + triangleContainer.height - (drag.source.height);

                            handler.move_string_backend = marbleName + " moved to " + dropName//////////////////////////////////////////////////////////////////


                            console.log("Current draggable list:", draggableList);


                            return; // Prevent further execution
                        }
                        else {
                            draggableList.push(marbleName);
                            console.log("Added draggable:", marbleName, "to drop area:", dropName);
                            handler.move_string_backend = marbleName + " moved to " + dropName//////////////////////////////////////////////////////////////////

                        } 
                    }
                    else {
                        if (marbleName.includes("Dark")){
                            // dont push
                            console.log("cant push to the drop with more than 1 drags!:", marbleName);
                            drag.source.x = drag.source.previousX;
                            drag.source.y = drag.source.previousY;
                            return
                        }
                        else {
                            draggableList.push(marbleName);
                            console.log("Added draggable:", marbleName, "to drop area:", dropName);
                            handler.move_string_backend = marbleName + " moved to " + dropName//////////////////////////////////////////////////////////////////

                        }  
                    }
                }
                if (current_color == "Dark")
                {
                    if (draggableList.length == 1) {
                        if (marbleName.includes("Light")){
                            // put the one inside the draggableList in the middle
                            // put the black one in the drop area.
                            // "Hit" scenario: Replace Dark with Light
                            console.log("Hit: Replacing Dark with Light marble.");
                            let removedMarbleName = draggableList.pop(); // Remove the Dark marble's name
                            console.log("Removed marble:", removedMarbleName);

                            let oldMarble = null;
                            for (let child of drag.source.parent.children) {
                                if (child.Drag && child.Drag.keys.includes(removedMarbleName)) {
                                    oldMarble = child;
                                    break;
                                }
                            }
                            // Move the old marble to the desired position (e.g., middle of the board)
                            if (oldMarble) {
                                main_window.moveToOpponentHitTray(oldMarble);
                            } else {
                                console.log("Could not find marble object for:", removedMarbleName);
                            }
                            draggableList.push(marbleName); // Add the Light marble
                            current_color = "Light"; // Update the current color
                            handler.move_string_backend = marbleName + " moved to " + dropName//////////////////////////////////////////////////////////////////

                        }
                        else {
                            draggableList.push(marbleName);
                            console.log("Added draggable:", marbleName, "to drop area:", dropName);
                            handler.move_string_backend = marbleName + " moved to " + dropName//////////////////////////////////////////////////////////////////

                        } 
                    }
                    else {
                        if (marbleName.includes("Light")){
                            // dont push
                            console.log("cant push to the drop with more than 1 drags!:", marbleName);
                            drag.source.x = drag.source.previousX;
                            drag.source.y = drag.source.previousY;
                            return
                        }
                        else {
                            handler.move_string_backend = marbleName + " moved to " + dropName//////////////////////////////////////////////////////////////////

                            draggableList.push(marbleName);
                            console.log("Added draggable:", marbleName, "to drop area:", dropName);
                        }  
                    }
                }
            }
            else {
                if (marbleName.includes("Light")) {
                    current_color = "Light";
                } else if (marbleName.includes("Dark")) {
                    current_color = "Dark";
                }
                draggableList.push(marbleName);
                handler.move_string_backend = marbleName + " moved to " + dropName//////////////////////////////////////////////////////////////////

                console.log("Added draggable:", marbleName, "to drop area:", dropName);
            }

            console.log("Current color:", current_color);

            // Add the marble to the list
            // draggableList.push(marbleName);
            // console.log("Added draggable:", marbleName, "to drop area:", dropName);
            console.log("this is the the dropable: ", dropName)
            console.log("Current draggable list:", draggableList);

            // Position the draggable at the top of the stack
            let marbleNumbers = draggableList.length;
            let targetPos = triangleContainer.mapToItem(drag.source.parent, 0, 0);
            drag.source.x = targetPos.x + (triangleContainer.width - drag.source.width) / 2;
            drag.source.y = targetPos.y + triangleContainer.height - (drag.source.height * marbleNumbers);
        }
        onExited: {
            let droppedKeys = drag.source.Drag.keys;
            let marbleName = droppedKeys[0]; // Example: "Marble_Light_1"
            marbleHovered = false;

            // Allow only the top marble to be moved
            // if (marbleName !== draggableList[draggableList.length - 1]) {
            //     console.log("Only the top draggable can be moved!");
            //     drag.source.x = drag.source.previousX;
            //     drag.source.y = drag.source.previousY;
            //     return;
            // }

            // Remove the marble from the list
            let index = draggableList.indexOf(marbleName);
            if (index !== -1) {
                draggableList.splice(index, 1);
                console.log("Removed draggable:", marbleName, "from drop area:", dropName);
            }

            if (draggableList.length <= 0) {
                current_color = "None"; // No marbles left
            }
            console.log("Updated draggable list:", draggableList);
            console.log("Current color:", current_color);
        }
    }
}


    

