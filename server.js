// const express = require("express");
// const bodyParser = require("body-parser");
// const app = express();
// const port = 8000;

// // Use body-parser middleware to parse JSON bodies
// app.use(bodyParser.json());

// app.get("/", (req, res) => {
//   console.log("get / received: ", req.body);
//   res.send("Hello from server on port 8000!");
// });

// app.post("/", (req, res) => {
//   console.log("post / received: ", req.body);
//   res.send("Hello from server on port 8000!");
// });

// app.listen(port, () => {
//   console.log(`Server running on port ${port}`);
// });

const WebSocket = require("ws");

const server = new WebSocket.Server({ port: 8000 });

server.on("connection", (socket) => {
  console.log("Client connected");

  // Broadcast received messages to all connected clients
  socket.on("message", (message) => {
    console.log(`Received message: ${message}`);
    server.clients.forEach((client) => {
      if (client !== socket && client.readyState === WebSocket.OPEN) {
        client.send(message);
      }
    });
  });

  // Handle client disconnect
  socket.on("close", () => {
    console.log("Client disconnected");
  });
});

console.log("Signaling server running on ws://localhost:8000");
