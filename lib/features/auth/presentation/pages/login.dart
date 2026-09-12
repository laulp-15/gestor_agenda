import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/routes/app_routers.dart';
import '../../../../core/network/auth_service.dart';
import '../../../../core/utils/validators.dart';
import '../widgets/app_text_field.dart';
import '../widgets/app_button.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController correoController = TextEditingController();
  final TextEditingController contrasenaController = TextEditingController();
  bool cargando = false;

  @override
  void dispose() {
    correoController.dispose();
    contrasenaController.dispose();
    super.dispose();
  }

  void _mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(mensaje)));
  }

  Future<void> _iniciarSesion() async {
    // Si algún campo no pasa su validator, aquí se detiene
    // y ya se muestran los errores en rojo debajo de cada campo.
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final correo = correoController.text.trim();
    final contrasena = contrasenaController.text.trim();

    setState(() => cargando = true);

    final resultado = await AuthService.login(
      correo: correo,
      contrasena: contrasena,
    );

    if (!mounted) return;
    setState(() => cargando = false);

    if (resultado['exito'] == true) {
      // Aquí es donde, más adelante, guardarán resultado['token']
      // (por ejemplo con shared_preferences) y navegarán a la agenda.
      _mostrarMensaje('Inicio de sesión exitoso');
    } else {
      _mostrarMensaje(resultado['mensaje']);
    }
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

            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Título
                  const Text(
                    'Iniciar sesión',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkWine,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Ingresa tus datos para continuar',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Correo
                  AppTextField(
                    label: 'Correo',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    controller: correoController,
                    validator: validarCorreo,
                  ),

                  const SizedBox(height: 18),

                  // Contraseña
                  AppTextField(
                    label: 'Contraseña',
                    icon: Icons.lock_outline,
                    obscureText: true,
                    controller: contrasenaController,
                    validator: (valor) =>
                        validarCampoObligatorio(valor, campo: 'campo'),
                  ),

                  const SizedBox(height: 10),

                  // Recuperar contraseña
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.forgotPassword);
                    },
                    child: const Text(
                      '¿Olvidaste tu contraseña?',
                      style: TextStyle(color: AppColors.darkWine),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Botón iniciar sesión
                  AppButton(
                    text: cargando ? 'Ingresando...' : 'Iniciar sesión',
                    onPressed: cargando ? null : _iniciarSesion,
                  ),

                  const SizedBox(height: 20),

                  // Registro
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        '¿No tienes una cuenta?',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),

                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.register);
                        },
                        child: const Text(
                          'Regístrate',
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
      ),
    );
  }
}
