import 'package:flutter/material.dart';
import '../../features/auth/presentation/pages/login.dart';
import '../../features/auth/presentation/pages/register.dart';
import '../../features/auth/presentation/pages/forgot_password.dart';
import '../../features/auth/presentation/pages/profile_page.dart';
import '../widgets/main_navigation.dart';

class AppRoutes {
  static const String login = '/';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String agenda = '/agenda';
  static const String profile = '/profile';

  static Map<String, WidgetBuilder> routes = {
    login: (context) => const Login(),
    register: (context) => const Register(),
    forgotPassword: (context) => const ForgotPassword(),
    agenda: (context) => const MainNavigation(),
    profile: (context) => const ProfilePage(),
  };
}