const express = require("express");
const http = require("http");
const OnionSDK = require("../services/onion-connection-service");
const { connectToHost, createHost } = require("./webSocket");
const io = require("socket.io-client");
const app = express();
const PORT = process.env.PORT || 6001;
const routerPort = 4000;
const readline = require("readline");
const onionService = new OnionSDK();
const { spawn } = require("child_process");
const pythonProcess = spawn("python", ["../pynodeqml/main.py", "5001"]);

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
  await createHost(wss);
  await callServer("/host", { ip: "localhost", port: PORT }, "POST");
};

// Start the HTTP and WebSocket server
server.listen(PORT, async () => {
  const socket = io("http://127.0.0.1:5001");
  // Setup Node console input
  // const rl = readline.createInterface({
  //   input: process.stdin,
  //   output: process.stdout,
  // });
  const ws = connectToHost(6000, {
    client: (data) => {
      socket.emit("message_from_node", { data });
    },
  });
  // Every time the user typesconst routerPort = 4000; a line in Node console, send it to Python
  // rl.on("line", (input) => {
  //   socket.emit("message_from_node", { data: input });
  // });

  // Handle successful connection
  socket.on("connect", () => {
    console.log("Connected to Flask-SocketIO server!");
    // Optionally send an initial message
    socket.emit("message_from_node", { data: "Node is connected!" });
  });

  // Listen for messages from Python
  socket.on("message_from_python", (message) => {
    ws({ event: "server", data: message });
    console.log("Message from Python:", message.data);
  });

  // Handle disconnection
  socket.on("disconnect", () => {
    console.log("Disconnected from Flask server");
  });

  socket.on("error", (error) => {
    console.error("Socket error:", error);
  });

  console.log(`Server running on http://localhost:${PORT}`);
});
