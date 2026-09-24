const express = require('express');
const router = express.Router();

const { registro, login, recuperarPassword, perfil } = require('../controllers/auth.controller');
const verificarToken = require('../middlewares/auth.middleware');

router.post('/register', registro);
router.post('/login', login);
router.post('/forgot-password', recuperarPassword);
router.get('/perfil', verificarToken, perfil);

module.exports = router;