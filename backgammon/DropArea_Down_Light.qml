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
    property var draggableList: []                 // List of marble identifiers
    property string current_color: "None"          // Current color ("Light", "Dark", or "None")

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
            startX: width / 2; startY: height // Start at the bottom-center
            PathLine { x: width; y: 0 }       // Top-right
            PathLine { x: 0; y: 0 }          // Top-left
            PathLine { x: width / 2; y: height } // Close back to the bottom
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

            if (current_color != "None") {
                if (current_color == "Light") {
                    if (draggableList.length == 1) {
                        if (marbleName.includes("Dark")) {
                            console.log("Hit: Replacing Light with Dark marble.");
                            let removedMarbleName = draggableList.pop(); // Remove the Light marble's name
                            console.log("Removed marble:", removedMarbleName);

                            let oldMarble = null;
                            for (let child of drag.source.parent.children) {
                                if (child.Drag && child.Drag.keys.includes(removedMarbleName)) {
                                    oldMarble = child;
                                    break;
                                }
                            }
                            if (oldMarble) {
                                main_window.moveToOpponentHitTray(oldMarble);
                            } else {
                                console.log("Could not find marble object for:", removedMarbleName);
                            }
                            draggableList.push(marbleName); // Add the Dark marble
                            current_color = "Dark"; // Update the current color
                            handler.move_string_backend = marbleName + " moved to " + dropName//////////////////////////////////////////////////////////////////


                            let targetPos = triangleContainer.mapToItem(drag.source.parent, 0, 0);
                            drag.source.x = targetPos.x + (triangleContainer.width - drag.source.width) / 2;
                            drag.source.y = targetPos.y + (draggableList.length - 1) * drag.source.height;

                            console.log("Current draggable list:", draggableList);
                            return; // Prevent further execution
                        } else {
                            draggableList.push(marbleName);
                            console.log("Added draggable:", marbleName, "to drop area:", dropName);
                            handler.move_string_backend = marbleName + " moved to " + dropName//////////////////////////////////////////////////////////////////

                        }
                    } else {
                        if (marbleName.includes("Dark")) {
                            console.log("Cannot push Dark marble into a Light stack with more than 1 marble:", marbleName);
                            drag.source.x = drag.source.previousX;
                            drag.source.y = drag.source.previousY;
                            return;
                        } else {
                            draggableList.push(marbleName);
                            console.log("Added draggable:", marbleName, "to drop area:", dropName);
                            handler.move_string_backend = marbleName + " moved to " + dropName//////////////////////////////////////////////////////////////////

                        }
                    }
                }
                if (current_color == "Dark") {
                    if (draggableList.length == 1) {
                        if (marbleName.includes("Light")) {
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
                            if (oldMarble) {
                                main_window.moveToOpponentHitTray(oldMarble);
                            } else {
                                console.log("Could not find marble object for:", removedMarbleName);
                            }
                            draggableList.push(marbleName); // Add the Light marble
                            current_color = "Light"; // Update the current color
                            handler.move_string_backend = marbleName + " moved to " + dropName//////////////////////////////////////////////////////////////////


                            let targetPos = triangleContainer.mapToItem(drag.source.parent, 0, 0);
                            drag.source.x = targetPos.x + (triangleContainer.width - drag.source.width) / 2;
                            drag.source.y = targetPos.y + (draggableList.length - 1) * drag.source.height;

                            console.log("Current draggable list:", draggableList);
                            return; // Prevent further execution
                        } else {
                            draggableList.push(marbleName);
                            console.log("Added draggable:", marbleName, "to drop area:", dropName);
                            handler.move_string_backend = marbleName + " moved to " + dropName//////////////////////////////////////////////////////////////////

                        }
                    } else {
                        if (marbleName.includes("Light")) {
                            console.log("Cannot push Light marble into a Dark stack with more than 1 marble:", marbleName);
                            drag.source.x = drag.source.previousX;
                            drag.source.y = drag.source.previousY;
                            return;
                        } else {
                            draggableList.push(marbleName);
                            console.log("Added draggable:", marbleName, "to drop area:", dropName);
                            handler.move_string_backend = marbleName + " moved to " + dropName//////////////////////////////////////////////////////////////////

                        }
                    }
                }
            } else {
                if (marbleName.includes("Light")) {
                    current_color = "Light";
                } else if (marbleName.includes("Dark")) {
                    current_color = "Dark";
                }
                draggableList.push(marbleName);
                console.log("Added draggable:", marbleName, "to drop area:", dropName);
                handler.move_string_backend = marbleName + " moved to " + dropName//////////////////////////////////////////////////////////////////

            }

            console.log("Current color:", current_color);
            console.log("Current draggable list:", draggableList);

            // Position the draggable at the top of the reversed stack
            let targetPos = triangleContainer.mapToItem(drag.source.parent, 0, 0);
            drag.source.x = targetPos.x + (triangleContainer.width - drag.source.width) / 2;
            drag.source.y = targetPos.y + (draggableList.length - 1) * drag.source.height;
        }

        onExited: {
            let droppedKeys = drag.source.Drag.keys;
            let marbleName = droppedKeys[0]; // Example: "Marble_Light_1"
            marbleHovered = false;

            // if (marbleName !== draggableList[draggableList.length - 1]) {
            //     console.log("Only the top draggable can be moved!");
            //     drag.source.x = drag.source.previousX;
            //     drag.source.y = drag.source.previousY;
            //     return;
            // }

            let index = draggableList.indexOf(marbleName);
            if (index !== -1) {
                draggableList.splice(index, 1);
                console.log("Removed draggable:", marbleName, "from drop area:", dropName);
            }

            if (draggableList.length <= 0) {
                current_color = "None";
            }
            console.log("Updated draggable list:", draggableList);
            console.log("Current color:", current_color);
        }
    }
}



// import QtQuick 2.15
// import QtQuick.Shapes 1.8

// Rectangle {
//     id: triangleContainer
//     width: 120
//     height: 300
//     color: "transparent"

//     property bool marbleHovered: false  // Tracks hover state
//     property string dropName: ""
    
    // Shape {
    //     id: triangle
    //     width: parent.width
    //     height: parent.height
    //     anchors.fill: parent

    //     ShapePath {
    //         strokeWidth: 2
    //         strokeColor: marbleHovered ? "gold" : "black" // Change color on hover
    //         fillGradient: LinearGradient {
    //             x1: 0; y1: 0
    //             x2: width; y2: height
    //             GradientStop { position: 0; color: marbleHovered ? "sienna" : "rosybrown" }
    //             GradientStop { position: 1; color: "tan" }
    //         }
    //         startX: width / 2; startY: height // Start at the bottom-center
    //         PathLine { x: width; y: 0 }       // Top-right
    //         PathLine { x: 0; y: 0 }          // Top-left
    //         PathLine { x: width / 2; y: height } // Close back to the bottom
    //     }
    // }

//     DropArea {
//         anchors.fill: parent
//         onEntered:
//         {
//             console.log("Drag entered drop area: ", dropName)
//             marbleHovered = true;
//         }
//         onDropped:
//         {
//             console.log("///////////////////DROP/////////////////////////")
//             console.log("Item dropped with keys:", drag.source.Drag.keys)
//             console.log("Item dropped at the name:", dropName)
//             marbleHovered = false;
//         } 
//         onExited: {
//             marbleHovered = false;
//             console.log("Drag left drop area: ", dropName)
//         }

//     }
// }

// import QtQuick 2.15
// import QtQuick.Shapes 1.8

// Rectangle {
//     id: triangleContainer
//     width: 120
//     height: 300
//     color: "transparent"

//     property bool marbleHovered: false  // Tracks hover state
//     property string dropName: ""
    
//     property int marble_numbers: 0                  // Number of marbles
//     property var marble_list: []                    // List of marble identifiers
//     property string current_color: "None"           // Current color ("Light", "Dark", or "None")
    
//     Shape {
//         id: triangle
//         width: parent.width
//         height: parent.height
//         anchors.fill: parent

//         ShapePath {
//             strokeWidth: 2
//             strokeColor: marbleHovered ? "gold" : "black" // Change color on hover
//             fillGradient: LinearGradient {
//                 x1: 0; y1: 0
//                 x2: width; y2: height
//                 GradientStop { position: 0; color: "saddlebrown" }
//                 GradientStop { position: 1; color: marbleHovered ? "chocolate" : "darkgoldenrod" }
//             }
//             startX: width / 2; startY: height // Start at the bottom-center
//             PathLine { x: width; y: 0 }       // Top-right
//             PathLine { x: 0; y: 0 }          // Top-left
//             PathLine { x: width / 2; y: height } // Close back to the bottom
//         }
//     }

//     DropArea {
//         anchors.fill: parent
//         onEntered:
//         {
//             marbleHovered = true;
//             console.log("Drag entered drop area: ", dropName)
//         }
//         onDropped: {
//             console.log("///////////////////DROP/////////////////////////")
//             let droppedKeys = drag.source.Drag.keys;
//             if (droppedKeys.length > 0) {
//                 let marbleName = droppedKeys[0]; // Example: "Marble_Light_1"

//                 // Add marble only if it's not already in the list
//                 if (!marble_list.includes(marbleName)) {
//                     marble_list.push(marbleName);
//                     marble_numbers += 1;

//                     // Determine and update the current color
//                     if (marbleName.includes("Light")) {
//                         current_color = "Light";
//                     } else if (marbleName.includes("Dark")) {
//                         current_color = "Dark";
//                     }
//                 }
//                 console.log("Updated marble list:", marble_list);
//                 console.log("Marble count:", marble_numbers);
//                 console.log("Current color:", current_color);
//             }
//             marbleHovered = false;
//         }

//         onExited: {
//             console.log("Drag left drop area: ", dropName);
//             marbleHovered = false;

//             // Remove marble if it exits the area
//             let exitedKeys = drag.source.Drag.keys;
//             if (exitedKeys.length > 0) {
//                 let marbleName = exitedKeys[0]; // Example: "Marble_Light_1"

//                 // Remove marble from list if it exists
//                 let index = marble_list.indexOf(marbleName);
//                 if (index !== -1) {
//                     marble_list.splice(index, 1);
//                     marble_numbers -= 1;
//                 }

//                 // Update the current color based on the remaining marbles
//                 if (marble_list.length > 0) {
//                     if (marble_list.some(m => m.includes("Light"))) {
//                         current_color = "Light";
//                     } else if (marble_list.some(m => m.includes("Dark"))) {
//                         current_color = "Dark";
//                     }
//                 } else {
//                     current_color = "None"; // No marbles left
//                 }

//                 console.log("Updated marble list after exit:", marble_list);
//                 console.log("Marble count after exit:", marble_numbers);
//                 console.log("Current color:", current_color);
//             }
//         }
//     //     onDropped:
//     //     {
//     //         console.log("///////////////////DROP/////////////////////////")
//     //         console.log("Item dropped with keys:", drag.source.Drag.keys)
//     //         console.log("Item dropped at the name:", dropName)
//     //         marbleHovered = false;
//     //     } 
//     //     onExited: {
//     //         marbleHovered = false;
//     //         console.log("Drag left drop area: ", dropName)
//     //     }
//     }

//     // Optional debug information
//     Text {
//         id: debugText
//         anchors.bottom: parent.bottom
//         anchors.horizontalCenter: parent.horizontalCenter
//         text: "Marbles: " + marble_numbers// + ", List: " + marble_list + ", Color: " + current_color
//         color: "red"
//         font.pixelSize: 12
//         visible: true
//     }   
// }