import 'package:flutter/material.dart';
import 'package:my_first_app/app/app_layout.dart';
import 'package:my_first_app/app/app_routes.dart';
import 'package:my_first_app/features/dashboard/task_api.dart';
import 'package:my_first_app/features/dashboard/task_section.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final api = TaskApi();
  final GlobalKey<TaskSectionState> _tasksKey = GlobalKey<TaskSectionState>();

  Future<void> _openAddTaskDialog() async {
    final titleC = TextEditingController();
    final descC = TextEditingController();
    String status = "todo", priority = "medium";

    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setS) => AlertDialog(
          title: const Text("Add Task"),
          content: SizedBox(
            width: 420,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleC,
                  decoration: const InputDecoration(labelText: "Title"),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: descC,
                  decoration: const InputDecoration(labelText: "Description"),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField(
                  value: status,
                  decoration: const InputDecoration(labelText: "Status"),
                  items: const [
                    DropdownMenuItem(value: "todo", child: Text("To-Do")),
                    DropdownMenuItem(
                      value: "in_progress",
                      child: Text("In-Progress"),
                    ),
                    DropdownMenuItem(value: "done", child: Text("Done")),
                  ],
                  onChanged: (v) => setS(() => status = v as String),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField(
                  value: priority,
                  decoration: const InputDecoration(labelText: "Priority"),
                  items: const [
                    DropdownMenuItem(value: "low", child: Text("Low")),
                    DropdownMenuItem(value: "medium", child: Text("Medium")),
                    DropdownMenuItem(value: "high", child: Text("High")),
                  ],
                  onChanged: (v) => setS(() => priority = v as String),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancel"),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );

    if (ok == true) {
      await api.create({
        "title": titleC.text.trim(),
        "description": descC.text.trim(),
        "status": status,
        "priority": priority,
      });
      _tasksKey.currentState?.refresh();
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Task added")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final idx = AppRouteMap.indexForPath(ModalRoute.of(context)?.settings.name);
    return AppLayout(
      title: AppRouteMap.titles[idx],
      currentIndex: idx,
      onAddTask: _openAddTaskDialog,
      onSearch: (q) {},
      body: SingleChildScrollView(
        // 👇 top gap कम कर दिया
        padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _MetricsRow(),
            const SizedBox(height: 10),
            TaskSection(key: _tasksKey),
          ],
        ),
      ),
    );
  }
}

/* =================== METRICS CARDS =================== */

class _MetricsRow extends StatelessWidget {
  const _MetricsRow();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final cross = w >= 1000 ? 3 : (w >= 680 ? 2 : 1);

    return GridView.count(
      crossAxisCount: cross,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 2.8,
      children: const [
        _MetricCard(
          title: "Last Month Sale",
          value: "₹ 1,24,000",
          sub: "+8.2% vs prev.",
          icon: Icons.shopping_bag_outlined,
        ),
        _MetricCard(
          title: "Website Views",
          value: "48,230",
          sub: "+3.4% vs prev.",
          icon: Icons.show_chart_rounded,
        ),
        _MetricCard(
          title: "Total Profit",
          value: "₹ 36,400",
          sub: "+5.1% vs prev.",
          icon: Icons.paid_outlined,
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title, value, sub;
  final IconData icon;
  const _MetricCard({
    required this.title,
    required this.value,
    required this.sub,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final pc = Theme.of(context).colorScheme.primary;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: pc.withOpacity(.12),
            child: Icon(icon, color: pc),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 2),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  "+5% vs prev.",
                  style: TextStyle(fontSize: 12, color: Colors.green),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
