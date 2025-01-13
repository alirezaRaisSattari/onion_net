const WebSocket = require("ws");

function getCurrentTime() {
  const now = new Date();
  return now.toTimeString();
}

const connectToHost = (port, eventHandlers) => {
  const ws = new WebSocket("ws://localhost:" + port);
  function sendEvent(body) {
    ws.send(body);
  }

  ws.onopen = () => {
    console.log("WebSocket connection opened");
    sendEvent(JSON.stringify({ event: "greet", data: "Hello, Server!" }));
  };

  ws.onmessage = async (event) => {
    const msg = JSON.parse(event.data);
    console.log("received event as client:", msg);
    await handleReceivedMessages(msg, eventHandlers);
  };

  ws.onclose = () => {
    console.log("WebSocket connection closed");
  };

  ws.onerror = (error) => {
    console.error("WebSocket error:", error);
  };
  return sendEvent;
};

const createHost = (wss, eventHandlers) =>
  new Promise((resolve, reject) => {
    wss.on("connection", (ws) => {
      console.log("New WebSocket connection");

      ws.on("message", async (message) => {
        const parsedMsg = JSON.parse(message);
        console.log(`received event as host: ${parsedMsg}`);
        await handleReceivedMessages(parsedMsg, eventHandlers);
      });
      ws.on("error", (message) => {
        reject(message);
      });
      resolve(ws);
    });
    return {};
  });

// Function to handle messages received from clients
async function handleReceivedMessages(msg, eventHandlers) {
  if (msg.event && eventHandlers[msg.event]) {
    await eventHandlers[msg.event](msg.data);
  } else {
    console.log("Unknown event received in client:", msg.event);
  }
}

module.exports = { connectToHost, createHost };
