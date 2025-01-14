from flask import Flask
from flask_socketio import SocketIO, emit
import threading

class SocketIOServer:
    def __init__(self, host='127.0.0.1', port=5001, secret_key='secret!', debug=True):
        self.app = Flask(__name__)
        # self.app.config['SECRET_KEY'] = secret_key
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
        # emit('message_from_python', {
        #     'data': f"Python received:////////////////////////////////////////////////"
        #     })

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
            
            # if json_data['data'] == "username":
            #     # Wait until data is received from PySide
            #     print("[FLASK] username condition is triggerd!")
            #     if not self.data_received_event.is_set():
            #         emit('message_from_python', {
            #             'data': "Waiting for data from PySide..."
            #         })
            #         print("Waiting for data from PySide...")
            #         self.data_received_event.wait()
                    
                # emit('message_from_python', {
                #         'data': f"Python received: {json_data['data']} and PySide provided: {self.received_data}"
                #         })
                
            emit('message_from_python', {
                    'data': f"Python received: this is the client2 that got the message"
                    })
            
            # elif json_data['data'] == "userlist":
            #     print("[FLASK] userlist condition is triggerd!")
            #     if not self.data_received_event.is_set():
            #         emit('message_from_python', {
            #             'data': "Waiting for data from PySide..."
            #         })
            #         print("Waiting for data from PySide...")
            #         self.data_received_event.wait()
                    
                # emit('message_from_python', {
                #         'data': f"Python received: {json_data['data']} and PySide provided: {self.received_data}"
                #         })
                # # Respond to the Node client
            


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


# import socketio
# import eventlet
# import threading


# class SocketIOServer:
#     def __init__(self, host='127.0.0.1', port=5001, debug=True):
#         # Initialize the Socket.IO server with CORS support
#         self.sio = socketio.Server(logger=debug, engineio_logger=debug, cors_allowed_origins='*')
#         self.app = socketio.WSGIApp(self.sio)  # WSGI wrapper for the server

#         self.host = host
#         self.port = port
#         self.debug = debug

#         # Shared data
#         self.received_data = None

#         # Register event handlers
#         self._register_event_handlers()

#     def _register_event_handlers(self):
#         """
#         Register Socket.IO event handlers for client communication.
#         """
#         @self.sio.event
#         def connect(sid, environ):
#             print(f"Client connected: {sid}")
#             # Optionally, send a welcome message to the newly connected client
#             self.sio.emit('message_from_python', {'data': 'Hello from Python!'}, to=sid)

#         @self.sio.on('message_from_node')
#         def handle_message_from_node(sid, data):
#             """
#             Handle messages sent from Node.js.
#             """
#             print(f"[SERVER] Received from Node: {data}")
#             # Example response to Node.js
#             self.sio.emit('message_from_python', {
#                 'data': f"Python received your message: {data['data']}"
#             }, to=sid)

#     def receive_data_from_pyside(self, data):
#         """
#         Method to receive data from PySide and immediately emit it to Node.js.
#         """
#         print(f"[SERVER] Received data from PySide: {data}")
#         self.received_data = data

#         # Emit the data directly to all connected clients
#         self.sio.emit('message_from_python', {
#             'data': f"New data from PySide: {data}"
#         })
#         print(f"[SERVER] Emitted data to Node.js: {data}")

#     def start(self):
#         """
#         Start the Socket.IO server using Eventlet.
#         """
#         print(f"Starting Socket.IO server on {self.host}:{self.port}...")
#         # Run the WSGI server with the Socket.IO app
#         eventlet.wsgi.server(eventlet.listen((self.host, self.port)), self.app)


# # Example usage
# # if __name__ == '__main__':
# #     # Create the server instance
# #     server = SocketIOServer(host='127.0.0.1', port=5001, debug=True)

# #     # Start the server in a new thread (optional, if you want the main thread to do other things)
# #     threading.Thread(target=server.start, daemon=True).start()

# #     # Example interaction with PySide:
# #     while True:
# #         # Simulate receiving data from PySide
# #         input_data = input("Enter data to send to Node.js: ")
# #         server.receive_data_from_pyside(input_data)
