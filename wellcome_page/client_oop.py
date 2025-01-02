import socket
import threading
from queue import Queue

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
        
        self.message_queue = Queue()

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
                    print(f"[SERVER] {msg}")
                    self.message_queue.put(msg)  # Put the message in the queue
        except Exception as e:
            print(f"[ERROR] Receiving message: {e}")


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
