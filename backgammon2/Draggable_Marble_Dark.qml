import QtQuick 2.15

Rectangle {
    id: darkMarble
    width: 100
    height: 100
    color: "transparent"

    property bool isTurnProperty: false // Determines if it's this marble's turn
    property bool isYoursProperty: false // Determines if the marble type belongs to the player

    property alias is_turn: darkMarble.isTurnProperty
    property alias is_yours: darkMarble.isYoursProperty
    property alias dragKeys: darkMarble.dragKeysProperty

    property string dragKeysProperty: ""

    Drag.active: dragArea.drag.active
    Drag.hotSpot.x: width / 2
    Drag.hotSpot.y: height / 2
    Drag.keys: [dragKeys]

    property real previousX: x
    property real previousY: y

    Behavior on x {
        NumberAnimation { duration: 300; easing.type: Easing.InOutQuad }
    }
    Behavior on y {
        NumberAnimation { duration: 300; easing.type: Easing.InOutQuad }
    }

    MouseArea {
        cursorShape: Qt.PointingHandCursor
        hoverEnabled: true
        id: dragArea
        anchors.fill: parent
        drag.target: (is_turn && is_yours) ? parent : null // Drag only if it's "yours" and "your turn"

        onReleased: {
            if (dragArea.drag.active) {
                console.log("Releasing drag; calling Drag.drop()");
                parent.Drag.drop();
            }
        }

        onPressed: {
            if (!darkMarble.is_turn || !darkMarble.is_yours) {
                console.log("This marble is not yours or not your turn; cannot drag.");
                return;
            }
            // Store the current position before dragging
            darkMarble.previousX = darkMarble.x;
            darkMarble.previousY = darkMarble.y;
        }

        // Main Circle with Gradient
        Rectangle {
            id: mainCircle
            anchors.fill: parent
            radius: width / 2
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#5D4037" } // Dark brown top
                GradientStop { position: 1.0; color: "#3E2723" } // Deep dark brown bottom
            }

            // Inner Glow Effect
            Rectangle {
                id: innerGlow
                width: parent.width * 0.8
                height: parent.height * 0.8
                anchors.centerIn: parent
                radius: width / 2
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "transparent" }
                    GradientStop { position: 1.0; color: "#8D6E63" } // Soft brown
                }
            }

            // Reflection Effect
            Rectangle {
                id: reflection
                width: parent.width * 0.4
                height: parent.height * 0.4
                radius: width / 2
                color: "#A1887F" // Light brown reflection
                opacity: 0.4
                anchors {
                    top: parent.top
                    horizontalCenter: parent.horizontalCenter
                    margins: 5
                }
            }

            // Bottom Highlight
            Rectangle {
                id: bottomHighlight
                width: parent.width * 0.5
                height: parent.height * 0.1
                color: "#D7CCC8" // Soft creamy brown highlight
                opacity: 0.3
                anchors {
                    bottom: parent.bottom
                    horizontalCenter: parent.horizontalCenter
                    margins: 2
                }
                radius: height / 2
            }
        }
    }
}

// import QtQuick 2.15

// Rectangle {
//     id: darkMarble
//     width: 100
//     height: 100
//     color: "transparent"

//     property bool isTurnProperty: false

//     property alias is_turn: darkMarble.isTurnProperty
//     property alias dragKeys: darkMarble.dragKeysProperty

//     property string dragKeysProperty: ""

//     Drag.active: dragArea.drag.active
//     Drag.hotSpot.x: width / 2
//     Drag.hotSpot.y: height / 2
//     Drag.keys: [dragKeys]

//     property real previousX: x
//     property real previousY: y

//     Behavior on x {
//         NumberAnimation { duration: 300; easing.type: Easing.InOutQuad }
//     }
//     Behavior on y {
//         NumberAnimation { duration: 300; easing.type: Easing.InOutQuad }
//     }

//     MouseArea {
//         cursorShape: Qt.PointingHandCursor
//         hoverEnabled: true
//         id: dragArea
//         anchors.fill: parent
//         drag.target: parent
//         onReleased: {
//             if (dragArea.drag.active) {
//                 console.log("Releasing drag; calling Drag.drop()");
//                 parent.Drag.drop();
//             }
//         }
//         onPressed: {
//             // Store the current position before dragging
//             darkMarble.previousX = darkMarble.x;
//             darkMarble.previousY = darkMarble.y;
//         }

//         // Main Circle with Gradient
//         Rectangle {
//             id: mainCircle
//             anchors.fill: parent
//             radius: width / 2
//             gradient: Gradient {
//                 GradientStop { position: 0.0; color: "#5D4037" } // Dark brown top
//                 GradientStop { position: 1.0; color: "#3E2723" } // Deep dark brown bottom
//             }

//             // Inner Glow Effect
//             Rectangle {
//                 id: innerGlow
//                 width: parent.width * 0.8
//                 height: parent.height * 0.8
//                 anchors.centerIn: parent
//                 radius: width / 2
//                 gradient: Gradient {
//                     GradientStop { position: 0.0; color: "transparent" }
//                     GradientStop { position: 1.0; color: "#8D6E63" } // Soft brown
//                 }
//             }

//             // Reflection Effect
//             Rectangle {
//                 id: reflection
//                 width: parent.width * 0.4
//                 height: parent.height * 0.4
//                 radius: width / 2
//                 color: "#A1887F" // Light brown reflection
//                 opacity: 0.4
//                 anchors {
//                     top: parent.top
//                     horizontalCenter: parent.horizontalCenter
//                     margins: 5
//                 }
//             }

//             // Bottom Highlight
//             Rectangle {
//                 id: bottomHighlight
//                 width: parent.width * 0.5
//                 height: parent.height * 0.1
//                 color: "#D7CCC8" // Soft creamy brown highlight
//                 opacity: 0.3
//                 anchors {
//                     bottom: parent.bottom
//                     horizontalCenter: parent.horizontalCenter
//                     margins: 2
//                 }
//                 radius: height / 2
//             }
//         }
//     }
// }