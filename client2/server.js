const express = require("express");
const http = require("http");
const OnionSDK = require("../services/onion-connection-service");
const app = express();
const PORT = 5000;

app.set("view engine", "ejs");
const onionService = new OnionSDK();

function getCurrentTime() {
  const now = new Date();
  return now.toTimeString();
}

async function registerInServer() {
  console.log(1111);
  const x = await onionService.sendRequest(
    PORT,
    3000,
    "/register",
    JSON.stringify({ x: 1 })
  );
  console.log(x);
}

app.post("/receive-msg", (req, res) => {
  const currentTime = getCurrentTime();
  res.render("index", { currentTime });
});

// HTTP route
app.get("/", async (req, res) => {
  const currentTime = getCurrentTime();
  res.render("index", { registerInServer: await registerInServer() });
});

// Create an HTTP server
const server = http.createServer(app);

// Start the HTTP and WebSocket server
server.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});
