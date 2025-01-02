from PySide6.QtCore import QObject, Property, Signal, Slot
from client_oop import Client
import threading

class user_register(QObject):
    
    username_changed = Signal()
    active_users_asked = Signal()
    oppoentn_selected = Signal()
    
    def __init__(self):
        super().__init__()
        self.username = ""
        self.active_users_list = []
        self.user_oponent = ""
        self.username_changed.connect(self.new_username_recived)      # connected to the socket function
        self.active_users_asked.connect(self.fetch_users_from_server) # connected to the socket function
        self.oppoentn_selected.connect(self.oponent_selcted)
        self.client_socket = None
        
    def get_username(self):
        return self.username
    
    def set_username(self, value):
        if self.username != value:
            self.username = value
            self.username_changed.emit()

    @Slot()
    def new_username_recived(self):
        print(f"[PYSIDE] this is the self.username: {self.username}")
        # call the new username for the client side...
        # client-socket file is triggered
        self.client_socket = Client(server_host="192.168.100.8", server_port=5050)
        self.client_socket.connect()
        threading.Thread(target=self.client_socket.receive_messages, daemon=True).start()

        self.client_socket.send_message(self.username)
        
    def set_active_users_list(self, user_list):
        if self.active_users_list != user_list:
            self.active_users_list = user_list
            self.active_users_asked.emit()
            
    def get_active_users_list(self):
        return self.active_users_list
    
    @Slot()
    def fetch_users_from_server(self):
        print(f"[PYSIDE] the slot for asking the userslist is called.")

        # client-socket file is triggered
        self.client_socket.send_message("GET_USER_LIST")
    # if not self.client_socket.message_queue.empty():
        msg = self.client_socket.message_queue.get()
        print(f"[PYSIDE] Processing message from server: {msg}")
            
        user_list_feteched = msg.split(", ")
        self.set_active_users_list(user_list_feteched)
        
    def get_selected_user(self):
        return self.user_oponent
    
    def set_selected_user(self, user_oponent_selected):
        if self.user_oponent != user_oponent_selected:
            self.user_oponent = user_oponent_selected
        self.oppoentn_selected.emit()
            
    @Slot()
    def oponent_selcted(self):
        # the oponent is selected!
        print(f"[PYSIDE] the oponent is recieved: {self.user_oponent}")
        # this part the p2p should appear.

    pyside_username = Property(str, get_username, set_username, notify=username_changed)
    pyside_active_users_list = Property(list, get_active_users_list, set_active_users_list, notify=active_users_asked)
    pyside_selected_user = Property(str, get_selected_user, set_selected_user, notify=oppoentn_selected)
