const net = require("net");
const crypto = require("crypto");
const { encryptDataWithAES, decryptDataWithAES } = require("./crypto-util.js");
const aesKeyServer1 = crypto.randomBytes(32).toString("hex");
const aesKeyServer2 = crypto.randomBytes(32).toString("hex");
const aesKeyServer3 = crypto.randomBytes(32).toString("hex");

const proxy = net.createServer((clientSocket) => {
  clientSocket.on("data", (data) => {
    // Parse the HTTP request to extract the hostname and port
    // const request = data.toString();
    // const [hostHeader] = request.match(/Host: .+/) || [];
    const [, hostname, port] = hostHeader.split(":");

    // Connect to the target server
    const serverSocket = net.createConnection(
      { host: "localhost", port: 4001 },
      () => {
        // Encrypt and forward the original request to the server
        const encryptedData = encryptDataWithAES(data, aesKeyServer1);
        serverSocket.write(encryptedData);
      }
    );

    serverSocket.on("data", (serverData) => {
      // Decrypt the server response and forward it to the client
      console.log(`Encrypted data from server: ${serverData}`);
      const decryptedData = decryptDataWithAES(
        serverData.toString(),
        aesKeyServer2
      );
      console.log(`Decrypted data from server: ${decryptedData}`);
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

proxy.listen(4000, () => {
  console.log(`Proxy server listening on port ${4000}`);
});

const proxy2 = net.createServer((clientSocket) => {
  clientSocket.on("data", (data) => {
    // Decrypt the data received from the first proxy
    // console.log(`encrypted data in server2: ${data}`);

    // Connect to the target server
    const serverSocket = net.createConnection(
      { host: "localhost", port: 4002 },
      () => {
        const decryptedData = decryptDataWithAES(
          data.toString(),
          aesKeyServer1
        );
        // console.log(`Decrypted data in server2: ${decryptedData}`);
        const encryptedData = encryptDataWithAES(decryptedData, aesKeyServer2);
        // console.log(`Encrypted data in server2: ${encryptedData}`);
        serverSocket.write(encryptedData);
      }
    );

    serverSocket.on("data", (serverData) => {
      const decryptedData = decryptDataWithAES(
        serverData.toString(),
        aesKeyServer3
      );
      console.log(`Decrypted data in server2: ${decryptedData}`);
      const encryptedData = encryptDataWithAES(decryptedData, aesKeyServer2);
      console.log(`Encrypted data in server2: ${encryptedData}`);
      clientSocket.write(encryptedData);
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

proxy2.listen(4001, () => {
  console.log(`Proxy server2 listening on port ${4001}`);
});

const proxy3 = net.createServer((clientSocket) => {
  clientSocket.on("data", (data) => {
    // Decrypt the data received from the first proxy

    // Connect to the target server
    const serverSocket = net.createConnection(
      { host: "localhost", port: 8000 },
      () => {
        // console.log(`encrypted data in server3: ${data}`);
        const decryptedData = decryptDataWithAES(
          data.toString(),
          aesKeyServer2
        );

        // console.log(`Decrypted data in server3: ${decryptedData}`);

        serverSocket.write(decryptedData);
      }
    );

    serverSocket.on("data", (serverData) => {
      // Encrypt the server response and forward it to the client
      console.log(`Data from target server: ${serverData}`);
      const encryptedData = encryptDataWithAES(
        serverData.toString(),
        aesKeyServer3
      );
      console.log(`Encrypted data to client server3: ${encryptedData}`);
      clientSocket.write(encryptedData);
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

proxy3.listen(4002, () => {
  console.log(`Proxy server2 listening on port ${4002}`);
});
