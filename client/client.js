const express = require("express");
const http = require("http");
const OnionSDK = require("../services/onion-connection-service");
const WebSocket = require("ws");
const { connectToHost, createHost } = require("./webSocket");
const app = express();
const io = require("socket.io-client");
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

// Start the HTTP and WebSocket server
server.listen(PORT, async () => {
  console.log(`Server running on http://localhost:${PORT}`);
  const eventSender = await createWSHost();
  const socket = io("http://127.0.0.1:5000");
  // Setup Node console input
  const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout,
  });

  // Every time the user types a line in Node console, send it to Python
  rl.on("line", (input) => {
    socket.emit("message_from_node", { data: input });
  });

  // Handle successful connection
  socket.on("connect", () => {
    console.log("Connected to Flask-SocketIO server!");
    // Optionally send an initial message
    socket.emit("message_from_node", { data: "Node is connected!" });
  });

  // Listen for messages from Python
  socket.on("message_from_python", (message) => {
    console.log("Message from Python:", message.data);
  });

  // Handle disconnection
  socket.on("disconnect", () => {
    console.log("Disconnected from Flask server");
  });

  socket.on("error", (error) => {
    console.error("Socket error:", error);
  });

  setInterval(() => {
    eventSender.send(JSON.stringify({ msg: "Welcome to 22222" }));
  }, 5000);
});
