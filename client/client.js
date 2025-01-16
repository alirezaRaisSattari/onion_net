const express = require("express");
const http = require("http");
const OnionSDK = require("../services/onion-connection-service");
const WebSocket = require("ws");
const { connectToHost, createHost } = require("./webSocket");
const app = express();
const io = require("socket.io-client");
const readline = require("readline");
const { stdin, stdout } = require("process");
const fileWatcher = require("./fileWatcher");
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
  return JSON.parse(x);
}
const server = http.createServer(app);
const createWSHost = async (eventHandlers) => {
  const wss = new WebSocket.Server({ server });
  const eventSender = await createHost(wss, eventHandlers);
  // await callServer("/host", { ip: "localhost", port: PORT }, "POST");
  return eventSender;
};

async function rollDice() {
  const res = await callServer("/roll-dice", { x: 1 });
  console.log(res);
  console.log(res.diceNumber);
  return `${res.diceNumber}${
    res.diceNumber == 3 ? res.diceNumber - 1 : res.diceNumber + 1
  }`;
}

// Start the HTTP and WebSocket server
server.listen(PORT, async () => {
  console.log(`Server running on http://localhost:${PORT}`);
  const eventSender = await createWSHost({
    server: (data) => {
      console.log("calling pyyyyyyy");
      callServer("/roll-dice", { x: 1 });
      const res = Math.floor(Math.random() * 2) + 1;
      console.log(
        "xxxxyyyyyyy",
        JSON.stringify({
          data: `${data} dice ${res}${res == 3 ? res - 1 : res + 1}`,
        })
      );
    },
    server_chat: (data) => {
      console.log("massage from other client: ", data);
    },
  });
  fileWatcher(
    "../writeSharedMemory1",
    "../readSharedMemory2",
    rollDice,
    eventSender
  );

  const rl = readline.createInterface({ input: stdin, output: stdout });
  console.log("You can chat here:");
  rl.on("line", (input) => {
    eventSender.send(JSON.stringify({ event: "client_chat", data: input }));
  });
});
