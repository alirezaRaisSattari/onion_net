const net = require("net");
const { encryptDataWithAES, decryptDataWithAES } = require("./crypto-util.js");

function httpResponseGenerator(index) {
  const jsonResponse = JSON.stringify({ index: index });
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
  const requestData = data.toString();
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
  console.log("key header:", `key${index}`, headers[`key${index}`], headers);
  if (headers[`key${index}`]) aesKeyServer = headers[`key${index}`];
  console.log(aesKeyServer);
  return aesKeyServer;
}

const createRouter = (index, curPort, nextPort) => {
  const proxy = net.createServer((clientSocket) => {
    clientSocket.on("data", (data) => {
      // Parse the HTTP request to extract the hostname and port
      console.log("xxxxxxxxxxx", index);
      let aesKeyServer = getKeyFromClient(data, index);
      if (!aesKeyServer) {
        clientSocket.write(httpResponseGenerator());
        clientSocket.end();
        return;
      }
      console.log("xxxxxxxxxxx", index);
      // Connect to the target server
      const serverSocket = net.createConnection(
        { host: "localhost", port: nextPort },
        () => {
          console.log("yyyyyyyyy", index);
          const decryptedData = decryptDataWithAES(
            data.toString(),
            aesKeyServer
          );
          console.log("zzzzzzzzzz", index);
          serverSocket.write(decryptedData);
        }
      );

      serverSocket.on("data", (serverData) => {
        // Decrypt the server response and forward it to the client
        console.log(`decrypted data from server: ${serverData}`);
        const encryptedData = encryptDataWithAES(serverData, aesKeyServer);
        console.log(`encrypted data from server: ${encryptedData}`);
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
  createRouter(3, 3002, 8000);
})();

(() => {
  createRouter(1, 4000, 4001);
  createRouter(2, 4001, 4002);
  createRouter(3, 4002, 8000);
})();
