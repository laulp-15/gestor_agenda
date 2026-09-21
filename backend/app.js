const express = require('express');
const cors = require('cors');

const authRoutes = require('./routes/auth.routes');
const tareaRoutes = require('./routes/tarea.routes');

const app = express();

app.use(cors());
app.use(express.json());

app.get('/', (req, res) => {
  res.json({ mensaje: 'API Gestor de Agenda funcionando 🚀' });
});

app.use('/api/auth', authRoutes);   // Aprendiz A
app.use('/api/tareas', tareaRoutes); // Aprendiz B

// 404
app.use((req, res) => {
  res.status(404).json({ mensaje: 'Ruta no encontrada' });
});

module.exports = app;