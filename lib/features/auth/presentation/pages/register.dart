import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/network/auth_service.dart';
import '../../../../core/utils/validators.dart';
import '../widgets/app_text_field.dart';
import '../widgets/app_button.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nombresController = TextEditingController();
  final TextEditingController apellidosController = TextEditingController();
  final TextEditingController correoController = TextEditingController();
  final TextEditingController contrasenaController = TextEditingController();
  final TextEditingController confirmarContrasenaController =
      TextEditingController();
  bool cargando = false;

  @override
  void dispose() {
    nombresController.dispose();
    apellidosController.dispose();
    correoController.dispose();
    contrasenaController.dispose();
    confirmarContrasenaController.dispose();
    super.dispose();
  }

  void _mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje)),
    );
  }

  Future<void> _registrar() async {
    // Si algún campo no pasa su validator (incluida la confirmación
    // de contraseña), aquí se detiene y se muestran los errores.
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final nombres = nombresController.text.trim();
    final apellidos = apellidosController.text.trim();
    final correo = correoController.text.trim();
    final contrasena = contrasenaController.text.trim();

    setState(() => cargando = true);

    final resultado = await AuthService.register(
      nombres: nombres,
      apellidos: apellidos,
      correo: correo,
      contrasena: contrasena,
    );

    if (!mounted) return;
    setState(() => cargando = false);

    if (resultado['exito'] == true) {
      _mostrarMensaje('Cuenta creada correctamente');
      Navigator.pop(context); // vuelve al login
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
                  AppTextField(
                    label: 'Nombres',
                    icon: Icons.person_outline,
                    controller: nombresController,
                    validator: (valor) =>
                        validarCampoObligatorio(valor, campo: 'campo'),
                  ),

                  const SizedBox(height: 18),

                  // Apellidos
                  AppTextField(
                    label: 'Apellidos',
                    icon: Icons.person_outline,
                    controller: apellidosController,
                    validator: (valor) =>
                        validarCampoObligatorio(valor, campo: 'campo'),
                  ),

                  const SizedBox(height: 18),

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
                    validator: validarContrasena,
                  ),

                  const SizedBox(height: 18),

                  // Confirmar contraseña
                  AppTextField(
                    label: 'Confirmar contraseña',
                    icon: Icons.lock_outline,
                    obscureText: true,
                    controller: confirmarContrasenaController,
                    validator: (valor) {
                      if (valor == null || valor.isEmpty) {
                        return 'Confirma tu contraseña';
                      }
                      if (valor != contrasenaController.text) {
                        return 'Las contraseñas no coinciden';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 25),

                  // Botón Registrarse
                  AppButton(
                    text: cargando ? 'Creando cuenta...' : 'Registrarse',
                    onPressed: cargando ? null : _registrar,
                  ),

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
      ),
    );
  }
}