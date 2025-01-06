const express = require("express");
const bodyParser = require("body-parser");
const app = express();
const port = 8000;

// Use body-parser middleware to parse JSON bodies
app.use(bodyParser.json());

const users = [];
app.get("/register", (req, res) => {
  const clientIp =
    req.headers["ip"] ||
    req.headers["x-forwarded-for"] ||
    req.connection.remoteAddress;
  res.send(JSON.stringify({ success: true }));
});

app.get("/roll-dice", (req, res) => {
  const diceNumber = Math.floor(Math.random() * 6);
  res.send(JSON.stringify({ diceNumber }));
});

app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});
