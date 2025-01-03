import socket
import threading
from queue import Queue
from client_message_parser import MessageParser
from http_message_builder import HTTPMessageBuilder

# return [
#     "HTTP/1.1 200 OK",
#     "Content-Type: text/plain",
#     `Content-Length: ${8 + body.length}`,
#     "",
#     `{index:${body}}`,
#   ]

class Client:
    def __init__(self, server_host, server_port):
        self.server_host = server_host
        self.server_port = server_port
        self.format = "utf-8"
        self.addr = (self.server_host, self.server_port)
        self.client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        
        self.message_queue = Queue()        # this queue is for the registering user (confirmation) and (get) active users.
        self.router_index_queue = Queue()   # this queue is for the client to keep the router responds.

    def connect(self):
        try:
            self.client.connect(self.addr)
            print(f"[CONNECTED] Connected to server at {self.server_host}:{self.server_port}")
        except Exception as e:
            print(f"[ERROR] Unable to connect to server: {e}")

    def send_message(self, message):
        try:
            msg = message.encode(self.format)
            self.client.send(msg)
        except Exception as e:
            print(f"[ERROR] Unable to send message: {e}")

    def disconnect(self):
        self.send_message("DISCONNECT")
        self.client.close()
        print("[DISCONNECTED] Client disconnected from server")
        
    def receive_messages(self):
        try:
            while True:
                msg = self.client.recv(1024).decode(self.format)
                if msg:
                    message_parser = MessageParser(msg)
                    
                    if message_parser.respond_type == "main_server":
                        print(f"[SERVER RESPOND TO CLIENT PYSIDE]: {msg}")
                        self.message_queue.put(msg)  # Put the message in the queue

                    elif message_parser.respond_type == "router":
                        print(f"[ROUTER RESPOND TO CLIENT]: {msg}")
                        index = message_parser.get_json_value("index")
                        self.router_index_queue.put(index)
                        self.get_key(index)

                    # self.message_queue.put(msg)  # Put the message in the queue
        except Exception as e:
            print(f"[ERROR] Receiving message: {e}")
            
            
    def get_key(self, index):
        print("[PYSIDE]: get key function is triggered")
        print(f"[ROTER RESPOND TO CLIENT]: the index to look for: {index}")
        my_variable_for_private_keys = [{"key1":"asdf"}, {"key2":"sdfg"}, {"key3":"sldkfj"}]
        body = self.message_queue.get()
        if str(index) == "1":
            print("processing the http message....")
            http_message = HTTPMessageBuilder(
                host="localhost",
                port=8000,
                path="/",
                method="GET",
                headers=my_variable_for_private_keys,
                body=body,
            )
            print(f"[PYSIDE CILENT]: sending message to the ROUTER index{index}")
            # self.send_message(http_message)
            self.client.send(http_message)
        else: 
            print("asdadasdasdasdasdasdsdads")

        # elif index == 2:
            
        # elif index == 3:
        print("[PYSIDE CLIENT]: the end of the get key function")
        



# if __name__ == "__main__":
#     client = Client(server_host="192.168.100.8", server_port=5050)
#     client.connect()
    
#     threading.Thread(target=client.receive_messages, daemon=True).start()

#     # client.send_message("Hello World!")
#     while True: 
#         message2 = input("enter message:")
#         if message2 == "DISCONNECT":
#             break
#         client.send_message(message2)
        
#     client.disconnect()
