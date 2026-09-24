import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/routes/app_routers.dart';
import '../../../../core/network/auth_service.dart';
import '../../../../core/network/token_storage.dart';
import '../../../auth/presentation/widgets/app_button.dart';

/// Pantalla de Perfil de Usuario (Aprendiz B), ya conectada
/// con GET /api/auth/perfil (Fase 3).
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool cargando = true;
  String nombre = '';
  String correo = '';
  String? error;

  @override
  void initState() {
    super.initState();
    _cargarPerfil();
  }

  Future<void> _cargarPerfil() async {
    final token = await TokenStorage.obtenerToken();

    if (token == null) {
      // No hay sesión guardada, regresa al login
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
      return;
    }

    final resultado = await AuthService.obtenerPerfil(token: token);

    if (!mounted) return;

    if (resultado['exito'] == true) {
      final usuario = resultado['usuario'] as Map<String, dynamic>;
      setState(() {
        nombre = '${usuario['nombres']} ${usuario['apellidos']}';
        correo = usuario['correo'] ?? '';
        cargando = false;
      });
    } else {
      setState(() {
        error = resultado['mensaje'] ?? 'No se pudo cargar el perfil';
        cargando = false;
      });
    }
  }

  Future<void> _cerrarSesion() async {
    await TokenStorage.borrarToken();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        backgroundColor: AppColors.darkWine,
        foregroundColor: AppColors.white,
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 420),
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: cargando
                ? const Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(color: AppColors.purpleWine),
                  )
                : error != null
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            error!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: AppColors.error),
                          ),
                          const SizedBox(height: 16),
                          AppButton(text: 'Reintentar', onPressed: _cargarPerfil),
                        ],
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CircleAvatar(
                            radius: 45,
                            backgroundColor: AppColors.lightGray,
                            child: Icon(Icons.person, size: 50, color: AppColors.purpleWine),
                          ),
                          const SizedBox(height: 18),
                          Text(
                            nombre,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.text,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            correo,
                            style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                          ),
                          const SizedBox(height: 28),
                          AppButton(text: 'Cerrar sesión', onPressed: _cerrarSesion),
                        ],
                      ),
          ),
        ),
      ),
    );
  }
}