const { Router } = require('express');
const controller = require('./controller');
const middleware = require('./middleware');

const router = Router();

router.get('/', controller.getUsers);
router.post('/login', controller.login);
router.post('/signup', controller.signUp);
router.get('/device_id', middleware.authenticateToken ,controller.getDeviceId);

module.exports = router;
``