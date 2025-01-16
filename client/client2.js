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
const fs = require("fs");
const fileWatcher = require("./fileWatcher");
// const { spawn } = require("child_process");
// const pythonProcess = spawn("python", ["../pynodeqml/main.py", guiServer]);

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
callServer("/roll-dice", { x: 1 });

const createWSHost = async () => {
  const wss = new WebSocket.Server({ server });
  await createHost(wss);
  await callServer("/host", { ip: "localhost", port: PORT }, "POST");
};

async function rollDice() {
  const res = await callServer("/roll-dice", { x: 1 });
  console.log("dice: ", res.diceNumber);
  return `${res.diceNumber}${
    res.diceNumber == 3 ? res.diceNumber - 1 : res.diceNumber + 1
  }`;
}

// Start the HTTP and WebSocket server
server.listen(PORT, async () => {
  const ws = connectToHost(6000, {
    client: (data) => {
      callServer("/roll-dice", { x: 1 });
      const res = Math.floor(Math.random() * 2) + 1;
      console.log("xxxxyyyyyyy", data);
      ws(
        "message_from_node",
        JSON.stringify({
          data: `${data} dice${res}${res == 3 ? res - 1 : res + 1}`,
        })
      );
    },
    client_chat: (data) => {
      console.log("massage from other client: ", data);
    },
  });
  fileWatcher("../writeSharedMemory2", "../readSharedMemory1", rollDice, ws);

  // Listen for messages from Python
  // socket.on("message_from_python", (message) => {
  // console.log("Message from Python:", message.data);
  // console.log("calling client2");

  // });

  const rl = readline.createInterface({ input: stdin, output: stdout });
  console.log("You can chat here:");
  rl.on("line", (input) => {
    ws(JSON.stringify({ event: "server_chat", data: input }));
  });

  console.log(`Server running on http://localhost:${PORT}`);
});
