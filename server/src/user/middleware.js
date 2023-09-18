require('dotenv').config();
const jwt = require('jsonwebtoken');


function authenticateToken(req, res, next) {
    const token = req.headers['authorization'].split(' ')[1];
    
    if (token == null) return res.sendStatus(401)

    jwt.verify(token, process.env.ACCESS_TOKEN_SECRET, (err, user) => {
        console.log(token);
        console.log(err);
        if (err) return res.sendStatus(403); // If token is invalid, return forbidden

        req.user = user; // Attach the decoded user information to the request object for future use
        next(); // Continue with the next middleware or route handler
    });
}

module.exports = {
    authenticateToken
}
