const WebSocket = require("ws");

const createServer = (server) => {
  // Create a WebSocket server
  const wss = new WebSocket.Server({ server });

  wss.on("connection", (ws) => {
    console.log("WebSocket client connected");
    ws.on("message", (message) => {
      console.log(`Received: ${message}`);
      ws.send(`Echo: ${message}`);
    });
    ws.on("close", () => {
      console.log("WebSocket client disconnected");
    });
  });
};

const connectToServer = (address) => {
  const ws = new WebSocket(`ws://${address}`);

  ws.on("open", () => {
    console.log("Connected to WebSocket server");
    ws.send("Hello Server");
  });

  ws.on("message", (message) => {
    console.log(`Received: ${message}`);
  });

  ws.on("close", () => {
    console.log("Disconnected from WebSocket server");
  });

  ws.on("error", (error) => {
    console.error("WebSocket error:", error);
  });
};
