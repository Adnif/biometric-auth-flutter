const Pool = require('pg').Pool;

const pool = new Pool({
    user: "postgres",
    host: "localhost",
    database: "students",
    password: "test",
    post: 5432,
});

module.exports = pool;