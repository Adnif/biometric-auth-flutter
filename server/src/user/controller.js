const pool = require('../../db');


const getUsers = (req, res) => {
    pool.query("SELECT * FROM users", (error, results) => {
        if(error) throw error;
        res.status(200).json(results.rows);
    })
};

const login = (req, res) => {
    const email = req.body.email;
    const password = req.body.password;
    
    const sql = `SELECT * FROM users WHERE email = '${email}' AND password = '${password}'`;
    pool.query(sql, (error, results) => {
        if(error) throw error;
        res.status(200).json(results.rows);
    });
}

module.exports = {
    getUsers,
    login,
};