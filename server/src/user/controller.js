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

        if(results.rows.length === 0){
            res.status(409).send('Wrong Credentials');
            return;
        }

        //res.status(200).json(results.rows);
        res.status(200).json(results.rows[0]);
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


module.exports = {
    getUsers,
    login,
    signUp
};