from Crypto.Cipher import AES
from Crypto.Random import get_random_bytes


class Encryptor:
    def __init__(self, key):
        """
        Initialize the Encryptor with a given AES-256 key.
        Args:
            key (bytes): A 32-byte (256-bit) AES key.
        """
        self.key = key

    def encrypt(self, data):
        """
        Encrypt the given data using AES-256-CBC.
        Args:
            data (bytes): The raw bytes to encrypt (already encoded, e.g., UTF-8).
        Returns:
            str: A string in the format `iv_hex:encrypted_data_hex`.
        """
        iv = get_random_bytes(16)  # Generate a random 16-byte IV
        cipher = AES.new(self.key, AES.MODE_CBC, iv)
        padded_data = self._pad(data)  # Add PKCS#7 padding
        encrypted = cipher.encrypt(padded_data)
        # Format: IV in hex + ":" + encrypted data in hex
        return iv.hex() + ":" + encrypted.hex()

    @staticmethod
    def _pad(data, block_size=16):
        """
        Apply PKCS#7 padding to the data.
        Args:
            data (bytes): The raw bytes to pad.
            block_size (int): The block size of the cipher (default: 16 bytes).
        Returns:
            bytes: Padded data.
        """
        padding_length = block_size - (len(data) % block_size)
        return data + bytes([padding_length] * padding_length)


# # Example Usage
# if __name__ == "__main__":
#     # 32-byte AES key (256-bit)
#     aes_key = bytes.fromhex("2fc6893f58b434e353b0fd71ec9bb10d7dbf75aef6eb8c9f657eb08391ed1535")

#     # Create the Encryptor instance
#     encryptor = Encryptor(aes_key)

#     # Your UTF-8 encoding is handled externally
#     plaintext = "This is a test message".encode("utf-8")

#     # Encrypt the data
#     encrypted_data = encryptor.encrypt(plaintext)

#     # Print the result in the format expected by JavaScript
#     print("Encrypted Data:", encrypted_data)
