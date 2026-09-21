const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const crypto = require("crypto");
const Usuario = require("../models/Usuario.model");

async function registro(req, res) {
  try {
    const { nombres, apellidos, correo, contrasena } = req.body;

    if (!nombres || !apellidos || !correo || !contrasena) {
      return res.status(400).json({ mensaje: "Todos los campos son obligatorios" });
    }

    if (contrasena.length < 6) {
      return res.status(400).json({ mensaje: "La contraseña debe tener al menos 6 caracteres" });
    }

    const usuarioExistente = await Usuario.findOne({ correo: correo.toLowerCase() });
    if (usuarioExistente) {
      return res.status(409).json({ mensaje: "Ya existe una cuenta con ese correo" });
    }

    const salt = await bcrypt.genSalt(10);
    const contrasenaHasheada = await bcrypt.hash(contrasena, salt);

    const nuevoUsuario = await Usuario.create({
      nombres,
      apellidos,
      correo,
      contrasena: contrasenaHasheada,
    });

    const token = generarToken(nuevoUsuario._id);

    return res.status(201).json({
      mensaje: "Usuario registrado correctamente",
      token,
      usuario: {
        id: nuevoUsuario._id,
        nombres: nuevoUsuario.nombres,
        apellidos: nuevoUsuario.apellidos,
        correo: nuevoUsuario.correo,
      },
    });
  } catch (error) {
    console.error("Error en registro:", error);
    return res.status(500).json({ mensaje: "Error en el servidor" });
  }
}

async function login(req, res) {
  try {
    const { correo, contrasena } = req.body;

    if (!correo || !contrasena) {
      return res.status(400).json({ mensaje: "Correo y contraseña son obligatorios" });
    }

    const usuario = await Usuario.findOne({ correo: correo.toLowerCase() }).select("+contrasena");
    if (!usuario) {
      return res.status(401).json({ mensaje: "Credenciales inválidas" });
    }

    const contrasenaValida = await bcrypt.compare(contrasena, usuario.contrasena);
    if (!contrasenaValida) {
      return res.status(401).json({ mensaje: "Credenciales inválidas" });
    }

    // payload usa "id" a propósito: es lo que espera
    // middlewares/auth.middleware.js al leer payload.id
    const token = generarToken(usuario._id);

    return res.status(200).json({
      mensaje: "Inicio de sesión exitoso",
      token,
      usuario: {
        id: usuario._id,
        nombres: usuario.nombres,
        apellidos: usuario.apellidos,
        correo: usuario.correo,
      },
    });
  } catch (error) {
    console.error("Error en login:", error);
    return res.status(500).json({ mensaje: "Error en el servidor" });
  }
}

// Versión mínima: genera un token de recuperación y lo guarda con expiración.
// Por ahora NO envía correo (eso requiere un servicio como Nodemailer + SMTP).
// Mientras no tengan ese servicio conectado, el token se devuelve en la
// respuesta solo para poder probar el flujo manualmente.
async function recuperarPassword(req, res) {
  try {
    const { correo } = req.body;

    if (!correo) {
      return res.status(400).json({ mensaje: "El correo es obligatorio" });
    }

    const usuario = await Usuario.findOne({ correo: correo.toLowerCase() });
    if (!usuario) {
      return res.status(200).json({
        mensaje: "Si el correo existe, se enviarán instrucciones de recuperación",
      });
    }

    const tokenRecuperacion = crypto.randomBytes(32).toString("hex");
    usuario.tokenRecuperacion = tokenRecuperacion;
    usuario.tokenRecuperacionExpira = Date.now() + 1000 * 60 * 30; // 30 minutos
    await usuario.save();

    // TODO: aquí iría el envío real del correo con el enlace de recuperación

    return res.status(200).json({
      mensaje: "Si el correo existe, se enviarán instrucciones de recuperación",
      tokenRecuperacion, // quitar esto cuando se conecte el envío real de correos
    });
  } catch (error) {
    console.error("Error en recuperarPassword:", error);
    return res.status(500).json({ mensaje: "Error en el servidor" });
  }
}

async function perfil(req, res) {
  try {
    // req.userId viene del middleware verificarToken
    const usuario = await Usuario.findById(req.userId);

    if (!usuario) {
      return res.status(404).json({ mensaje: "Usuario no encontrado" });
    }

    return res.status(200).json({
      usuario: {
        id: usuario._id,
        nombres: usuario.nombres,
        apellidos: usuario.apellidos,
        correo: usuario.correo,
      },
    });
  } catch (error) {
    console.error("Error en perfil:", error);
    return res.status(500).json({ mensaje: "Error en el servidor" });
  }
}

function generarToken(idUsuario) {
  return jwt.sign({ id: idUsuario }, process.env.JWT_SECRET, {
    expiresIn: "7d",
  });
}

module.exports = { registro, login, recuperarPassword, perfil };