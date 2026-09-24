const Tarea = require('../models/Tarea.model');
const { ESTADOS } = require('../models/Tarea.model');

// POST /api/tareas
async function crearTarea(req, res) {
  try {
    const { titulo, descripcion, fecha, estado } = req.body;

    if (!titulo || !fecha) {
      return res.status(400).json({ mensaje: 'Título y fecha son obligatorios' });
    }

    if (estado && !ESTADOS.includes(estado)) {
      return res.status(400).json({ mensaje: `Estado inválido. Usa: ${ESTADOS.join(', ')}` });
    }

    const tarea = await Tarea.create({
      titulo,
      descripcion,
      fecha,
      estado,
      usuario: req.userId, // viene del middleware de auth
    });

    return res.status(201).json(tarea);
  } catch (error) {
    return res.status(500).json({ mensaje: 'Error al crear la tarea', error: error.message });
  }
}

// GET /api/tareas  (solo las del usuario autenticado, con filtro opcional ?estado=)
async function listarTareas(req, res) {
  try {
    const filtro = { usuario: req.userId };

    if (req.query.estado) {
      if (!ESTADOS.includes(req.query.estado)) {
        return res.status(400).json({ mensaje: `Estado inválido. Usa: ${ESTADOS.join(', ')}` });
      }
      filtro.estado = req.query.estado;
    }

    const tareas = await Tarea.find(filtro).sort({ fecha: 1 });
    return res.json(tareas);
  } catch (error) {
    return res.status(500).json({ mensaje: 'Error al listar las tareas', error: error.message });
  }
}

// GET /api/tareas/:id
async function obtenerTarea(req, res) {
  try {
    const tarea = await Tarea.findOne({ _id: req.params.id, usuario: req.userId });

    if (!tarea) {
      return res.status(404).json({ mensaje: 'Tarea no encontrada' });
    }

    return res.json(tarea);
  } catch (error) {
    return res.status(500).json({ mensaje: 'Error al obtener la tarea', error: error.message });
  }
}

// PUT /api/tareas/:id
async function actualizarTarea(req, res) {
  try {
    const { titulo, descripcion, fecha, estado } = req.body;

    if (estado && !ESTADOS.includes(estado)) {
      return res.status(400).json({ mensaje: `Estado inválido. Usa: ${ESTADOS.join(', ')}` });
    }

    const tarea = await Tarea.findOneAndUpdate(
      { _id: req.params.id, usuario: req.userId },
      { titulo, descripcion, fecha, estado },
      { new: true, runValidators: true, omitUndefined: true }
    );

    if (!tarea) {
      return res.status(404).json({ mensaje: 'Tarea no encontrada' });
    }

    return res.json(tarea);
  } catch (error) {
    return res.status(500).json({ mensaje: 'Error al actualizar la tarea', error: error.message });
  }
}

// DELETE /api/tareas/:id
async function eliminarTarea(req, res) {
  try {
    const tarea = await Tarea.findOneAndDelete({ _id: req.params.id, usuario: req.userId });

    if (!tarea) {
      return res.status(404).json({ mensaje: 'Tarea no encontrada' });
    }

    return res.json({ mensaje: 'Tarea eliminada correctamente' });
  } catch (error) {
    return res.status(500).json({ mensaje: 'Error al eliminar la tarea', error: error.message });
  }
}

module.exports = {
  crearTarea,
  listarTareas,
  obtenerTarea,
  actualizarTarea,
  eliminarTarea,
};
