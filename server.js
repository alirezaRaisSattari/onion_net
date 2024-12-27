const express = require("express");
const bodyParser = require("body-parser");
const app = express();
const port = 8000;

// Use body-parser middleware to parse JSON bodies
app.use(bodyParser.json());

app.get("/", (req, res) => {
  console.log("get / received: ", req.body);
  res.send("Hello from server on port 8000!");
});

app.post("/", (req, res) => {
  console.log("post / received: ", req.body);
  res.send("Hello from server on port 8000!");
});

app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});
