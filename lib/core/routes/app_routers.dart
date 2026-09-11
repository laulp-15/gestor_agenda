import 'package:flutter/material.dart';
import '../../features/auth/presentation/pages/login.dart';
import '../../features/auth/presentation/pages/register.dart';
import '../../features/auth/presentation/pages/forgot_password.dart';

class AppRoutes {
  static const String login = '/';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';

  static Map<String, WidgetBuilder> routes = {
    login: (context) => const Login(),
    register: (context) => const Register(),
    forgotPassword: (context) => const ForgotPassword(),
  };
}