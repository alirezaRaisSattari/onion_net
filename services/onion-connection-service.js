const net = require("net");
const crypto = require("crypto");
const { encryptDataWithAES, decryptDataWithAES } = require("./crypto-util.js");

class OnionSDK {
  constructor() {
    this.aesKeyServer1 = crypto.randomBytes(32).toString("hex");
    this.aesKeyServer2 = crypto.randomBytes(32).toString("hex");
    this.aesKeyServer3 = crypto.randomBytes(32).toString("hex");
  }

  httpDataGenerator(path, method, address, body, isInit = false) {
    const requestOptions = {
      host: "localhost",
      port: 8000,
      path,
      method,
      headers: {
        Host: "localhost",
        ip: address,
        key1: this.aesKeyServer1,
        key2: this.aesKeyServer2,
        key3: this.aesKeyServer3,
        "Content-Type": "application/json",
        "Content-Length": Buffer.byteLength(body),
      },
    };

    const requestLines = [
      `${requestOptions.method} ${requestOptions.path} HTTP/1.1`,
      `Host: ${requestOptions.headers.Host}`,
      `User-Agent: ${requestOptions.headers["User-Agent"]}`,
      `key1: ${requestOptions.headers["key1"]}`,
      `key2: ${requestOptions.headers["key2"]}`,
      `key3: ${requestOptions.headers["key3"]}`,
      `Content-Type: ${requestOptions.headers["Content-Type"]}`,
      `Content-Length: ${requestOptions.headers["Content-Length"]}`,
      "",
      body,
    ];
    const request = isInit
      ? `key1:${this.aesKeyServer1},key2:${this.aesKeyServer2},key3:${this.aesKeyServer3}`
      : requestLines.join("\r\n");
    return request;
  }

  sendRequest(
    clientAddress,
    destPort,
    path,
    body,
    method = "GET",
    encryptionCount = 4
  ) {
    return new Promise((resolve, reject) => {
      const encrypted3 =
        encryptionCount > 3
          ? encryptDataWithAES(
              this.httpDataGenerator(
                path,
                method,
                clientAddress,
                body,
                encryptionCount < 4
              ),
              this.aesKeyServer3
            )
          : this.httpDataGenerator(
              path,
              method,
              clientAddress,
              body,
              encryptionCount < 4
            );
      const encrypted2 =
        encryptionCount > 2
          ? encryptDataWithAES(encrypted3, this.aesKeyServer2)
          : encrypted3;
      const encrypted1 =
        encryptionCount > 1
          ? encryptDataWithAES(encrypted2, this.aesKeyServer1)
          : encrypted2;

      console.log("body: ", encrypted1);
      const serverSocket = net.createConnection(
        { host: "localhost", port: destPort },
        () => {
          serverSocket.write(encrypted1);
        }
      );

      // Handle response
      serverSocket.on("data", (data) => {
        console.log({ encryptionCount, response: data.toString() });
        let decrypted1, decrypted2, decrypted3;
        try {
          decrypted1 =
            encryptionCount > 1
              ? decryptDataWithAES(data.toString(), this.aesKeyServer1)
              : data;
          decrypted2 =
            encryptionCount > 2
              ? decryptDataWithAES(decrypted1, this.aesKeyServer2)
              : decrypted1;
          decrypted3 =
            encryptionCount > 3
              ? decryptDataWithAES(decrypted2, this.aesKeyServer3)
              : decrypted2;
        } catch (error) {
          console.error("can't decrypt: ", error);
          decrypted3 = data.toString();
        }
        setTimeout(() => {
          const [_headerPart, bodyPart] = decrypted3
            .toString()
            .split("\r\n\r\n");
          console.log({ res: bodyPart });
          try {
            const index = JSON.parse(bodyPart)?.index;
            if (encryptionCount < 4 || index < 4) {
              this.sendRequest(
                clientAddress,
                destPort,
                path,
                body,
                method,
                index
              )
                .then(resolve)
                .catch(reject);
            } else {
              resolve(bodyPart || decrypted3); // Resolve the Promise when it reaches the else block
            }
          } catch (error) {
            console.error("error in server: ", bodyPart);
            reject(bodyPart || decrypted3); // Resolve the Promise when it reaches the else block
          }
        }, 10);
        serverSocket.end(); // Close the connection after receiving the response
      });

      serverSocket.on("error", (error) => {
        reject(error); // Reject the Promise on error
      });
    });
  }
}

module.exports = OnionSDK;
