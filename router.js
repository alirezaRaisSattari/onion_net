const net = require("net");
const crypto = require("crypto");

// Simple XOR encryption/decryption
const XOR_KEY = "my_secret_key";

console.log("Public Key:", publicKey);
console.log("Private Key:", privateKey);

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

  clientSocket.on("data", (data) => {
    // Parse the HTTP request to extract the hostname and port
    const request = data.toString();
    const [hostHeader] = request.match(/Host: .+/) || [];
    const [, hostname, port] = hostHeader.split(":");
    console.log("Hostname:", hostname, "Port:", port);

    // Connect to the target server
    const serverSocket = net.createConnection(
      { host: "localhost", port: 3001 },
      () => {
        // console.log(`Connected to target server: ${hostname} ${port}`);
        // Encrypt and forward the original request to the server
        const encryptedData = xorEncryptDecrypt(data, XOR_KEY);
        console.log(`Encrypted data: ${encryptedData.toString("hex")}`);
        serverSocket.write(encryptedData);
      }
    );

    // serverSocket.on("data", (serverData) => {
    //   // Decrypt the server response and forward it to the client
    //   console.log(`Decrypted data from server: ${serverData}`);
    //   const decryptedData = xorEncryptDecrypt(serverData, XOR_KEY);
    //   console.log(`Decrypted data from server: ${decryptedData.toString()}`);
    //   clientSocket.write("xxx");
    // });

    // serverSocket.on("error", (err) => {
    //   console.error("Error connecting to target server:", err.message);
    //   clientSocket.end("HTTP/1.1 502 Bad Gateway\r\n\r\n");
    // });

    // clientSocket.on("error", (err) => {
    //   console.error("Client connection error:", err.message);
    // });

    // serverSocket.on("end", () => {
    //   clientSocket.end();
    // });
  });
});

proxy.listen(3000, () => {
  console.log(`Proxy server listening on port ${3000}`);
});

function xorEncryptDecrypt(data, key) {
  const keyBuffer = Buffer.from(key);
  const encrypted = Buffer.alloc(data.length);
  for (let i = 0; i < data.length; i++) {
    encrypted[i] = data[i] ^ keyBuffer[i % keyBuffer.length];
  }
  return encrypted;
}

const proxy2 = net.createServer((clientSocket) => {
  console.log("Client connected:", clientSocket.remoteAddress);

  clientSocket.on("data", (data) => {
    // Parse the HTTP request to extract the hostname and port
    const request = data.toString();
    // const [hostHeader] = request.match(/Host: .+/) || [];
    // const [, hostname, port] = hostHeader.split(":");
    // console.log("Hostname:", hostname, "Port:", port);

    // Connect to the target server
    const serverSocket = net.createConnection(
      { host: "localhost", port: 8000 },
      () => {
        console.log("encrypted in server2: ", data);
        const decryptedData = xorEncryptDecrypt(data, XOR_KEY);
        console.log(`decrypted data server22222222: ${decryptedData}`);
        serverSocket.write(decryptedData);
      }
    );

    // serverSocket.on("data", (serverData) => {
    //   // Decrypt the server response and forward it to the client
    //   console.log(`encrypted data from server2: ${serverData}`);
    //   const decryptedData = xorEncryptDecrypt(serverData, XOR_KEY);
    //   console.log(`Decrypted data from server2: ${decryptedData.toString()}`);
    //   clientSocket.write("xxx");
    // });

    // serverSocket.on("error", (err) => {
    //   console.error("Error connecting to target server:", err.message);
    //   clientSocket.end("HTTP/1.1 502 Bad Gateway\r\n\r\n");
    // });

    // clientSocket.on("error", (err) => {
    //   console.error("Client connection error:", err.message);
    // });

    serverSocket.on("end", () => {
      clientSocket.end();
    });
  });
});

proxy2.listen(3001, () => {
  console.log(`Proxy server listening on port ${3001}`);
});
