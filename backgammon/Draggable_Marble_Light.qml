import QtQuick 2.15

Rectangle {
    id: creamMarble
    width: 100
    height: 100
    color: "transparent"

    property bool isTurnProperty: false

    property alias is_turn: creamMarble.isTurnProperty
    property alias dragKeys: creamMarble.dragKeysProperty

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
        drag.target: parent
        onReleased: {
            if (dragArea.drag.active) {
                console.log("Releasing drag; calling Drag.drop()");
                parent.Drag.drop();
            }
        }
        onPressed: {
            // Store the current position before dragging
            creamMarble.previousX = creamMarble.x;
            creamMarble.previousY = creamMarble.y;
        }

        // Main Circle with Gradient
        Rectangle {
            id: mainCircle
            anchors.fill: parent
            radius: width / 2
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#d9c195" } // Creamy white top
                GradientStop { position: 1.0; color: "#c9ac8a" } // Light orange bottom
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
                    GradientStop { position: 1.0; color: "#FFDAB9" } // Soft peach
                }
            }

            // Reflection Effect
            Rectangle {
                id: reflection
                width: parent.width * 0.4
                height: parent.height * 0.4
                radius: width / 2
                color: "#f4e2c1"
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
                color: "#FFEDCC" // Soft creamy highlight
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
