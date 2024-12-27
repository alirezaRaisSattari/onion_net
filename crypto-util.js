const crypto = require("crypto");

// Encrypt data with AES
function encryptDataWithAES(data, aesKey) {
  const iv = crypto.randomBytes(16);
  const cipher = crypto.createCipheriv(
    "aes-256-cbc",
    Buffer.from(aesKey, "hex"),
    iv
  );
  let encrypted = cipher.update(data, "utf8", "hex");
  encrypted += cipher.final("hex");
  return iv.toString("hex") + ":" + encrypted;
}

// Decrypt data with AES
function decryptDataWithAES(encryptedData, aesKey) {
  const parts = encryptedData.split(":");
  const iv = Buffer.from(parts.shift(), "hex");
  const encryptedText = parts.join(":");
  const decipher = crypto.createDecipheriv(
    "aes-256-cbc",
    Buffer.from(aesKey, "hex"),
    iv
  );
  let decrypted = decipher.update(encryptedText, "hex", "utf8");
  decrypted += decipher.final("utf8");
  return decrypted;
}

module.exports = { encryptDataWithAES, decryptDataWithAES };
