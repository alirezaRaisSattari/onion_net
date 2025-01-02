import socket
import threading

class Server:
    def __init__(self, host="127.0.0.1", port=5050):
        self.host = host
        self.port = port
        self.format = "utf-8"
        self.addr = (self.host, self.port)
        self.server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.active_users = {} 

    def start(self):
        self.server.bind(self.addr)
        self.server.listen()
        print(f"[LISTENING] Server is running on {self.host}:{self.port}")
        while True:
            client_conn, client_addr = self.server.accept()
            thread = threading.Thread(target=self.client_handle, args=(client_conn, client_addr))
            thread.start()
            print(f"[ACTIVE CONNECTIONS] {threading.active_count() - 1}")
            
            
    def client_handle(self, conn, addr):
        print(f"[NEW CLIENT] {addr} connected")
        
        # get the username at the first message
        try:
            username = conn.recv(1024).decode(self.format)
            if username:
                self.active_users[username] = addr
                print(f"[NEW USER] {username} has joined from {addr}")

        except Exception as e:
            print(f"[ERROR] Could not retrieve username from {addr}: {e}")
            conn.close()
            return
        
        #get user messages in a loop while the user is connected:
        connected = True
        while connected:
            try:
                msg = conn.recv(1024)
                if msg:
                    message = msg.decode(self.format)
                    if message == "DISCONNECT":
                        print(f"[DISCONNECT] {addr} disconnected")
                        self.active_users.pop(username, None)
                        connected = False
                    if message == "GET_USER_LIST":
                        self.get_active_users(conn)
                    else:
                        print(f"[{addr}] sent {message}")
                else:
                    connected = False
            except Exception as e:
                print(f"[ERROR] Client {addr}: {e}")
                connected = False
        conn.close()
    
    def get_active_users(self, conn):
        usernames = ', '.join(self.active_users.keys())  # Join all active usernames
        if usernames:
            conn.send(f"{usernames}".encode(self.format))
        else:
            conn.send("No active users.".encode(self.format))


if __name__ == "__main__":
    server = Server(host=socket.gethostbyname(socket.gethostname()), port=5050)
    server.start()
