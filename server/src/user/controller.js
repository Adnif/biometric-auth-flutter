const pool = require('../../db');
const jwt = require('jsonwebtoken');
require('dotenv').config();

const getUsers = (req, res) => {
    pool.query("SELECT * FROM users", (error, results) => {
        if(error) throw error;
        res.status(200).json(results.rows);
    })
};

const login = (req, res) => {
    const email = req.body.email;
    const password = req.body.password;
    const curr_device_id = req.body.device_id;
    
    const sql = `SELECT * FROM users WHERE email = '${email}' AND password = '${password}'`;
    pool.query(sql, (error, results) => {
        if(error) throw error;

        if(results.rows.length === 0){
            res.status(409).send('Wrong Credentials');
            return;
        } else {
            const username = results.rows[0]['username'];
            const device_id = results.rows[0]['device_id'];

            if(curr_device_id !== device_id){
                const updateSql = `UPDATE users SET device_id = '${curr_device_id}' WHERE email = '${email}'`;
                pool.query(updateSql, (updateError, updateResults) => {
                    if (updateError) throw updateError;
                    console.log(`Device ID updated for user: ${username}`);
                });
            }

            const user = { name: username, device_id: curr_device_id}
            const accessToken = jwt.sign(user, process.env.ACCESS_TOKEN_SECRET)
            res.status(200).json({ 'access-token': accessToken})
        }
    });
}

const signUp = async (req, res) => {
    const username = req.body.username;
    const email = req.body.email;
    const password = req.body.password;
    const device_id = req.body.device_id;

    const emailQuery = `SELECT * FROM users WHERE username = '${username}' OR email = '${email}'`;

    try {
        const results = await pool.query(emailQuery);
        const isUserExists = results.rows.length > 0;

        if (isUserExists) {
            res.status(409).send('Username or email already exists.');
        } else {
            const signUpQuery = `INSERT INTO users (username, password, email, device_id) VALUES ('${username}', '${password}', '${email}', '${device_id}')`;
            
            await pool.query(signUpQuery);
            res.status(201).send('User created successfully.');
        }
    } catch (error) {
        throw error;
    }
}

const getDeviceId = async (req,res) => {
    const username = req.user.name;
    console.log(username);
    const sql = `SELECT device_id FROM users WHERE username = '${username}'`;
    pool.query(sql, (error, results) => {
        if(error) throw error;
        res.json(results.rows[0]["device_id"])
    })
}

module.exports = {
    getUsers,
    login,
    signUp,
    getDeviceId,
};