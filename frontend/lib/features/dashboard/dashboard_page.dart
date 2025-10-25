import 'package:flutter/material.dart';
import 'package:my_first_app/app/app_layout.dart';
import 'package:my_first_app/app/app_routes.dart';
import 'package:my_first_app/features/dashboard/task_api.dart';
import 'package:my_first_app/features/dashboard/task_section.dart';
import 'package:my_first_app/widgets/app_page_body.dart';
import 'package:my_first_app/widgets/app_section_card.dart';

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
      body: AppPageBody(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 1100;
              final content = [
                Flexible(
                  flex: 7,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const AppSectionCard(
                        title: 'Today at a glance',
                        subtitle:
                            'Quick metrics to understand the health of your business.',
                        child: _MetricsGrid(),
                      ),
                      const SizedBox(height: 20),
                      AppSectionCard(
                        title: 'Tasks & workflow',
                        subtitle:
                            'Organise priorities, assign statuses and keep the team aligned.',
                        trailing: IconButton(
                          tooltip: 'Refresh tasks',
                          icon: const Icon(Icons.refresh_rounded),
                          onPressed: () => _tasksKey.currentState?.refresh(),
                        ),
                        child: TaskSection(key: _tasksKey),
                      ),
                    ],
                  ),
                ),
                if (isWide) const SizedBox(width: 24) else const SizedBox(height: 24),
                Flexible(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: const [
                      AppSectionCard(
                        title: 'Quick actions',
                        subtitle: 'Most-used flows surfaced for faster execution.',
                        child: _QuickActions(),
                      ),
                      SizedBox(height: 20),
                      AppSectionCard(
                        title: 'Upcoming schedule',
                        subtitle: 'Stay ahead with reminders about your immediate goals.',
                        child: _ScheduleOverview(),
                      ),
                    ],
                  ),
                ),
              ];

              if (isWide) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: content,
                );
              }
              return Column(children: content);
            },
          ),
        ],
      ),
    );
  }
}

class _MetricsGrid extends StatelessWidget {
  const _MetricsGrid();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final crossAxisCount = width >= 960
            ? 3
            : width >= 620
                ? 2
                : 1;

        const items = [
          _MetricCard(
            title: 'Last Month Sale',
            value: '₹ 1,24,000',
            sub: '+8.2% vs previous month',
            icon: Icons.shopping_bag_outlined,
          ),
          _MetricCard(
            title: 'Website Views',
            value: '48,230',
            sub: '+3.4% vs previous month',
            icon: Icons.show_chart_rounded,
          ),
          _MetricCard(
            title: 'Total Profit',
            value: '₹ 36,400',
            sub: '+5.1% vs previous month',
            icon: Icons.paid_outlined,
          ),
        ];

        return GridView.builder(
          itemCount: items.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: width >= 960 ? 3.4 : 2.6,
          ),
          itemBuilder: (context, index) => items[index],
        );
      },
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
    final colors = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        color: colors.surface,
        boxShadow: const [
          BoxShadow(color: Color(0x12000000), blurRadius: 20, offset: Offset(0, 10)),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: colors.primary.withOpacity(0.14),
            child: Icon(icon, color: colors.primary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF455468),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  sub,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF1B8E5A),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions();

  static const _items = <_QuickActionData>[
    _QuickActionData(
      Icons.local_shipping_outlined,
      'Create shipment',
      'Generate a new shipment label and schedule a pickup.',
    ),
    _QuickActionData(
      Icons.file_copy_outlined,
      'Download reports',
      'Export reconciliation statements and COD settlements.',
    ),
    _QuickActionData(
      Icons.support_agent,
      'Raise support ticket',
      'Reach out to our operations team for help or escalations.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < _items.length; i++)
          _QuickActionTile(
            icon: _items[i].icon,
            title: _items[i].title,
            description: _items[i].description,
            isLast: i == _items.length - 1,
          ),
      ],
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool isLast;

  const _QuickActionTile({
    required this.icon,
    required this.title,
    required this.description,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: isLast
              ? BorderSide.none
              : BorderSide(color: Colors.grey.shade200),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: colors.primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: colors.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Icon(Icons.arrow_forward_ios_rounded,
              size: 16, color: Colors.grey.shade400),
        ],
      ),
    );
  }
}

class _ScheduleOverview extends StatelessWidget {
  const _ScheduleOverview();

  static const _items = <_ScheduleItem>[
    _ScheduleItem(
      '10:00 AM',
      'Inventory reconciliation',
      'Match seller SKUs against marketplace stock counts.',
    ),
    _ScheduleItem(
      '1:30 PM',
      'Carrier review call',
      'Discuss delayed shipments and allocate faster routes.',
    ),
    _ScheduleItem(
      '4:45 PM',
      'Marketing sprint sync',
      'Align landing page refresh before the weekend sale.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ..._items.map(
          (item) => _ScheduleTile(
            time: item.time,
            title: item.title,
            description: item.description,
          ),
        ),
        const SizedBox(height: 12),
        TextButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.calendar_today_rounded),
          label: const Text('Open calendar'),
        ),
      ],
    );
  }
}

class _QuickActionData {
  final IconData icon;
  final String title;
  final String description;

  const _QuickActionData(this.icon, this.title, this.description);
}

class _ScheduleItem {
  final String time;
  final String title;
  final String description;

  const _ScheduleItem(this.time, this.title, this.description);
}

class _ScheduleTile extends StatelessWidget {
  final String time;
  final String title;
  final String description;

  const _ScheduleTile({
    required this.time,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 84,
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFE4EDFF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              time,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: Color(0xFF1D4FB8),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: TextStyle(
                    height: 1.4,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
