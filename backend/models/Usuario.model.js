const mongoose = require("mongoose");

const usuarioSchema = new mongoose.Schema(
  {
    nombres: {
      type: String,
      required: [true, "Los nombres son obligatorios"],
      trim: true,
    },
    apellidos: {
      type: String,
      required: [true, "Los apellidos son obligatorios"],
      trim: true,
    },
    correo: {
      type: String,
      required: [true, "El correo es obligatorio"],
      unique: true,
      trim: true,
      lowercase: true,
    },
    contrasena: {
      type: String,
      required: [true, "La contraseña es obligatoria"],
      select: false, // nunca se devuelve por defecto en las consultas
    },
    // Usados por recuperarPassword en auth.controller.js
    tokenRecuperacion: {
      type: String,
      select: false,
    },
    tokenRecuperacionExpira: {
      type: Date,
      select: false,
    },
  },
  {
    timestamps: true, // createdAt / updatedAt
  }
);

module.exports = mongoose.model("Usuario", usuarioSchema);