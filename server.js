const http = require("http");

const server = http.createServer((req, res) => {
  console.log("Received request for:", req.url);

  let body = [];
  req
    .on("data", (chunk) => {
      console.log("xxxxxxxxxxxx");
      body.push(chunk);
    })
    .on("end", () => {
      body = Buffer.concat(body).toString();
      console.log("Request body:", body);

      // Responding to the client
      res.writeHead(200, { "Content-Type": "text/plain" });
      res.end("Request received and decrypted by server");
    });
});

const PORT = 8000;
server.listen(PORT, () => {
  console.log(`Server listening on port ${PORT}`);
});
