import 'package:flutter/material.dart';
import 'package:my_first_app/core/auth_store.dart';
import 'package:my_first_app/features/features/features_page.dart';
import 'package:my_first_app/features/setting/setting_page.dart';
import 'package:my_first_app/features/users/login_signup_page.dart';
import 'package:my_first_app/features/dashboard/dashboard_page.dart';
import 'package:my_first_app/features/order/orders_page.dart';
import 'package:my_first_app/features/users/profile_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> _isLoggedIn() async => (await AuthStore.getToken()) != null;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tasks App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF5B7CFA),
      ),
      routes: {
        "/": (_) => FutureBuilder<bool>(
          future: _isLoggedIn(),
          builder: (_, s) {
            if (!s.hasData) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            return s.data! ? const DashboardPage() : const LoginSignupPage();
          },
        ),
        "/dashboard": (_) => const DashboardPage(),
        "/orders": (_) => const OrdersPage(),
        "/support": (_) => const SupportPage(),
        "/settings": (_) => const SettingsPage(),
        "/profile": (_) => const ProfilePage(),
      },
    );
  }
}
