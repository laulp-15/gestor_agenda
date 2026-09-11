import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/app_text_field.dart';
import '../widgets/app_button.dart';

class Register extends StatelessWidget {
  const Register({super.key});

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
                  'Crear cuenta',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkWine,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Completa tus datos para registrarte',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 30),

                // Nombres
                AppTextField(label: 'Nombres', icon: Icons.person_outline),

                const SizedBox(height: 18),

                // Apellidos
                AppTextField(label: 'Apellidos', icon: Icons.person_outline),

                const SizedBox(height: 18),

                // Correo
                AppTextField(
                  label: 'Correo',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 18),

                // Contraseña
                AppTextField(
                  label: 'Contraseña',
                  icon: Icons.lock_outline,
                  obscureText: true,
                ),

                const SizedBox(height: 18),

                // Confirmar contraseña
                AppTextField(
                  label: 'Confirmar contraseña',
                  icon: Icons.lock_outline,
                  obscureText: true,
                ),

                const SizedBox(height: 25),

                // Botón Registrarse
                AppButton(text: 'Registrarse', onPressed: () {}),

                const SizedBox(height: 20),

                // Volver al login
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '¿Ya tienes una cuenta?',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),

                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Inicia sesión',
                        style: TextStyle(
                          color: AppColors.darkWine,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
