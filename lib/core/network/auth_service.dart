import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class AuthService {
  static const String baseUrl = '${ApiConfig.host}/api/auth';

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

  static Future<Map<String, dynamic>> recuperarPassword({
    required String correo,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/forgot-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'correo': correo}),
      );

      final datos = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        return {'exito': true, ...datos};
      }
      return {
        'exito': false,
        'mensaje': datos['mensaje'] ?? 'No se pudo procesar la solicitud',
      };
    } catch (e) {
      return {
        'exito': false,
        'mensaje': 'No se pudo conectar con el servidor. Revisa que esté encendido.',
      };
    }
  }

  static Future<Map<String, dynamic>> obtenerPerfil({
    required String token,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/perfil'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final datos = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        return {'exito': true, ...datos};
      }
      return {
        'exito': false,
        'mensaje': datos['mensaje'] ?? 'No se pudo obtener el perfil',
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