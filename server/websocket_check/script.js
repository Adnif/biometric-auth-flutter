const socket = io('http://localhost:3000');

// Listen for the 'welcome' event from the server
socket.on('welcome', (message) => {
  console.log(message);
});

// Listen for the 'echo' event from the server
socket.on('echo', (message) => {
  const messages = document.querySelector('#messages');

  const li = document.createElement('li');
  li.textContent = message;

  messages.appendChild(li);
});

// Send a message to the server
document.querySelector('#send').addEventListener('click', () => {
  const message = document.querySelector('#message').value;

  socket.emit('message', message);

  document.querySelector('#message').value = '';
});
