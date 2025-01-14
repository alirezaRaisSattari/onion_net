// import QtQuick 2.15

// Rectangle {
//     id: rightDropArea
//     // Layout.fillHeight: true
//     width: 50 // Fixed width for the right drop area
//     color: "#8B4513" // Dark brown color for the right drop area
//     border.width: 2
//     // Add properties for future drag/drop functionality
//     property bool marbleHovered: false  // Tracks hover state
//     property string dropName: "right"
//     DropArea {
//         anchors.fill: parent
//         onEntered: {
//             console.log("Drag entered right drop area")
//             rightDropArea.marbleHovered = true;
//         }
//         onExited: {
//             rightDropArea.marbleHovered = false;
//             console.log("Drag left right drop area")
//         }
//         onDropped: {
//             console.log("Item dropped in right drop area with keys:", drag.source.Drag.keys)
//             console.log("Drop area name:", rightDropArea.dropName)
//             rightDropArea.marbleHovered = false;
//         }
//     }

//     border.color: marbleHovered ? "gold" : "black" // Change border color on hover
// }
import QtQuick 2.15

Rectangle {
    id: rightDropArea
    width: 50 // Fixed width for the right drop area
    color: "#8B4513" // Dark brown color for the right drop area
    border.width: 2

    // Add properties for drag/drop functionality
    property bool marbleHovered: false  // Tracks hover state
    property string dropName: "right"
    property var draggableList: []      // List to track dropped items

    DropArea {
        anchors.fill: parent
        onEntered: {
            console.log("Drag entered right drop area:", rightDropArea.dropName);
            rightDropArea.marbleHovered = true;
        }
        onExited: {
            console.log("Drag left right drop area:", rightDropArea.dropName);
            rightDropArea.marbleHovered = false;
        }
        onDropped: {
            console.log("Item dropped in right drop area with keys:", drag.source.Drag.keys);

            // Retrieve the dropped item's name
            let droppedKeys = drag.source.Drag.keys;
            let marbleName = droppedKeys[0]; // Example: "Marble_Light_1"

            // Check if the marble is already in the list
            if (rightDropArea.draggableList.includes(marbleName)) {
                console.log("Item already in the right drop area:", marbleName);
                return;
            }

            // Add the marble to the list
            rightDropArea.draggableList.push(marbleName);
            console.log("Added item to right drop area:", marbleName);

            // Position the marble in the drop area
            let marbleCount = rightDropArea.draggableList.length;
            drag.source.x = rightDropArea.x + (rightDropArea.width - drag.source.width) / 2;
            drag.source.y = rightDropArea.y + rightDropArea.height - (drag.source.height * marbleCount);

            rightDropArea.marbleHovered = false;
        }
    }

    border.color: marbleHovered ? "gold" : "black" // Change border color on hover
}
