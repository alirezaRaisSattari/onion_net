const fs = require("fs");
function fileWatcher(sourceFile, targetFile, rollDiceCB, sendCB) {
  // Ensure both files exist
  const ensureFileExists = (filePath) => {
    if (!fs.existsSync(filePath)) {
      fs.writeFileSync(filePath, ""); // Create an empty file
      console.log(`${filePath} created.`);
    }
  };

  ensureFileExists(sourceFile);
  ensureFileExists(targetFile);

  // Monitor the source file for changes every second
  fs.watchFile(sourceFile, { interval: 1 }, (curr, prev) => {
    console.log(`${sourceFile} has changed.`);
    if (curr.mtime !== prev.mtime) {
      console.log(`${sourceFile} has changed.`);

      // Read the updated content of the source file
      fs.readFile(sourceFile, "utf-8", async (err, data) => {
        if (err) {
          console.error("Error reading file:", err);
          return;
        }
        if (data.length == 0) return;

        const justifiedData = `${data} dice:${await rollDiceCB()}`;
        // Copy the content to the target file
        fs.writeFile(targetFile, justifiedData, (err) => {
          if (err) {
            console.error("Error writing to target file:", err);
            return;
          }
          console.log(`Content copied to ${targetFile}.`);

          if (sourceFile == "../writeSharedMemory1")
            sendCB.send(JSON.stringify({ event: "xxx", data: justifiedData }));
          else sendCB(JSON.stringify({ event: "xxx", data: justifiedData }));
          // Wipe the source file content
          fs.writeFile(sourceFile, "", (err) => {
            if (err) {
              console.error("Error wiping the source file:", err);
            } else {
              console.log(`${sourceFile} has been wiped.`);
            }
          });
        });
      });
    }
  });
}
module.exports = fileWatcher;
