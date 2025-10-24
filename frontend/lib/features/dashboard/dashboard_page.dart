import 'package:flutter/material.dart';
import 'package:my_first_app/core/auth_store.dart';
import 'package:my_first_app/features/dashboard/task_section.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        actions: [
          IconButton(
            tooltip: "Logout",
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await AuthStore.clear();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, "/");
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [TaskSection()],
          ),
        ),
      ),
    );
  }
}
