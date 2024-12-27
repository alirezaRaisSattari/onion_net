const express = require("express");
const app = express();
const port = 8000;

app.get("/", (req, res) => {
  console.log("body: ", req);
  console.log("body: ", req.body);
  res.send("Hello from server on port 8000!");
});

app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});
