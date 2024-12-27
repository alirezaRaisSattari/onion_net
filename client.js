const axios = require("axios");

async function makeRequest() {
  const proxy1 = "http://localhost:3000"; // Proxy server URL
  const targetServer = "localhost:8000"; // Target server details

  try {
    let response = await axios.get(proxy1, {
      headers: {
        Host: targetServer, // Add the Host header for the target server
      },
    });

    console.log("Response:", response.data);
  } catch (error) {
    console.error("Error:", error.message);
  }
}

makeRequest();
