const express = require('express');
const userRoutes = require("./src/user/routes");
const webSocket = require("./src/user/websocket");

const PORT = process.env.PORT | 3000;
const app = express();

const { Server } = require("socket.io");
const http = require('http');
const server = http.createServer(app);

const io = new Server(server);

app.use(express.json());

app.get("/", (req, res) => {
    res.send(`Nyambung ke ${PORT}`);
});

app.use("/api/v1/user", userRoutes);
  
server.listen(3000, () => {
    console.log(`listening on *:${PORT}`);
});

io.on('connection', (socket) => {
    console.log('a user connected');

    socket.on('data', (data) => {
        const query = `SELECT * FROM users WHERE username = 'bani'`;
        pool.query(query, (error, result) => {
            if (error) {
                console.error('Error executing query', error);
                return;
            }
            console.log('Result:', results.rows[0]["device_id"]);
            // Emit data to the connected client
            socket.emit('data', result.rows);
        });
        console.log('masuk kensini');
    })
});