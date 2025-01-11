const express = require("express");
const http = require("http");
const OnionSDK = require("../services/onion-connection-service");
const WebSocket = require("ws");
const { connectToHost, createHost } = require("./webSocket");
const app = express();
const PORT = process.env.PORT || 6000;
const routerPort = 3000;

app.set("view engine", "ejs");
const onionService = new OnionSDK();

async function callServer(path, body, method) {
  const x = await onionService.sendRequest(
    PORT,
    routerPort,
    path,
    JSON.stringify(body),
    method
  );
  console.log(x);
}
const server = http.createServer(app);
const createWSHost = async () => {
  const wss = new WebSocket.Server({ server });
  const eventSender = await createHost(wss);
  await callServer("/host", { ip: "localhost", port: PORT }, "POST");
  return eventSender;
};

// callServer("/roll-dice", { x: 1 });
// setTimeout(() => {
//   callServer("/host", { x: 1 });
// }, 1000);

connectToHost(5001);

// Create an HTTP server

// Start the HTTP and WebSocket server
server.listen(PORT, async () => {
  console.log(`Server running on http://localhost:${PORT}`);
  const eventSender = await createWSHost();
  setInterval(() => {
    eventSender.send(JSON.stringify({ msg: "Welcome to 22222" }));
  }, 5000);
});
