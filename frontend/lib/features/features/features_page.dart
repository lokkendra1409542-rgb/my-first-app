import 'package:flutter/material.dart';
import 'package:my_first_app/app/app_layout.dart';
import 'package:my_first_app/app/app_routes.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final idx = AppRouteMap.indexForPath(ModalRoute.of(context)?.settings.name);
    return AppLayout(
      title: AppRouteMap.titles[idx],
      currentIndex: idx,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: const [
                Text(
                  "Support",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12),
                Text("• Email: support@example.com"),
                SizedBox(height: 8),
                Text("• FAQs coming soon."),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
