const express = require("express");
const http = require("http");
const OnionSDK = require("../services/onion-connection-service");
const WebSocket = require("ws");
const { connectToHost, createHost } = require("./webSocket");
const app = express();
const guiServer = "5000";
const io = require("socket.io-client");
const readline = require("readline");
const PORT = process.env.PORT || 6000;
const routerPort = 3000;
// const { spawn } = require("child_process");
// const pythonProcess = spawn("python", ["../pynodeqml/main.py", guiServer]);

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
const createWSHost = async (eventHandlers) => {
  const wss = new WebSocket.Server({ server });
  const eventSender = await createHost(wss, eventHandlers);
  // await callServer("/host", { ip: "localhost", port: PORT }, "POST");
  return eventSender;
};

// callServer("/roll-dice", { x: 1 });
// setTimeout(() => {
// callServer("/host", { x: 1 });
// }, 1000);

// connectToHost(5001);
setTimeout(() => {
  // Start the HTTP and WebSocket server
  server.listen(PORT, async () => {
    console.log(`Server running on http://localhost:${PORT}`);
    const socket = io("http://127.0.0.1:" + guiServer);
    const eventSender = await createWSHost({
      server: async (data) => {
        const res = await callServer("/roll-dice", { x: 1 });
        console.log("rollllll client1: ", res);
        socket.emit("message_from_node", { data: data + res });
      },
      server_chat: (data) => {
        console.log("massage from other client: ", data);
      },
    });

    const readline = require("readline");
    const rl = readline.createInterface({
      input: process.stdin,
      output: process.stdout,
    });
    rl.question("you can chat here: ", (input) => {
      eventSender.send(JSON.stringify({ event: "client_chat", data: input }));
    });
    socket.emit("message_from_node", { data: "username" });
    // Handle successful connection
    socket.on("connect", () => {
      console.log("Connected to Flask-SocketIO server!");
      // Optionally send an initial message
      socket.emit("message_from_node", { data: "Node is connected!" });
    });

    // Listen for messages from Python
    socket.on("message_from_python", (message) => {
      console.log("Message from Python:", message.data);
      console.log("calling client2: ", message.data);
      eventSender.send(JSON.stringify({ event: "client", data: message }));
    });

    // Handle disconnection
    socket.on("disconnect", () => {
      console.log("Disconnected from Flask server");
    });

    socket.on("error", (error) => {
      console.error("Socket error:", error);
    });

    // setInterval(() => {
    //   eventSender.send(JSON.stringify({ msg: "Welcome to 22222" }));
    // }, 5000);
  });
}, 3000);
