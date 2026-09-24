import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../features/agenda/domain/entities/tarea.dart';
import 'api_config.dart';

class TareaService {
  static const String baseUrl = '${ApiConfig.host}/api/tareas';

  static Map<String, String> _headers(String token) => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

  static Future<Map<String, dynamic>> listarTareas({
    required String token,
    String? estado,
  }) async {
    try {
      final uri = estado == null
          ? Uri.parse(baseUrl)
          : Uri.parse(baseUrl).replace(queryParameters: {'estado': estado});

      final response = await http.get(uri, headers: _headers(token));

      if (response.statusCode == 200) {
        final listaJson = jsonDecode(response.body) as List<dynamic>;
        final tareas = listaJson
            .map((json) => Tarea.fromJson(json as Map<String, dynamic>))
            .toList();
        return {'exito': true, 'tareas': tareas};
      }

      final datos = jsonDecode(response.body) as Map<String, dynamic>;
      return {
        'exito': false,
        'mensaje': datos['mensaje'] ?? 'No se pudieron cargar las tareas',
      };
    } catch (e) {
      return {
        'exito': false,
        'mensaje': 'No se pudo conectar con el servidor. Revisa que esté encendido.',
      };
    }
  }

  static Future<Map<String, dynamic>> crearTarea({
    required String token,
    required Tarea tarea,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: _headers(token),
        body: jsonEncode(tarea.toJson()),
      );

      final datos = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 201) {
        return {'exito': true, 'tarea': Tarea.fromJson(datos)};
      }
      return {
        'exito': false,
        'mensaje': datos['mensaje'] ?? 'No se pudo crear la tarea',
      };
    } catch (e) {
      return {
        'exito': false,
        'mensaje': 'No se pudo conectar con el servidor. Revisa que esté encendido.',
      };
    }
  }

  static Future<Map<String, dynamic>> actualizarTarea({
    required String token,
    required String id,
    required Tarea tarea,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: _headers(token),
        body: jsonEncode(tarea.toJson()),
      );

      final datos = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        return {'exito': true, 'tarea': Tarea.fromJson(datos)};
      }
      return {
        'exito': false,
        'mensaje': datos['mensaje'] ?? 'No se pudo actualizar la tarea',
      };
    } catch (e) {
      return {
        'exito': false,
        'mensaje': 'No se pudo conectar con el servidor. Revisa que esté encendido.',
      };
    }
  }

  static Future<Map<String, dynamic>> eliminarTarea({
    required String token,
    required String id,
  }) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'), headers: _headers(token));

      if (response.statusCode == 200) {
        return {'exito': true};
      }

      final datos = jsonDecode(response.body) as Map<String, dynamic>;
      return {
        'exito': false,
        'mensaje': datos['mensaje'] ?? 'No se pudo eliminar la tarea',
      };
    } catch (e) {
      return {
        'exito': false,
        'mensaje': 'No se pudo conectar con el servidor. Revisa que esté encendido.',
      };
    }
  }
}