import QtQuick 2.15

Rectangle {
    id: draggableRectangle
    width: 50
    height: 50
    property bool isTurnProperty: false

    property alias is_turn: draggableRectangle.isTurnProperty
    property alias dragKeys: draggableRectangle.dragKeysProperty

    property string dragKeysProperty: ""

    color: "blue"

    Drag.active: dragArea.drag.active
    Drag.hotSpot.x: width / 2
    Drag.hotSpot.y: height / 2
    Drag.keys: [dragKeys]

    MouseArea {
        id: dragArea
        anchors.fill: parent
        drag.target: parent
        onReleased: {
            if (dragArea.drag.active) {
                console.log("Releasing drag; calling Drag.drop()");
                parent.Drag.drop();
            }
        }
    }
}
