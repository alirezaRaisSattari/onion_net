const io = require('socket.io-client');
const readline = require('readline');

// script to run the python code...
// Connect to the Python server
const socket = io('http://127.0.0.1:5000');

// Setup Node console input
const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

// Every time the user types a line in Node console, send it to Python
rl.on('line', (input) => {
  socket.emit('message_from_node', { data: input });
});

// Handle successful connection
socket.on('connect', () => {
  console.log('Connected to Flask-SocketIO server!');
  // Optionally send an initial message
  socket.emit('message_from_node', { data: 'Node is connected!' });
});

// Listen for messages from Python
socket.on('message_from_python', (message) => {
  console.log('Message from Python:', message.data);
});

// Handle disconnection
socket.on('disconnect', () => {
  console.log('Disconnected from Flask server');
});

socket.on('error', (error) => {
  console.error('Socket error:', error);
});
