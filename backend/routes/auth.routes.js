const express = require("express");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const Usuario = require("../models/usuario");

const router = express.Router();

/**
 * POST /api/auth/register
 */
router.post("/register", async (req, res) => {
  try {
    const { nombres, apellidos, correo, contrasena } = req.body;

    // Validación básica
    if (!nombres || !apellidos || !correo || !contrasena) {
      return res.status(400).json({ mensaje: "Todos los campos son obligatorios" });
    }

    if (contrasena.length < 6) {
      return res.status(400).json({ mensaje: "La contraseña debe tener al menos 6 caracteres" });
    }

    // Verificar si el correo ya está registrado
    const usuarioExistente = await Usuario.findOne({ correo: correo.toLowerCase() });
    if (usuarioExistente) {
      return res.status(409).json({ mensaje: "Ya existe una cuenta con ese correo" });
    }

    // Encriptar contraseña
    const salt = await bcrypt.genSalt(10);
    const contrasenaHasheada = await bcrypt.hash(contrasena, salt);

    // Crear usuario
    const nuevoUsuario = await Usuario.create({
      nombres,
      apellidos,
      correo,
      contrasena: contrasenaHasheada,
    });

    // Generar token
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
    console.error("Error en /register:", error);
    return res.status(500).json({ mensaje: "Error en el servidor" });
  }
});

/**
 * POST /api/auth/login
 */
router.post("/login", async (req, res) => {
  try {
    const { correo, contrasena } = req.body;

    if (!correo || !contrasena) {
      return res.status(400).json({ mensaje: "Correo y contraseña son obligatorios" });
    }

    // select("+contrasena") porque en el modelo el campo tiene select: false
    const usuario = await Usuario.findOne({ correo: correo.toLowerCase() }).select("+contrasena");
    if (!usuario) {
      return res.status(401).json({ mensaje: "Credenciales inválidas" });
    }

    const contrasenaValida = await bcrypt.compare(contrasena, usuario.contrasena);
    if (!contrasenaValida) {
      return res.status(401).json({ mensaje: "Credenciales inválidas" });
    }

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
    console.error("Error en /login:", error);
    return res.status(500).json({ mensaje: "Error en el servidor" });
  }
});

function generarToken(idUsuario) {
  return jwt.sign({ id: idUsuario }, process.env.JWT_SECRET, {
    expiresIn: "7d",
  });
}

module.exports = router;