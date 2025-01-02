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
      "User-Agent": "xxx",
      key1: aesKeyServer1,
      key2: aesKeyServer2,
      key3: aesKeyServer3,
    },
  };
  const requestLines = [
    `${requestOptions.method} ${requestOptions.path} HTTP/1.1`,
    `Host: ${requestOptions.headers.Host}`,
    `User-Agent: ${requestOptions.headers["User-Agent"]}`,
    `key1: ${requestOptions.headers["key1"]}`,
    `key2: ${requestOptions.headers["key2"]}`,
    `key3: ${requestOptions.headers["key3"]}`,
    "",
    "",
  ];

  const request = requestLines.join("\r\n");
  return request;
}

async function makeRequest(encryptionCount) {
  const encrypted3 =
    encryptionCount > 3
      ? encryptDataWithAES(httpDataGenerator(), aesKeyServer3)
      : httpDataGenerator();
  const encrypted2 =
    encryptionCount > 2
      ? encryptDataWithAES(encrypted3, aesKeyServer2)
      : encrypted3;
  const encrypted1 =
    encryptionCount > 1
      ? encryptDataWithAES(encrypted2, aesKeyServer1)
      : encrypted2;

  console.log("body: ", encrypted1);
  const serverSocket = net.createConnection(
    { host: "localhost", port: 3000 },
    () => {
      serverSocket.write(encrypted1);
    }
  );
  serverSocket.on("data", (data) => {
    console.log({ encryptionCount, response: data.toString() });
    const decrypted1 =
      encryptionCount > 1
        ? decryptDataWithAES(data.toString(), aesKeyServer1)
        : data;
    const decrypted2 =
      encryptionCount > 2
        ? decryptDataWithAES(decrypted1, aesKeyServer2)
        : decrypted1;
    const decrypted3 =
      encryptionCount > 3
        ? decryptDataWithAES(decrypted2, aesKeyServer3)
        : decrypted2;
    setTimeout(() => {
      const [_headerPart, bodyPart] = decrypted3.toString().split("\r\n\r\n");
      console.log({ res: bodyPart });
      if (encryptionCount < 4) makeRequest(JSON.parse(bodyPart).index);
    }, 4000);
    serverSocket.end(); // Close the connection after receiving the response
  });
}

makeRequest(1);
