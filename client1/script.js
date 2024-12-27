const messageLog = document.getElementById("messageLog");
const messageInput = document.getElementById("messageInput");
const sendButton = document.getElementById("sendButton");

const peerConnection = new RTCPeerConnection();
const dataChannel = peerConnection.createDataChannel("chat");
const signalingServer = new WebSocket("ws://localhost:3000");

// Event handler for receiving messages
dataChannel.onmessage = (event) => {
  messageLog.value += `Friend: ${event.data}\n`;
};

// Event handler for connection state change
peerConnection.oniceconnectionstatechange = () => {
  console.log(`ICE connection state: ${peerConnection.iceConnectionState}`);
};

// Event handler for sending messages
sendButton.onclick = () => {
  const message = messageInput.value;
  messageLog.value += `You: ${message}\n`;
  dataChannel.send(message);
  messageInput.value = "";
};

// Event handler for receiving signaling messages
signalingServer.onmessage = (message) => {
  const data = JSON.parse(message.data);

  if (data.sdp) {
    peerConnection.setRemoteDescription(new RTCSessionDescription(data.sdp));
    if (data.sdp.type === "offer") {
      peerConnection
        .createAnswer()
        .then((answer) => peerConnection.setLocalDescription(answer))
        .then(() => {
          signalingServer.send(
            JSON.stringify({ sdp: peerConnection.localDescription })
          );
        });
    }
  } else if (data.candidate) {
    peerConnection.addIceCandidate(new RTCIceCandidate(data.candidate));
  }
};

// Start peer connection and create offer
peerConnection.onicecandidate = (event) => {
  if (event.candidate) {
    signalingServer.send(JSON.stringify({ candidate: event.candidate }));
  }
};

peerConnection
  .createOffer()
  .then((offer) => peerConnection.setLocalDescription(offer))
  .then(() => {
    signalingServer.send(
      JSON.stringify({ sdp: peerConnection.localDescription })
    );
  });
