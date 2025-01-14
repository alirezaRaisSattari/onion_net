from PySide6.QtCore import QObject, Property, Signal

class marble(QObject):
    def __init__(self):
        super().__init__()
        self._my_property = 0  # Private attribute to store the actual value
    
    def get_my_property(self):
        return self._my_property
    
    def set_my_property(self, value):
        if self._my_property != value:
            self._my_property = value
            self.my_property_changed.emit()  # Emit the signal when the value changes
    
    # Notification signal to notify about property changes
    my_property_changed = Signal()
    
    # Define the property with getter, setter, and notify signal
    my_property = Property(int, get_my_property, set_my_property, notify=my_property_changed)
