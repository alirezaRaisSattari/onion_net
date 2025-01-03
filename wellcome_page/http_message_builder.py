class HTTPMessageBuilder:
    def __init__(self, host, port, path, method, headers, body=None):
        """
        Initializes the HTTP message parts.
        """
        self.host = host
        self.port = port
        self.path = path
        self.method = method.upper()  # Ensure the method is uppercase
        self.headers = self._process_headers(headers)
        self.body = body

    @staticmethod
    def _process_headers(header_list):
        """
        Converts a list of dictionaries to a single dictionary of headers.
        Example input: [{"key1": "value1"}, {"key2": "value2"}]
        Example output: {"key1": "value1", "key2": "value2"}
        """
        header_dict = {}
        for header in header_list:
            header_dict.update(header)
        return header_dict

    def to_dict(self):
        """
        Outputs the HTTP message in dictionary format.
        """
        message = {
            "host": self.host,
            "port": self.port,
            "path": self.path,
            "method": self.method,
            "headers": self.headers,
        }
        if self.body:
            message["body"] = self.body
        return message

    def to_http_format(self):
        """
        Outputs the HTTP message in official HTTP string format.
        """
        start_line = f"{self.method} {self.path} HTTP/1.1"
        headers = "\r\n".join(f"{key}: {value}" for key, value in self.headers.items())
        message = f"{start_line}\r\n{headers}\r\n\r\n"
        if self.body:
            message += self.body
        return message


# # Example Usage
# my_variable_for_private_keys = [{"key1": "aesKeyServer1"}, {"key2": "aesKeyServer2"}, {"key3": "aesKeyServer3"}]
# body = "this is the message for body"

# builder = HTTPMessageBuilder(
#     host="localhost",
#     port=8000,
#     path="/",
#     method="GET",
#     headers=my_variable_for_private_keys,
#     body=body,
# )

# # Output as dictionary
# http_dict = builder.to_dict()
# print("http_dict: ", http_dict)
# print("HTTP Message as Dictionary:")
# print(http_dict)

# # Output in official HTTP format
# http_string = builder.to_http_format()
# print("\nHTTP Message in HTTP Format:")
# print(http_string)
