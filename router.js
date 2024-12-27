const net = require("net");
const crypto = require("crypto");

// Simple XOR encryption/decryption
const XOR_KEY = "my_secret_key";

function xorEncryptDecrypt(data, key) {
  const keyBuffer = Buffer.from(key);
  const encrypted = Buffer.alloc(data.length);
  for (let i = 0; i < data.length; i++) {
    encrypted[i] = data[i] ^ keyBuffer[i % keyBuffer.length];
  }
  return encrypted;
}

const proxy = net.createServer((clientSocket) => {
  console.log("Client connected:", clientSocket.remoteAddress);

  clientSocket.once("data", (data) => {
    // Parse the HTTP request to extract the hostname and port
    const request = data.toString();
    const [hostHeader] = request.match(/Host: .+/) || [];
    // const [, hostname] = hostHeader.split(":") || [];
    const [, hostname, port] = hostHeader.split(":");
    // const port = hostHeader.includes(":") ? hostname.split(":")[1] : 80;
    console.log("first", hostname, port);

    // Connect to the target server
    const serverSocket = net.createConnection(
      { host: hostname.trim(), port },
      () => {
        console.log(`Connected to target server: ${hostname} ${port}`);
        // Encrypt and forward the original request to the server
        const encryptedData = xorEncryptDecrypt(data, XOR_KEY);
        console.log(`encrypted data: ${encryptedData}`);
        serverSocket.write(encryptedData);
      }
    );

    serverSocket.on("data", (serverData) => {
      // Decrypt the server response and forward it to the client
      const decryptedData = xorEncryptDecrypt(serverData, XOR_KEY);
      clientSocket.write(decryptedData);
    });

    serverSocket.on("error", (err) => {
      console.error("Error connecting to target server:", err.message);
      clientSocket.end("HTTP/1.1 502 Bad Gateway\r\n\r\n");
    });

    clientSocket.on("error", (err) => {
      console.error("Client connection error:", err.message);
    });

    serverSocket.on("end", () => {
      clientSocket.end();
    });
  });
});

const PORT = 3000;
proxy.listen(PORT, () => {
  console.log(`Proxy server listening on port ${PORT}`);
});
