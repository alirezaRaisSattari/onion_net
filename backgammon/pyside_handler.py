from PySide6.QtCore import QObject, Property, Signal, Slot

class Pyside_Game_Handler(QObject):
    def __init__(self):
        super().__init__()
        self.move_string = ""  # Private attribute to store the actual value
        self.opponent_move_request = ""
    
    def get_move_string(self):
        print("[PYSIDE] get_move_string func triggered")
        return self.move_string
    
    def set_move_string(self, value):
        print(f"[PYSIDE] get_move_string func triggered with value: {value}")
        if self.move_string != value:
            self.move_string = value
            self.move_string_changed.emit()  # Emit the signal when the value changes
    
    def none_get(self):
        self.opponent_move_request = "moved Marble_Dark_2 to B3 and Marble_Light_3 to B7 dice34" 
    
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
    
    # @Slot(str)
    # def get_opponent_signal(self, opponent_move):
    #     self.updateSignal.emit(opponent_move)  # Emit the signal with a sample value  
    
    # Notification signal to notify about property changes
    move_string_changed = Signal()
    request_sent = Signal()
    updateSignal = Signal()
    
    # Define the property with getter, setter, and notify signal
    move_string_backend = Property(str, get_move_string, set_move_string, notify=move_string_changed)
    request_opponent_move_backend = Property(str, get_request, set_request, notify=request_sent)






