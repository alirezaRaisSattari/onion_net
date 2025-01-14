from PySide6.QtCore import QObject, Property, Signal, Slot
from server_flask import SocketIOServer
import threading

class Pyside_Game_Handler(QObject):
    def __init__(self):
        super().__init__()
        self.move_string = ""  # Private attribute to store the actual value
        self.opponent_move_request = ""
        self.counter_req = 0
        self.my_moves = []
        
        self.flask_server = SocketIOServer(host='127.0.0.1', port=5001, secret_key='supersecret', debug=True)
        self.server_thread = threading.Thread(target=self.flask_server.start, daemon=True)
        self.server_thread.start()
    
    def get_move_string(self):
        print("[PYSIDE] get_move_string func triggered")
        return self.move_string
    
    def set_move_string(self, value):
        print(f"[PYSIDE] set_move_string triggered with value: {value}")
        self.move_string = value  # Set the move string
        self.my_moves.append(value)  # Add the move to the list
        self.counter_req += 1  # Increment the request counter

        if self.counter_req == 2:  # When two moves have been recorded
            self.counter_req = 0  # Reset the counter
            # Create the message string with the moves
            msg = f"moved {self.my_moves[0]} and {self.my_moves[1]} dice"
            print("TIME TO SEND THAT TO THE OTHER CLIENT TO SEE MY MOVES!")
            print(f"Message to send: {msg}")
            self.my_moves.clear()  # Clear the move list after use
            self.flask_server.receive_data_from_pyside(msg)
            self.set_request("")
            

        self.move_string_changed.emit()  # Emit the signal when the value changes
    
    def none_get(self):
        # self.opponent_move_request = "moved Marble_Dark_2 to B3 and Marble_Light_3 to B7 dice34" 
        self.opponent_move_request = "moved None to None and None to B7 None" 
    
    def get_request(self):
        print("[PYSIDE] get_move_string func triggered")
        return self.opponent_move_request
    
    def set_request(self, value):
        print(f"[PYSIDE] request is sent: {value}")
        self.opponent_move_request = value
        self.request_sent.emit()  # Emit the signal when the value changes
        self.none_get()
        self.updateSignal.emit()
        # print("I shoule be calling the get function here..........................")
        # self.get_opponent_signal("this is the message I am sending")
    
    move_string_changed = Signal()
    request_sent = Signal()
    updateSignal = Signal()
    
    # Define the property with getter, setter, and notify signal
    move_string_backend = Property(str, get_move_string, set_move_string, notify=move_string_changed)
    request_opponent_move_backend = Property(str, get_request, set_request, notify=request_sent)







    # @Slot(str)
    # def get_opponent_signal(self, opponent_move):
    #     self.updateSignal.emit(opponent_move)  # Emit the signal with a sample value  
    
    # Notification signal to notify about property changes