import socket
from queue import Queue
from client_message_parser import MessageParser
from http_message_builder import HTTPMessageBuilder
from encryptor import Encryptor

class Client:
    def __init__(self, server_host, server_port):
        self.server_host = server_host
        self.server_port = server_port
        self.format = "utf-8"
        self.addr = (self.server_host, self.server_port)
        self.client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        
        self.message_queue = Queue()        # this queue is for the registering user (confirmation) and (get) active users.
        self.router_index_queue = Queue()   # this queue is for the client to keep the router responds.
        
        self.keys = {
            1: bytes.fromhex("2fc6893f58b434e353b0fd71ec9bb10d7dbf75aef6eb8c9f657eb08391ed1535"),
            2: bytes.fromhex("2b8d3f815ad55cc947a0d0ca6add1e7a288ebb185ec3dcc20ae54a9b206483e4"),
            3: bytes.fromhex("172ce1726ea34ec6cf2408105e8f92bb8e221fdb06d220761c94e3f29fca4d00"),
        }

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
        # my_variable_for_private_keys = [{"key1":"asdf"}, {"key2":"sdfg"}, {"key3":"sldkfj"}]
        my_variable_for_private_keys = [
            {f"key{key}": value.hex()} for key, value in self.keys.items()
        ]
        
        encriptor_key1 = Encryptor(next((item["key1"] for item in my_variable_for_private_keys if "key1" in item), None))
        encriptor_key2 = Encryptor(next((item["key2"] for item in my_variable_for_private_keys if "key2" in item), None))
        encriptor_key3 = Encryptor(next((item["key3"] for item in my_variable_for_private_keys if "key3" in item), None))
        
        http_message = HTTPMessageBuilder(
                host="localhost",
                port=8000,
                path="/",
                method="GET",
                headers=my_variable_for_private_keys,
                body="amir is trying to register",
            )
        dict1 = str(http_message.to_http_format()) 

        if index == 1:
            print(f"[PYSIDE CILENT]: sending message to the ROUTER index 1")
            self.send_message(dict1)
            
        elif index == 2:
            print(f"[PYSIDE CILENT]: sending message to the ROUTER index 2")
            encripted_msg_key1 = encriptor_key1.encrypt(dict1)
            print(f"[PYSIDE] this is encripted by key1 {encripted_msg_key1}")
            self.send_message(encripted_msg_key1)
            
        elif index == 3:
            print(f"[PYSIDE CILENT]: sending message to the ROUTER index 3")
            encripted_msg_key2 = encriptor_key2.encrypt(dict1)
            encripted_msg_key2_key1 = encriptor_key1.encrypt(encripted_msg_key2)
            self.send_message(encripted_msg_key2_key1)
            
        elif index == 4:
            print(f"[PYSIDE CILENT]: sending message to the ROUTER index 4")
            encripted_msg_key3 = encriptor_key3.encrypt(dict1)
            encripted_msg_key3_key2 = encriptor_key2.encrypt(encripted_msg_key3)
            encripted_msg_key3_key2_key1 = encriptor_key1.encrypt(encripted_msg_key3_key2)
            self.send_message(encripted_msg_key3_key2_key1)
            
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
