// const { Server } = require("socket.io");
// const pool = require('../../db');

// function webSocket(server) {
//     const io = new Server(server);

//     io.on('connection', (socket) => {
//         console.log('a user connected');

//         socket.on('data', (data) => {
//             const query = `SELECT * FROM users WHERE username = 'bani'`;
//             pool.query(query, (error, result) => {
//                 if (error) {
//                     console.error('Error executing query', error);
//                     return;
//                 }
//                 console.log('Result:', results.rows[0]["device_id"]);
//                 // Emit data to the connected client
//                 socket.emit('data', result.rows);
//             });
//             console.log('masuk kensini');
//         })
//     });

//     return io;
// }

// module.exports = webSocket;


