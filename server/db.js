const Pool = require('pg').Pool;

const pool = new Pool({
    user: "postgres",
    host: "localhost",
    database: "biometric_auth",
    password: "admin",
    post: 5432,
});

module.exports = pool;