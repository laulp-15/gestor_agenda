enum EstadoTarea { pendiente, enProgreso, completada }

extension EstadoTareaX on EstadoTarea {
  String get label {
    switch (this) {
      case EstadoTarea.pendiente:
        return 'Pendiente';
      case EstadoTarea.enProgreso:
        return 'En progreso';
      case EstadoTarea.completada:
        return 'Completada';
    }
  }

  // Valor que espera el backend
  String get valorApi {
    switch (this) {
      case EstadoTarea.pendiente:
        return 'pendiente';
      case EstadoTarea.enProgreso:
        return 'en_progreso';
      case EstadoTarea.completada:
        return 'completada';
    }
  }
}

EstadoTarea estadoDesdeApi(String valor) {
  switch (valor) {
    case 'en_progreso':
      return EstadoTarea.enProgreso;
    case 'completada':
      return EstadoTarea.completada;
    case 'pendiente':
    default:
      return EstadoTarea.pendiente;
  }
}

class Tarea {
  final String id;
  String titulo;
  String descripcion;
  DateTime fecha;
  EstadoTarea estado;

  Tarea({
    required this.id,
    required this.titulo,
    this.descripcion = '',
    required this.fecha,
    this.estado = EstadoTarea.pendiente,
  });

  factory Tarea.fromJson(Map<String, dynamic> json) {
    return Tarea(
      id: json['_id'] as String,
      titulo: json['titulo'] as String,
      descripcion: json['descripcion'] as String? ?? '',
      fecha: DateTime.parse(json['fecha'] as String),
      estado: estadoDesdeApi(json['estado'] as String? ?? 'pendiente'),
    );
  }

  // No incluye "id": el backend lo asigna al crear, y para
  // actualizar se envía aparte, en la URL.
  Map<String, dynamic> toJson() {
    return {
      'titulo': titulo,
      'descripcion': descripcion,
      'fecha': fecha.toIso8601String(),
      'estado': estado.valorApi,
    };
  }
}