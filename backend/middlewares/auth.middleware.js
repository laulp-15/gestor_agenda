const jwt = require('jsonwebtoken');

/**
 * Middleware compartido: verifica el JWT que genera el módulo de Auth
 * en el login, y deja el id del usuario en req.userId
 * para que las rutas de Agenda sepan de quién es cada tarea.
 *
 * Espera el header:  Authorization: Bearer <token>
 */
function verificarToken(req, res, next) {
  const header = req.headers.authorization;

  if (!header || !header.startsWith('Bearer ')) {
    return res.status(401).json({ mensaje: 'Token no proporcionado' });
  }

  const token = header.split(' ')[1];

  try {
    const payload = jwt.verify(token, process.env.JWT_SECRET);
    // Convención: el payload del token debe incluir { id: usuario._id }
    req.userId = payload.id;
    next();
  } catch (error) {
    return res.status(401).json({ mensaje: 'Token inválido o expirado' });
  }
}

module.exports = verificarToken;