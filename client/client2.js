const express = require("express");
const http = require("http");
const OnionSDK = require("../services/onion-connection-service");
const { connectToHost, createHost } = require("./webSocket");
const io = require("socket.io-client");
const app = express();
const PORT = process.env.PORT || 6001;
const routerPort = 4000;
const guiServer = "5001";
const readline = require("readline");
const { stdin, stdout } = require("process");
const onionService = new OnionSDK();
// const { spawn } = require("child_process");
// const pythonProcess = spawn("python", ["../pynodeqml/main.py", guiServer]);

async function callServer(path, body, method) {
  // const x = await onionService.sendRequest(
  //   PORT,
  //   routerPort,
  //   path,
  //   JSON.stringify(body),
  //   method
  // );
  // console.log(x);
}
const server = http.createServer(app);

const createWSHost = async () => {
  const wss = new WebSocket.Server({ server });
  await createHost(wss);
  await callServer("/host", { ip: "localhost", port: PORT }, "POST");
};

setTimeout(() => {
  // Start the HTTP and WebSocket server
  server.listen(PORT, async () => {
    const socket = io("http://127.0.0.1:" + guiServer);
    const ws = connectToHost(6000, {
      client: (data) => {
        callServer("/roll-dice", { x: 1 });
        const res = Math.floor(Math.random() * 2) + 1;
        console.log("xxxxyyyyyyy", data);
        ws(
          "message_from_node",
          JSON.stringify({
            data: data + " dice" + res + res == 3 ? res - 1 : res + 1,
            dice1: res,
            dice2: res == 3 ? res - 1 : res + 1,
          })
        );
      },
      client_chat: (data) => {
        console.log("massage from other client: ", data);
      },
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
      console.log("calling client2");
      ws(JSON.stringify({ event: "server", data: message.data }));
    });

    const rl = readline.createInterface({ input: stdin, output: stdout });
    console.log("You can chat here:");
    rl.on("line", (input) => {
      ws(JSON.stringify({ event: "server_chat", data: input }));
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
}, 3000);
