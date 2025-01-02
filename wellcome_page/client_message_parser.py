import re
import json

class MessageParser:
    def __init__(self, message):
        self.message = message
        self.respond_type = None
        self.json_data = None
        self.parsed_message = None
        self._determine_message_type()

    def _determine_message_type(self):
        """Determines the message type and parses accordingly."""
        if self.message.startswith("HTTP/"):
            self.respond_type = "router"
            self.json_data = self._extract_http_json()
        elif self.message.startswith("[SERVER]"):
            self.respond_type = "main_server"
            self.parsed_message = self._extract_server_message()
        else:
            raise ValueError("Unknown message type.")

    def _extract_http_json(self):
        """Extracts the JSON part of an HTTP message."""
        match = re.search(r'\{.*\}', self.message)
        if match:
            try:
                return json.loads(match.group())
            except json.JSONDecodeError:
                raise ValueError("Invalid JSON format in HTTP message.")
        return None

    def _extract_server_message(self):
        """Extracts the message content from a server response."""
        match = re.search(r'\[SERVER\]\s*(.+)', self.message)
        if match:
            return match.group(1).strip()
        return None

    def get_json_value(self, key):
        """Retrieves a value from the JSON data by key."""
        if self.respond_type != "router":
            raise ValueError("JSON extraction is only valid for 'router' type messages.")
        if self.json_data is None:
            raise ValueError("No JSON data found in the message.")
        return self.json_data.get(key)

    def get_server_message(self):
        """Returns the message content from a main server response."""
        if self.respond_type != "main_server":
            raise ValueError("Server message extraction is only valid for 'main_server' type messages.")
        return self.parsed_message


# Example Usage

# http_message = """HTTP/1.1 200 OK
# Content-Type: application/json
# Content-Length: 11

# {"index":1}"""

# # Non-HTTP message (main_server)
# server_message = "[SERVER] this is a response from the server."

# # Parse the HTTP message
# http_parser = MessageParser(http_message)
# print("Respond Type:", http_parser.respond_type)
# print("Index:", http_parser.get_json_value("index"))

# # Parse the non-HTTP message
# server_parser = MessageParser(server_message)
# print("Respond Type:", server_parser.respond_type)
# print("Server Message:", server_parser.get_server_message())
