const express = require("express");
const bodyParser = require("body-parser");
const app = express();
const port = 8000;
const hosts = [];
// Use body-parser middleware to parse JSON bodies
app.use(bodyParser.json());

const users = [];
app.post("/host", (req, res) => {
  const newHost = { ip: req.body.ip, port: req.body.port };
  const exists = hosts.some(
    (host) => host.ip === newHost.ip && host.port === newHost.port
  );
  exists || hosts.push({ ...req.body });
  res.send(JSON.stringify({ success: true }));
});
app.get("/host", (req, res) => {
  res.send(JSON.stringify({ hosts }));
});

app.get("/roll-dice", (req, res) => {
  const diceNumber = Math.floor(Math.random() * 6);
  res.send(JSON.stringify({ diceNumber }));
});

app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});
