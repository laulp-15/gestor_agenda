import 'package:flutter/material.dart';
import '../../domain/entities/tarea.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/widgets/app_button.dart';

class TaskFormPage extends StatefulWidget {
  final Tarea? tarea;
  const TaskFormPage({super.key, this.tarea});

  @override
  State<TaskFormPage> createState() => _TaskFormPageState();
}

class _TaskFormPageState extends State<TaskFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _tituloCtrl;
  late TextEditingController _descripcionCtrl;
  late DateTime _fecha;
  late EstadoTarea _estado;

  bool get _esEdicion => widget.tarea != null;

  @override
  void initState() {
    super.initState();
    _tituloCtrl = TextEditingController(text: widget.tarea?.titulo ?? '');
    _descripcionCtrl = TextEditingController(text: widget.tarea?.descripcion ?? '');
    _fecha = widget.tarea?.fecha ?? DateTime.now();
    _estado = widget.tarea?.estado ?? EstadoTarea.pendiente;
  }

  @override
  void dispose() {
    _tituloCtrl.dispose();
    _descripcionCtrl.dispose();
    super.dispose();
  }

  Future<void> _seleccionarFecha() async {
    final seleccionada = await showDatePicker(
      context: context,
      initialDate: _fecha,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: AppColors.purpleWine),
        ),
        child: child!,
      ),
    );
    if (seleccionada != null) setState(() => _fecha = seleccionada);
  }

  void _guardar() {
    if (!_formKey.currentState!.validate()) return;

    final nuevaTarea = Tarea(
      id: widget.tarea?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      titulo: _tituloCtrl.text.trim(),
      descripcion: _descripcionCtrl.text.trim(),
      fecha: _fecha,
      estado: _estado,
    );

    Navigator.pop(context, nuevaTarea);
  }

  String _formatFecha(DateTime f) =>
      '${f.day.toString().padLeft(2, '0')}/${f.month.toString().padLeft(2, '0')}/${f.year}';

  InputDecoration _decoracion(String label, {IconData? icon}) => InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon, color: AppColors.purpleWine) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color.fromARGB(255, 225, 222, 217)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.darkWine, width: 2),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(_esEdicion ? 'Editar tarea' : 'Nueva tarea'),
        backgroundColor: AppColors.darkWine,
        foregroundColor: AppColors.white,
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              controller: _tituloCtrl,
              decoration: _decoracion('Título', icon: Icons.title),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'El título es obligatorio' : null,
            ),
            const SizedBox(height: 18),
            TextFormField(
              controller: _descripcionCtrl,
              decoration: _decoracion('Descripción', icon: Icons.notes),
              maxLines: 3,
            ),
            const SizedBox(height: 18),
            InkWell(
              onTap: _seleccionarFecha,
              child: InputDecorator(
                decoration: _decoracion('Fecha', icon: Icons.calendar_today),
                child: Text(_formatFecha(_fecha), style: const TextStyle(color: AppColors.text)),
              ),
            ),
            const SizedBox(height: 18),
            DropdownButtonFormField<EstadoTarea>(
              initialValue: _estado,
              decoration: _decoracion('Estado', icon: Icons.flag_outlined),
              items: EstadoTarea.values
                  .map((e) => DropdownMenuItem(value: e, child: Text(e.label)))
                  .toList(),
              onChanged: (v) => setState(() => _estado = v!),
            ),
            const SizedBox(height: 28),
            AppButton(
              text: _esEdicion ? 'Guardar cambios' : 'Crear tarea',
              onPressed: _guardar,
            ),
          ],
        ),
      ),
    );
  }
}