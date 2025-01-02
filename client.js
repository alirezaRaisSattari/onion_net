const net = require("net");
const crypto = require("crypto");
const { encryptDataWithAES, decryptDataWithAES } = require("./crypto-util.js");

const aesKeyServer1 = crypto.randomBytes(32).toString("hex");
const aesKeyServer2 = crypto.randomBytes(32).toString("hex");
const aesKeyServer3 = crypto.randomBytes(32).toString("hex");

function httpDataGenerator(index) {
  const requestOptions = {
    host: "localhost",
    port: 8000,
    path: "/",
    method: "GET",
    headers: {
      Host: "localhost",
      key1: `CustomValue${index}`,
      key2: `CustomValue${index}`,
      key3: `CustomValue${index}`,
    },
  };

  const request = [
    `${requestOptions.method} ${requestOptions.path} HTTP/1.1`,
    `Host: ${requestOptions.headers.Host}`,
    `User-Agent: ${requestOptions.headers["User-Agent"]}`,
    "",
    "",
  ].join("\r\n");
  return request;
}

async function makeRequest() {
  const encrypted1 = encryptDataWithAES(httpDataGenerator(), aesKeyServer1);
  const encrypted2 = encryptDataWithAES(encrypted1, aesKeyServer2);
  const encrypted3 = encryptDataWithAES(encrypted2, aesKeyServer3);
  const serverSocket = net.createConnection(
    { host: "localhost", port: 3000 },
    () => {
      serverSocket.write(encrypted3);
    }
  );
  serverSocket.on("data", (data) => {
    console.log("Received from server:", data.toString());
    serverSocket.end(); // Close the connection after receiving the response
  });
}

makeRequest();
