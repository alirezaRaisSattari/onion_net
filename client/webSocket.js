const WebSocket = require("ws");

function getCurrentTime() {
  const now = new Date();
  return now.toTimeString();
}

const connectToHost = (port, eventHandlers) => {
  const ws = new WebSocket("ws://localhost:" + port);
  function sendEvent(body) {
    ws.send(JSON.stringify(body));
  }

  ws.onopen = () => {
    console.log("WebSocket connection opened");
    sendEvent({ event: "greet", data: "Hello, Server!" });
  };

  ws.onmessage = (event) => {
    const msg = JSON.parse(event.data);
    console.log("received event as client:", msg);
    handleReceivedMessages(msg);
  };

  ws.onclose = () => {
    console.log("WebSocket connection closed");
  };

  ws.onerror = (error) => {
    console.error("WebSocket error:", error);
  };
  return { sendEvent };
};

const createHost = (wss) =>
  new Promise((resolve, reject) => {
    wss.on("connection", (ws) => {
      console.log("New WebSocket connection");

      ws.on("message", (message) => {
        console.log(`received event as host: ${message}`);
        handleReceivedMessages(message);
      });
      ws.on("error", (message) => {
        reject(message);
      });
      resolve(ws);
      ws.send(JSON.stringify({ msg: "Welcome to the WebSocket server!" }));
    });
    return {};
  });

// Function to handle messages received from clients
function handleReceivedMessages(msg) {
  if (msg.event && eventHandlers[msg.event]) {
    eventHandlers[msg.event](msg.data);
  } else {
    console.log("Unknown event received in client:", msg.event);
  }
}

module.exports = { connectToHost, createHost };