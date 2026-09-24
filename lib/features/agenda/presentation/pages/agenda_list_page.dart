import 'package:flutter/material.dart';
import '../../domain/entities/tarea.dart';
import '../widgets/task_card.dart';
import 'task_form_page.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/network/tarea_service.dart';
import '../../../../core/network/token_storage.dart';
import '../../../../core/routes/app_routers.dart';

class AgendaListPage extends StatefulWidget {
  const AgendaListPage({super.key});

  @override
  State<AgendaListPage> createState() => _AgendaListPageState();
}

class _AgendaListPageState extends State<AgendaListPage> {
  List<Tarea> _tareas = [];
  bool _cargando = true;
  String? _error;
  EstadoTarea? _filtroSeleccionado; // null = "Todas"

  @override
  void initState() {
    super.initState();
    _cargarTareas();
  }

  // Devuelve el token guardado, o manda al login si ya no hay sesión.
  Future<String?> _obtenerToken() async {
    final token = await TokenStorage.obtenerToken();
    if (token == null && mounted) {
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
    }
    return token;
  }

  Future<void> _cargarTareas() async {
    setState(() => _cargando = true);

    final token = await _obtenerToken();
    if (token == null) return;

    final resultado = await TareaService.listarTareas(
      token: token,
      estado: _filtroSeleccionado?.valorApi,
    );

    if (!mounted) return;

    if (resultado['exito'] == true) {
      setState(() {
        _tareas = resultado['tareas'] as List<Tarea>;
        _cargando = false;
        _error = null;
      });
    } else {
      setState(() {
        _error = resultado['mensaje'] as String? ?? 'No se pudieron cargar las tareas';
        _cargando = false;
      });
    }
  }

  void _cambiarFiltro(EstadoTarea? nuevoFiltro) {
    if (_filtroSeleccionado == nuevoFiltro) return;
    setState(() => _filtroSeleccionado = nuevoFiltro);
    _cargarTareas();
  }

  Future<void> _abrirFormulario({Tarea? tarea}) async {
    final resultado = await Navigator.push<Tarea>(
      context,
      MaterialPageRoute(builder: (_) => TaskFormPage(tarea: tarea)),
    );

    if (resultado == null) return;

    final token = await _obtenerToken();
    if (token == null) return;

    final Map<String, dynamic> respuesta;
    if (tarea == null) {
      respuesta = await TareaService.crearTarea(token: token, tarea: resultado);
    } else {
      respuesta = await TareaService.actualizarTarea(
        token: token,
        id: tarea.id,
        tarea: resultado,
      );
    }

    if (!mounted) return;

    if (respuesta['exito'] == true) {
      _cargarTareas(); // vuelve a pedir la lista completa ya actualizada
    } else {
      _mostrarMensaje(respuesta['mensaje'] as String?);
    }
  }

  Future<void> _eliminarTarea(String id) async {
    final token = await _obtenerToken();
    if (token == null) return;

    final respuesta = await TareaService.eliminarTarea(token: token, id: id);

    if (!mounted) return;

    if (respuesta['exito'] == true) {
      setState(() => _tareas.removeWhere((t) => t.id == id));
    } else {
      _mostrarMensaje(respuesta['mensaje'] as String?);
    }
  }

  void _mostrarMensaje(String? mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje ?? 'Ocurrió un error')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Mi Agenda'),
        backgroundColor: AppColors.darkWine,
        foregroundColor: AppColors.white,
        centerTitle: true,
      ),
      body: Column(
        children: [
          _FiltrosEstado(
            seleccionado: _filtroSeleccionado,
            onSeleccionar: _cambiarFiltro,
          ),
          Expanded(
            child: _cargando
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.purpleWine),
                  )
                : _error != null
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _error!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: AppColors.error),
                            ),
                            const SizedBox(height: 12),
                            TextButton(
                              onPressed: _cargarTareas,
                              child: const Text('Reintentar'),
                            ),
                          ],
                        ),
                      )
                    : _tareas.isEmpty
                        ? const Center(
                            child: Text(
                              'No tienes tareas registradas',
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: _cargarTareas,
                            child: ListView.builder(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              itemCount: _tareas.length,
                              itemBuilder: (context, index) {
                                final tarea = _tareas[index];
                                return TaskCard(
                                  tarea: tarea,
                                  onTap: () => _abrirFormulario(tarea: tarea),
                                  onDelete: () => _eliminarTarea(tarea.id),
                                );
                              },
                            ),
                          ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.purpleWine,
        foregroundColor: AppColors.white,
        onPressed: () => _abrirFormulario(),
        child: const Icon(Icons.add),
      ),
    );
  }
}

// Filtrar por estados
class _FiltrosEstado extends StatelessWidget {
  final EstadoTarea? seleccionado;
  final ValueChanged<EstadoTarea?> onSeleccionar;

  const _FiltrosEstado({
    required this.seleccionado,
    required this.onSeleccionar,
  });

  @override
  Widget build(BuildContext context) {
    final opciones = <String, EstadoTarea?>{
      'Todas': null,
      'Pendientes': EstadoTarea.pendiente,
      'En progreso': EstadoTarea.enProgreso,
      'Completadas': EstadoTarea.completada,
    };

    return SizedBox(
      height: 44,
      child: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: opciones.entries.map((entrada) {
              final activo = seleccionado == entrada.value;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(entrada.key),
                  selected: activo,
                  onSelected: (_) => onSeleccionar(entrada.value),
                  showCheckmark: false,
                  backgroundColor: AppColors.white,
                  selectedColor: AppColors.darkWine,
                  side: BorderSide(
                    color: activo ? AppColors.darkWine : AppColors.border,
                  ),
                  labelStyle: TextStyle(
                    color: activo ? AppColors.white : AppColors.text,
                    fontWeight: activo ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}