import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'views/splash_screen.dart';
import 'views/login_screen.dart';
import 'views/registration_screen.dart'; // Import the new registration screen
import 'views/home_screen.dart';
import 'views/call_screen.dart';
import 'views/incoming_call_screen.dart';
import 'views/transcript_screen.dart';
import 'views/settings_screen.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/contacts_viewmodel.dart';
import 'viewmodels/call_viewmodel.dart';
import 'viewmodels/transcript_viewmodel.dart';
import 'viewmodels/settings_viewmodel.dart';
import 'utils/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
          ChangeNotifierProvider(create: (_) => AuthViewModel()),
          ChangeNotifierProvider(create: (_) => ContactsViewModel()),
          ChangeNotifierProvider(create: (_) => CallViewModel()),
          ChangeNotifierProvider(create: (_) => TranscriptViewModel()),
          ChangeNotifierProvider(create: (_) => SettingsViewModel()),
        ],
      child: Consumer<SettingsViewModel>(
          builder: (context, settingsVM, _) {
            return MaterialApp(
              title: 'Wi-Fi Talk',
              themeMode: settingsVM.themeMode,
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
                useMaterial3: true,
                appBarTheme: const AppBarTheme(
                  centerTitle: true,
                ),
                inputDecorationTheme: InputDecorationTheme(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              darkTheme: ThemeData(
                brightness: Brightness.dark,
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark),
                useMaterial3: true,
              ),
              initialRoute: AppRoutes.splash,
              routes: {
                AppRoutes.splash: (context) => const SplashScreen(),
                AppRoutes.login: (context) => const LoginScreen(),
                AppRoutes.registration: (context) => const RegistrationScreen(),
                AppRoutes.home: (context) => const HomeScreen(),
                AppRoutes.call: (context) => const CallScreen(),
                AppRoutes.incomingCall: (context) => const IncomingCallScreen(),
                AppRoutes.transcript: (context) => const TranscriptScreen(),
                AppRoutes.settings: (context) => const SettingsScreen(),
              },
            );
          },
        ),
    );
  }
}