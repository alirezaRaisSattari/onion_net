const axios = require("axios");
const crypto = require("crypto");

async function makeRequest() {
  const aesKeyServer1 = crypto.randomBytes(32).toString("hex");
  const aesKeyServer2 = crypto.randomBytes(32).toString("hex");
  const aesKeyServer3 = crypto.randomBytes(32).toString("hex");
  const proxy1 = "http://localhost:3000"; // Proxy server URL
  const targetServer = "localhost:8000"; // Target server details

  try {
    let response = await axios.post(
      proxy1,
      {
        // Data to be sent in the body of the request
        data: {
          key1: "value1",
          key2: "value2",
        },
      },
      {
        headers: {
          Host: targetServer, // Add the Host header for the target server
          Key1: aesKeyServer1,
          Key2: aesKeyServer2,
          Key3: aesKeyServer3,
        },
      }
    );

    console.log(response.data);
  } catch (error) {
    console.error("Error:", error.message);
  }
}

makeRequest();
