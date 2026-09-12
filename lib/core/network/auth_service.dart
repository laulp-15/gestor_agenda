import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  // OJO con esta URL, depende de dónde estés probando:
  // - Emulador Android           -> http://10.0.2.2:3000/api/auth
  // - Chrome / Windows / iOS sim -> http://localhost:3000/api/auth
  // - Celular físico             -> http://TU_IP_LOCAL:3000/api/auth (ej: http://192.168.1.5:3000/api/auth)
  static const String baseUrl = 'http://localhost:3000/api/auth';

  static Future<Map<String, dynamic>> login({
    required String correo,
    required String contrasena,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'correo': correo, 'contrasena': contrasena}),
      );

      final datos = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        return {'exito': true, ...datos};
      }
      return {
        'exito': false,
        'mensaje': datos['mensaje'] ?? 'No se pudo iniciar sesión',
      };
    } catch (e) {
      return {
        'exito': false,
        'mensaje': 'No se pudo conectar con el servidor. Revisa que esté encendido.',
      };
    }
  }

  static Future<Map<String, dynamic>> register({
    required String nombres,
    required String apellidos,
    required String correo,
    required String contrasena,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nombres': nombres,
          'apellidos': apellidos,
          'correo': correo,
          'contrasena': contrasena,
        }),
      );

      final datos = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 201) {
        return {'exito': true, ...datos};
      }
      return {
        'exito': false,
        'mensaje': datos['mensaje'] ?? 'No se pudo crear la cuenta',
      };
    } catch (e) {
      return {
        'exito': false,
        'mensaje': 'No se pudo conectar con el servidor. Revisa que esté encendido.',
      };
    }
  }
}