const express = require("express");
const http = require("http");
const OnionSDK = require("../services/onion-connection-service");
const { connectToHost, createHost } = require("./webSocket");
const app = express();
const PORT = process.env.PORT || 6001;
const routerPort = 4000;
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
  await createHost(wss);
  await callServer("/host", { ip: "localhost", port: PORT }, "POST");
};

// callServer("/roll-dice", { x: 1 });
// const 
setTimeout(() => {
  // callServer("/host", { x: 1 });
  connectToHost(6000);
  connectToHost(5000);
}, 1000);

// Start the HTTP and WebSocket server
server.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});
