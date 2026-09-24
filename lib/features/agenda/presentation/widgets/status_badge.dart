import 'package:flutter/material.dart';
import '../../domain/entities/tarea.dart';
import '../../../../core/theme/app_colors.dart';

class StatusBadge extends StatelessWidget {
  final EstadoTarea estado;
  const StatusBadge({super.key, required this.estado});

  Color get _color {
    switch (estado) {
      case EstadoTarea.pendiente:
        return AppColors.warning;
      case EstadoTarea.enProgreso:
        return AppColors.purpleWine;
      case EstadoTarea.completada:
        return AppColors.success;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _color.withValues(alpha: 0.4)),
      ),
      child: Text(
        estado.label,
        style: TextStyle(color: _color, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}
