import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class Constants {
  static const List<String> stunServers = [
    'stun:stun.l.google.com:19302',
  ];
  static const List<String> turnServers = [
    // 'turn:your.turn.server:3478',
  ];

  static const bool useProdApi = true;
  static const String prodApiBase = 'https://wifi-calling-flutter-p7pq.vercel.app';

  static String get apiBaseUrl {
    if (useProdApi) return prodApiBase;
    if (kIsWeb) return 'http://localhost:3000';
    if (Platform.isAndroid) return 'http://10.0.2.2:3000';
    return 'http://localhost:3000';
  }

  static String get socketUrl {
    if (Platform.isAndroid) return 'http://10.0.2.2:3000';
    return 'http://localhost:3000';
  }
} 