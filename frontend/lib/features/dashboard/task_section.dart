import 'package:flutter/material.dart';
import 'package:my_first_app/features/dashboard/task_api.dart';

class TaskSection extends StatefulWidget {
  const TaskSection({super.key});
  @override
  TaskSectionState createState() => TaskSectionState();
}

class TaskSectionState extends State<TaskSection> {
  final api = TaskApi();
  late Future<List<Map<String, dynamic>>> fut;

  @override
  void initState() {
    super.initState();
    fut = api.list();
  }

  void refresh() => setState(() => fut = api.list());

  Color _statusColor(String s) {
    switch (s) {
      case "done":
        return Colors.green;
      case "in_progress":
        return Colors.orange;
      default:
        return Colors.blueGrey;
    }
  }

  Color _priorityColor(String p) {
    switch (p) {
      case "high":
        return Colors.red;
      case "low":
        return Colors.teal;
      default:
        return Colors.indigo;
    }
  }

  Future<void> _openAddEdit([Map<String, dynamic>? t]) async {
    final titleC = TextEditingController(text: t?['title'] ?? "");
    final descC = TextEditingController(text: t?['description'] ?? "");
    String status = t?['status'] ?? "todo";
    String priority = t?['priority'] ?? "medium";

    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setS) => AlertDialog(
          title: Text(t == null ? "Add Task" : "Edit Task"),
          content: SizedBox(
            width: 440,
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

    if (ok != true) return;

    if (t == null) {
      await api.create({
        "title": titleC.text.trim(),
        "description": descC.text.trim(),
        "status": status,
        "priority": priority,
      });
    } else {
      final id = t['_id']?.toString();
      if (id == null || id.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Invalid task id")));
        return;
      }
      await api.update(id, {
        "title": titleC.text.trim(),
        "description": descC.text.trim(),
        "status": status,
        "priority": priority,
      });
    }
    refresh();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t == null ? "Task added" : "Task updated")),
      );
    }
  }

  Future<void> _delete(Map<String, dynamic> t) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Task?"),
        content: Text("“${t['title']}” को हटाना है?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
    if (ok == true) {
      final id = t['_id']?.toString();
      if (id == null || id.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Invalid task id")));
        return;
      }
      await api.delete(id);
      refresh();
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Task deleted")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                const Text(
                  "Tasks",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                FilledButton.icon(
                  onPressed: () => _openAddEdit(),
                  icon: const Icon(Icons.add),
                  label: const Text("Add Task"),
                ),
              ],
            ),
            const SizedBox(height: 12),

            FutureBuilder<List<Map<String, dynamic>>>(
              future: fut,
              builder: (_, s) {
                if (s.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(),
                  );
                }
                if (s.hasError) return Text("Error: ${s.error}");
                final list = s.data ?? [];
                if (list.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.inbox_outlined, color: Colors.grey),
                        SizedBox(width: 8),
                        Text(
                          "No tasks yet. Add your first task!",
                          style: TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: list.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) {
                    final t = list[i];
                    final status = (t['status'] ?? 'todo').toString();
                    final priority = (t['priority'] ?? 'medium').toString();

                    return Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 4,
                            height: 52,
                            margin: const EdgeInsets.only(right: 12, top: 2),
                            decoration: BoxDecoration(
                              color: _statusColor(status),
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  (t['title'] ?? '').toString(),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                if ((t['description'] ?? '')
                                    .toString()
                                    .isNotEmpty)
                                  Text(
                                    (t['description'] ?? '').toString(),
                                    style: const TextStyle(
                                      color: Colors.black54,
                                    ),
                                  ),
                                const SizedBox(height: 10),
                                Wrap(
                                  spacing: 6,
                                  runSpacing: 6,
                                  children: [
                                    _ChipBadge(
                                      label: status
                                          .replaceAll('_', ' ')
                                          .toUpperCase(),
                                      color: _statusColor(status),
                                    ),
                                    _ChipBadge(
                                      label:
                                          "PRIORITY: ${priority.toUpperCase()}",
                                      color: _priorityColor(priority),
                                    ),
                                    if (t['_id'] != null)
                                      _ChipBadge(
                                        label:
                                            "ID: ${t['_id'].toString().substring(0, 6)}",
                                        color: Colors.grey,
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              IconButton(
                                tooltip: "Edit",
                                onPressed: () => _openAddEdit(t),
                                icon: const Icon(Icons.edit, size: 20),
                              ),
                              IconButton(
                                tooltip: "Delete",
                                onPressed: () => _delete(t),
                                icon: const Icon(
                                  Icons.delete_forever,
                                  size: 20,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/* ---------------- small badge chip ---------------- */

class _ChipBadge extends StatelessWidget {
  final String label;
  final Color color;
  const _ChipBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(.12),
        border: Border.all(color: color.withOpacity(.35)),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: _darken(color),
        ),
      ),
    );
  }

  Color _darken(Color c, [double amount = .32]) {
    final hsl = HSLColor.fromColor(c);
    final l = (hsl.lightness - amount).clamp(0.0, 1.0);
    return hsl.withLightness(l).toColor();
  }
}
