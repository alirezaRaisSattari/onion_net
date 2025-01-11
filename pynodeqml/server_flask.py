from flask import Flask
from flask_socketio import SocketIO, emit
import threading

class SocketIOServer:
    def __init__(self, host='127.0.0.1', port=5000, secret_key='secret!', debug=True):
        self.app = Flask(__name__)
        self.app.config['SECRET_KEY'] = secret_key
        self.socketio = SocketIO(self.app)
        self.host = host
        self.port = port
        self.debug = debug

        # Register event handlers
        self._register_event_handlers()
        
        # Shared state
        self.received_data = None
        self.data_received_event = threading.Event()


    def receive_data_from_pyside(self, data):
        """
        Method to receive data from PySide and set it for processing.
        """
        print(f"[SERVER] Received data from PySide: {data}")
        self.received_data = data
        self.data_received_event.set()  # Signal that the data has been received
        

    def _register_event_handlers(self):
        """
        Register SocketIO event handlers.
        """
        @self.socketio.on('connect')
        def handle_connect():
            print('Client connected (Node or Browser)')
            emit('message_from_python', {'data': 'Hello from Flask!'})

        @self.socketio.on('message_from_node')
        def handle_message_from_node(json_data):
            print('Received from Node:', json_data)
            
            if json_data['data'] == "username":
                # Wait until data is received from PySide
                print("[FLASK] username condition is triggerd!")
                if not self.data_received_event.is_set():
                    emit('message_from_python', {
                        'data': "Waiting for data from PySide..."
                    })
                    print("Waiting for data from PySide...")
                    self.data_received_event.wait()
                    
                emit('message_from_python', {
                    'data': f"Python received: {json_data['data']} and PySide provided: {self.received_data}"
                    })
            
            elif json_data['data'] == "userlist":
                print("[FLASK] userlist condition is triggerd!")
                if not self.data_received_event.is_set():
                    emit('message_from_python', {
                        'data': "Waiting for data from PySide..."
                    })
                    print("Waiting for data from PySide...")
                    self.data_received_event.wait()
                    
                emit('message_from_python', {
                    'data': f"Python received: {json_data['data']} and PySide provided: {self.received_data}"
                    })
            # Respond to the Node client
            


    def start(self):
        """
        Starts the Flask-SocketIO server without the reloader to avoid issues in a thread.
        """
        print(f"Starting SocketIO server at {self.host}:{self.port}...")
        self.socketio.run(self.app, host=self.host, port=self.port, debug=self.debug, use_reloader=False)

    # def send_message_to_node(self, msg):
    #     print(f"[FLASK] send msg func triggered: {msg}")
    #     self.socketio.emit('message_from_python', {'data': msg})

# if __name__ == '__main__':
#     # Create an instance of the server
#     server = SocketIOServer(host='127.0.0.1', port=5000, secret_key='supersecret', debug=True)

#     # Start the server
#     server.start()
