import 'package:flutter/material.dart';
import 'package:my_first_app/features/features/features_page.dart';
import 'package:my_first_app/features/setting/setting_page.dart';

// PAGES (replace with your real pages where you already have UI)
import 'package:my_first_app/features/users/login_signup_page.dart';
import 'package:my_first_app/features/dashboard/dashboard_page.dart';
import 'package:my_first_app/features/order/orders_page.dart';
import 'package:my_first_app/features/users/profile_page.dart';
import 'package:my_first_app/features/setting/company_setup_page.dart';
import 'package:my_first_app/features/setting/company_details_page.dart';
import 'package:my_first_app/features/setting/domestic_kyc_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vertex',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1876C1)),
        scaffoldBackgroundColor: const Color(0xFFF7F7FB),
      ),
      // आप चाहें तो '/' भी रख सकते हैं; logout '/' पर जाएगा
      initialRoute: '/dashboard',
      routes: {
        '/': (_) => const LoginSignupPage(),

        // main tabs
        '/dashboard': (_) => const DashboardPage(),
        '/orders': (_) => const OrdersPage(),
        '/support': (_) => const SupportPage(),
        '/settings': (_) => const SettingsPage(),
        '/profile': (_) => const ProfilePage(),

        // settings section + pages
        '/settings/company': (_) => const CompanySetupPage(),
        '/settings/company/details': (_) => const CompanyDetailsPage(),
        '/settings/company/kyc': (_) => const DomesticKycPage(),

        // step-2 placeholder (aap photo page doge to replace kar dena)
        '/settings/company/kyc/photo': (_) => const _PhotoStepPlaceholder(),
      },
    );
  }
}

class _PhotoStepPlaceholder extends StatelessWidget {
  const _PhotoStepPlaceholder();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Photo Identification (Step 2)')),
      body: const Center(child: Text('Coming soon…')),
    );
  }
}
