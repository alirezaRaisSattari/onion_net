const serverPort = 8000;
// const serverPort = 5050;
const net = require("net");
const {
  encryptDataWithAES,
  decryptDataWithAES,
} = require("./services/crypto-util.js");

function httpResponseGenerator(index) {
  const jsonResponse = JSON.stringify({ index });
  console.log(jsonResponse);
  return [
    "HTTP/1.1 200 OK",
    "Content-Type: application/json",
    `Content-Length: ${jsonResponse.length}`,
    "",
    jsonResponse,
  ].join("\r\n");
}

function getKeyFromClient(data, index) {
  // const requestData = data.toString();
  const requestData = data.toString("utf-8"); // Decode the incoming message as UTF-8
  console.log("[ROUTER] Decoded message from client:", requestData);
  console.log("[ROUTER] index is ", index);

  // Split the request into lines
  const requestLines = requestData.split("\r\n");
  // Extract headers
  const headers = {};
  for (let i = 1; i < requestLines.length; i++) {
    const line = requestLines[i];
    if (line === "") break; // Stop at the empty line
    const [headerName, headerValue] = line.split(": ");
    headers[headerName.toLowerCase()] = headerValue;
  }
  let aesKeyServer;
  if (headers[`key${index}`]) aesKeyServer = headers[`key${index}`];
  console.log(`update aes Key Server: ${index}`, aesKeyServer);
  return aesKeyServer;
}

const createRouter = (index, curPort, nextPort) => {
  let aesKeyServer;
  const proxy = net.createServer((clientSocket) => {
    clientSocket.on("data", (data) => {
      // Parse the HTTP request to extract the hostname and port
      console.log("receive request in server ", index);
      aesKeyServer = aesKeyServer || getKeyFromClient(data, index);
      if (!aesKeyServer) {
        console.log(`not found any key in server `, index);
        clientSocket.write(httpResponseGenerator(index));
        clientSocket.end();
        return;
      }

      // is body encrypted, if it's not return
      try {
        decryptDataWithAES(data.toString(), aesKeyServer);
      } catch (error) {
        console.log(
          "can't encrypt in further servers any more. now in server ",
          index
        );
        clientSocket.write(httpResponseGenerator(index + 1));
        clientSocket.end();
        return;
      }

      // Connect to the target server
      const serverSocket = net.createConnection(
        { host: "localhost", port: nextPort },
        () => {
          const decryptedData = decryptDataWithAES(
            data.toString(),
            aesKeyServer
          );
          serverSocket.write(decryptedData);
        }
      );

      serverSocket.on("data", (serverData) => {
        // Decrypt the server response and forward it to the client
        const encryptedData = encryptDataWithAES(serverData, aesKeyServer);
        // console.log(`encrypted data from server: `, index, serverData);
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

  proxy.listen(curPort, () => {
    console.log(`Proxy server listening on port ${curPort}`);
  });
};

(() => {
  createRouter(1, 3000, 3001);
  createRouter(2, 3001, 3002);
  createRouter(3, 3002, serverPort);
})();

(() => {
  createRouter(1, 4000, 4001);
  createRouter(2, 4001, 4002);
  createRouter(3, 4002, serverPort);
})();
