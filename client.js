const axios = require("axios");

async function makeRequest() {
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
        },
      }
    );

    console.log("Response:", response.data);
  } catch (error) {
    console.error("Error:", error.message);
  }
}

makeRequest();
