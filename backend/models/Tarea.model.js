const mongoose = require('mongoose');

const ESTADOS = ['pendiente', 'en_progreso', 'completada'];

const tareaSchema = new mongoose.Schema(
  {
    titulo: {
      type: String,
      required: [true, 'El título es obligatorio'],
      trim: true,
      maxlength: 100,
    },
    descripcion: {
      type: String,
      trim: true,
      default: '',
      maxlength: 500,
    },
    fecha: {
      type: Date,
      required: [true, 'La fecha es obligatoria'],
    },
    estado: {
      type: String,
      enum: ESTADOS,
      default: 'pendiente',
    },
    usuario: {
      // Referencia al usuario dueño de la tarea
      type: mongoose.Schema.Types.ObjectId,
      ref: 'usuario',
      required: true,
    },
  },
  { timestamps: true }
);

module.exports = mongoose.model('Tarea', tareaSchema);
module.exports.ESTADOS = ESTADOS;
