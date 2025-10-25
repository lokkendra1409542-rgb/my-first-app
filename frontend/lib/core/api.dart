import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

class ApiConfig {
  /// Use: Web → localhost:5000
  /// Android emulator → 10.0.2.2:5000
  /// iOS simulator → localhost:5000
  /// Real device (same Wi-Fi) → put your PC LAN IP
  static String get baseUrl {
    if (kIsWeb) return "http://localhost:5000";
    try {
      if (Platform.isAndroid) return "http://10.0.2.2:5000";
      if (Platform.isIOS) return "http://localhost:5000";
      // Desktop (macOS/Windows/Linux):
      return "http://localhost:5000";
    } catch (_) {
      // Fallback (just in case)
      return "http://localhost:5000";
    }
  }

  /// If you’re testing from a real phone on the same Wi-Fi,
  /// temporarily override like this:
  // static const String baseUrl = "http://<YOUR_PC_LAN_IP>:5000";
}
