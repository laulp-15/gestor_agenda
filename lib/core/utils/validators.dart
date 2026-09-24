// Validadores reutilizables para los formularios de autenticación.

final RegExp _correoRegex = RegExp(r'^[\w.\-]+@([\w\-]+\.)+[a-zA-Z]{2,}$');

String? validarCorreo(String? valor) {
  final texto = valor?.trim() ?? '';

  if (texto.isEmpty) {
    return 'Ingresa tu correo';
  }

  if (!_correoRegex.hasMatch(texto)) {
    return 'Ingresa un correo válido (ej: nombre@dominio.com)';
  }

  return null;
}

String? validarCampoObligatorio(String? valor, {String campo = 'campo'}) {
  if (valor == null || valor.trim().isEmpty) {
    return 'Este $campo es obligatorio';
  }
  return null;
}

String? validarContrasena(String? valor) {
  final texto = valor ?? '';
  if (texto.isEmpty) {
    return 'Ingresa tu contraseña';
  }
  if (texto.length < 6) {
    return 'Debe tener al menos 6 caracteres';
  }
  return null;
}