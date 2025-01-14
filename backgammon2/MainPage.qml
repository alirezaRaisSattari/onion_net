import QtQuick 6.5
import QtQuick.Controls 6.5
import QtQuick.Layouts 1.5

Item {
    visible: true
    width: 600
    height: 600
    // color: "#b68b35"
    property color backgroundColor: "#b68b35" // Exposed property
    // color: backgroundColor

    property alias dropArea_A1: dropArea_A1
    property alias dropArea_A2: dropArea_A2
    property alias dropArea_A3: dropArea_A3
    property alias dropArea_A4: dropArea_A4
    property alias dropArea_A5: dropArea_A5
    property alias dropArea_A6: dropArea_A6
    property alias dropArea_B1: dropArea_B1
    property alias dropArea_B2: dropArea_B2
    property alias dropArea_B3: dropArea_B3
    property alias dropArea_B4: dropArea_B4
    property alias dropArea_B5: dropArea_B5
    property alias dropArea_B6: dropArea_B6

    // Row at the top
    RowLayout {
        id: row1
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: parent.height / 2.5
        spacing: 0 // Ensure no extra space between items

        DropArea_Down_Dark {
            id: dropArea_A1
            Layout.preferredWidth: parent.width / 6.1
            Layout.fillHeight: true
            dropName: "1"
        }
        DropArea_Down_Light {
            id: dropArea_A2
            Layout.preferredWidth: parent.width / 6.1
            Layout.fillHeight: true
            dropName: "2"
        }
        DropArea_Down_Dark {
            id: dropArea_A3
            Layout.preferredWidth: parent.width / 6.1
            Layout.fillHeight: true
            dropName: "3"
        }
        DropArea_Down_Light {
            id: dropArea_A4
            Layout.preferredWidth: parent.width / 6.1
            Layout.fillHeight: true
            dropName: "4"
        }
        DropArea_Down_Dark {
            id: dropArea_A5
            Layout.preferredWidth: parent.width / 6.1
            Layout.fillHeight: true
            dropName: "5"
        }
        DropArea_Down_Light {
            id: dropArea_A6
            Layout.preferredWidth: parent.width / 6.1
            Layout.fillHeight: true
            dropName: "6"
        }
    }

    // Row at the bottom
    RowLayout {
        id: row
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: parent.height / 2.5
        spacing: 0 // Ensure no extra space between items


        DropArea_Up_Light {
            id: dropArea_B1
            Layout.preferredWidth: parent.width / 6.1
            Layout.fillHeight: true
            dropName: "7"
        }
        DropArea_Up_Dark {
            id: dropArea_B2
            Layout.preferredWidth: parent.width / 6.1
            Layout.fillHeight: true
            dropName: "8"
        }
        DropArea_Up_Light {
            id: dropArea_B3
            Layout.preferredWidth: parent.width / 6.1
            Layout.fillHeight: true
            dropName: "9"
        }
        DropArea_Up_Dark {
            id: dropArea_B4
            Layout.preferredWidth: parent.width / 6.1
            Layout.fillHeight: true
            dropName: "10"
        }
        DropArea_Up_Light {
            id: dropArea_B5
            Layout.preferredWidth: parent.width / 6.1
            Layout.fillHeight: true
            dropName: "11"
        }
        DropArea_Up_Dark {
            id: dropArea_B6
            Layout.preferredWidth: parent.width / 6.1
            Layout.fillHeight: true
            dropName: "12"
        }
    }
}
