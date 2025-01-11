
import QtQuick 6.5
import QtQuick.Controls 6.5
import QtQuick.Layouts
import User_registeration 1.0

ApplicationWindow {
    id: wellcome_page
    width: 500
    height: 700
    visible: true
    property bool is_registerd: true
    property bool is_activeuserlist_fethced: false
    // anchors.centerIn: parent // Center it within its parent or screen

    User_registration_class {
        id: pyside_backend
    }

    ColumnLayout {
        id: column
        anchors.fill: parent

        // greeting_message_rectangle
        Rectangle {
            id: greeting_message_rectangle
            Layout.fillWidth: true
            Layout.preferredHeight: parent.height * 0.33
            color: "#cb6666"
            Text {
                text: "wellcome!"
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pointSize: 25
            }
        }

        // register_lable_rectangle
        Rectangle {
            id: register_lable_rectangle
            Layout.fillWidth: true
            Layout.preferredHeight: parent.height * 0.1
            color: "#c65858"
            Text {
                id: registeration_lable
                text: "please register your name:"
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pointSize: 15
            }
        }

        // register_input_rectangle
        Rectangle {
            id: register_input_rectangle
            Layout.fillWidth: true
            Layout.preferredHeight: parent.height * 0.1
            color: "#c65858"

            RowLayout {
                anchors.fill: parent

                TextField {
                    id: username_input
                    Layout.preferredWidth: parent.width * 0.6
                    Layout.preferredHeight: parent.height
                    text: qsTr("type down your name...")
                    font.pixelSize: 20
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    // Clear the text when the user clicks
                    onActiveFocusChanged: {
                        if (activeFocus && text === "type down your name...") {
                            text = ""
                        }
                    }

                }

                Button {
                    id: username_register_btn
                    text: "register!"
                    font.pixelSize: 20
                    Layout.preferredWidth: parent.width * 0.4
                    Layout.preferredHeight: parent.height
                    onClicked: {

                        pyside_backend.pyside_username = username_input.text

                        if (is_registerd === true)
                        {
                            registeration_lable.text = "registration is done!"
                        }
                        else
                        {
                            registeration_lable.text = "registration faild. try again!"
                        }
                        username_input.text = "type down your name...";

                    }
                }
            }
        }

        Rectangle {
            id: rectangle5
            Layout.fillWidth: true
            visible: is_registerd
            Layout.preferredHeight: parent.height * 0.1
            color: "#c65858"
            Button {
                text: "fetch active users"
                anchors.fill: parent 

                onClicked: {

                    pyside_backend.active_users_asked()
                    is_activeuserlist_fethced = true

                    if (is_activeuserlist_fethced === true)
                    {
                        registeration_lable.text = "active users list fetched succsessfully!"
                    }
                    else
                    {
                        registeration_lable.text = "there was an error fetching the active user list, try again"
                    }
                }
            }
        }

        // active_users_list_rectangle
        Rectangle {
            id: active_users_list_rectangle
            visible: is_activeuserlist_fethced

            Layout.fillWidth: true
            Layout.preferredHeight: parent.height * 0.4
            color: "#c65858"
            // text: "active players"

            ListView {
                id: active_user_listView
                anchors.fill: parent
                // model: ["1", "2", "3"]
                model: pyside_backend.pyside_active_users_list

                delegate: Item {
                    width: ListView.view.width
                    height: 100

                    GroupBox {
                        width: parent.width
                        height: parent.height
                        // title: "player " + index

                        GridLayout {
                            anchors.fill: parent
                            columns: 2
                            rowSpacing: 10
                            columnSpacing: 10

                            Text {
                                text: "player name: " + modelData 
                                font.pixelSize: 14
                                Layout.row: 0
                                Layout.column: 0
                                Layout.minimumWidth: 100
                                Layout.alignment: Qt.AlignCenter
                            }

                            Button {
                                text: "Play!"
                                Layout.row: 0
                                Layout.column: 1
                                Layout.minimumWidth: 100
                                Layout.alignment: Qt.AlignCenter
                            }
                        }
                    }
                }
            }
        }
    }
}
