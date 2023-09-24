const { Server } = require("socket.io");
const pool = require('../../db');

function webSocket(server) {
    const io = new Server(server);

    io.on('connection', (socket) => {
        console.log('a user connected');

        socket.on('data', (data) => {
            
            const query = `SELECT * FROM users WHERE username = '${data}'`;
            pool.query(query, (error, result) => {
                if (error) {
                    console.error(`$data`);
                    console.error('Error executing query', error);
                    socket.emit('data', error);
                } else if(result.rows[0]){
                    console.log('Result:', result.rows[0]["device_id"]);
                    // Emit data to the connected client
                    socket.emit('data', result.rows[0]["device_id"]);
                } else {
                    socket.emit('data', "gaada usernamenya");
                }
            });
            
        })
    });

    pool.on('notification', (msg) => {
        console.log('Received notification:', msg);
        io.emit('data', msg.payload);
    });

    // Start listening for notifications
    pool.query('LISTEN device_id_change')

    return io;
}

module.exports = webSocket;


