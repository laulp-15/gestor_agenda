require("dotenv").config();
const mongoose = require("mongoose");
const app = require("../app");

// En serverless, la función puede reutilizarse entre peticiones (warm start),
// así que evitamos reconectar si ya hay una conexión abierta.
let conectado = false;

async function asegurarConexion() {
  if (conectado || mongoose.connection.readyState === 1) {
    conectado = true;
    return;
  }
  await mongoose.connect(process.env.MONGO_URI);
  conectado = true;
}

module.exports = async (req, res) => {
  try {
    await asegurarConexion();
  } catch (error) {
    console.error("Error conectando a MongoDB:", error.message);
    return res.status(500).json({ mensaje: "No se pudo conectar a la base de datos" });
  }

  return app(req, res);
};