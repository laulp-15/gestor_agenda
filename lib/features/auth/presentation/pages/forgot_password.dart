import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/network/auth_service.dart';
import '../widgets/app_text_field.dart';
import '../widgets/app_button.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController correoController = TextEditingController();
  bool cargando = false;

  @override
  void dispose() {
    correoController.dispose();
    super.dispose();
  }

  void _mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje)),
    );
  }

  Future<void> _enviarEnlace() async {
    final correo = correoController.text.trim();

    if (correo.isEmpty) {
      _mostrarMensaje('Ingresa tu correo');
      return;
    }

    setState(() => cargando = true);

    final resultado = await AuthService.recuperarPassword(correo: correo);

    if (!mounted) return;
    setState(() => cargando = false);

    _mostrarMensaje(
      resultado['mensaje'] ?? 'Si el correo existe, se enviarán instrucciones',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

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

            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Título
                const Text(
                  'Recuperar contraseña',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkWine,
                  ),
                ),

                const SizedBox(height: 10),

                // Descripción
                const Text(
                  'Ingresa tu correo electrónico y te enviaremos '
                  'un enlace para recuperar tu contraseña.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 30),

                // Correo
                AppTextField(
                  label: 'Correo',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  controller: correoController,
                ),

                const SizedBox(height: 25),

                // Botón recuperar contraseña
                AppButton(
                  text: cargando ? 'Enviando...' : 'Enviar enlace',
                  onPressed: cargando ? null : _enviarEnlace,
                ),

                const SizedBox(height: 20),

                // Volver al login
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Volver a iniciar sesión',
                    style: TextStyle(
                      color: AppColors.darkWine,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}