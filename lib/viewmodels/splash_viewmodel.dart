import 'package:flutter/material.dart';
import '../utils/app_routes.dart';
import 'auth_viewmodel.dart';

class SplashViewModel with ChangeNotifier {
  final AuthViewModel authViewModel;

  SplashViewModel({required this.authViewModel});

  Future<String> determineStartRoute() async {
    await Future.delayed(const Duration(seconds: 2));
    await authViewModel.checkAuthStatus();
    return authViewModel.isLoggedIn ? AppRoutes.home : AppRoutes.login;
  }
} 