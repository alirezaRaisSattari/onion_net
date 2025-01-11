from PySide6.QtCore import QObject, Property, Signal, Slot
from server_flask import SocketIOServer
import threading

class user_register(QObject):
    
    username_changed = Signal()
    active_users_asked = Signal()

    def __init__(self):
        super().__init__()
        self.username = ""
        self.active_users_list = []
        self.username_changed.connect(self.new_username_recived)  # Connect signal to slot    
        self.active_users_asked.connect(self.fetch_users_from_server)
        self.flask_server = SocketIOServer(host='127.0.0.1', port=5000, secret_key='supersecret', debug=True)
        # self.flask_server.start()
        self.server_thread = threading.Thread(target=self.flask_server.start, daemon=True)
        self.server_thread.start()
    
    def get_username(self):
        return self.username
    
    def set_username(self, value):
        if self.username != value:
            self.username = value
            self.username_changed.emit()  # Emit the signal when the value changes

    @Slot()
    def new_username_recived(self):
        # call the new username for the client side...
        print(f"[PYSIDE] this is the self.username: {self.username}")
        self.flask_server.receive_data_from_pyside(self.username)
        
    def set_active_users_list(self, user_list):
        if self.active_users_list != user_list:
            self.active_users_list = user_list
            self.active_users_asked.emit()
            
    def get_active_users_list(self):
        return self.active_users_list
    
    @Slot()
    def fetch_users_from_server(self):
        print(f"[PYSIDE] the slot for asking the userslist is called.")
        # call the server to get the list: in a comma sprated way:
        active_users = "ali, hasan, reza"
        user_list_feteched = active_users.split(", ")
        self.set_active_users_list(user_list_feteched)
        self.flask_server.receive_data_from_pyside(self.username)
    
    # Define the property with getter, setter, and notify signal
    pyside_username = Property(str, get_username, set_username, notify=username_changed)
    pyside_active_users_list = Property(list, get_active_users_list, set_active_users_list, notify=active_users_asked)
