const jwt = require("jsonwebtoken");

// Middleware para proteger rutas que requieren estar autenticado.
// Se usa así: router.get("/perfil", verificarToken, controlador)
function verificarToken(req, res, next) {
  const authHeader = req.headers.authorization; // formato: "Bearer <token>"

  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    return res.status(401).json({ mensaje: "No se proporcionó token de autenticación" });
  }

  const token = authHeader.split(" ")[1];

  try {
    const payload = jwt.verify(token, process.env.JWT_SECRET);
    req.usuarioId = payload.id;
    next();
  } catch (error) {
    return res.status(401).json({ mensaje: "Token inválido o expirado" });
  }
}

module.exports = verificarToken;