import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/splash_viewmodel.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  void _checkAuthAndNavigate() async {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final splashVM = SplashViewModel(authViewModel: authViewModel);
    final route = await splashVM.determineStartRoute();
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed(route);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Your app logo
            Icon(Icons.wifi_calling, size: 100, color: Colors.blue),
            SizedBox(height: 20),
            CircularProgressIndicator(color: Colors.blue),
            SizedBox(height: 20),
            Text(
              "Wi-Fi Talk",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            Text(
              "Connecting you, without numbers.",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}