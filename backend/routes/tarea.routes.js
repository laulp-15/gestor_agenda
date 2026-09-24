const express = require('express');
const router = express.Router();

const verificarToken = require('../middlewares/auth.middleware');
const {
  crearTarea,
  listarTareas,
  obtenerTarea,
  actualizarTarea,
  eliminarTarea,
} = require('../controllers/tarea.controller');

// Todas las rutas de agenda requieren estar autenticado
router.use(verificarToken);

router.post('/', crearTarea);
router.get('/', listarTareas);
router.get('/:id', obtenerTarea);
router.put('/:id', actualizarTarea);
router.delete('/:id', eliminarTarea);

module.exports = router;
