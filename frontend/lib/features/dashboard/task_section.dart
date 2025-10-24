import 'package:flutter/material.dart';
import 'package:my_first_app/features/dashboard/task_api.dart';

class TaskSection extends StatefulWidget {
  const TaskSection({super.key});
  @override
  State<TaskSection> createState() => _TaskSectionState();
}

class _TaskSectionState extends State<TaskSection> {
  final api = TaskApi();
  late Future<List<Map<String, dynamic>>> fut;

  @override
  void initState() {
    super.initState();
    fut = api.list();
  }

  void _refresh() => setState(() => fut = api.list());

  Future<void> _openAddEdit([Map<String, dynamic>? t]) async {
    final titleC = TextEditingController(text: t?['title'] ?? "");
    final descC = TextEditingController(text: t?['description'] ?? "");
    String status = t?['status'] ?? "todo";
    String priority = t?['priority'] ?? "medium";

    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(t == null ? "Add Task" : "Edit Task"),
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
                onChanged: (v) => status = v as String,
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
                onChanged: (v) => priority = v as String,
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
      await api.update(t['_id'], {
        "title": titleC.text.trim(),
        "description": descC.text.trim(),
        "status": status,
        "priority": priority,
      });
    }
    _refresh();
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
      await api.delete(t['_id']);
      _refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                if (list.isEmpty)
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text("No tasks yet."),
                  );
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: list.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (_, i) {
                    final t = list[i];
                    return ListTile(
                      title: Text(t['title'] ?? ''),
                      subtitle: Text(
                        "${(t['priority'] ?? 'medium').toString().toUpperCase()} • "
                        "${(t['status'] ?? 'todo').toString().replaceAll('_', ' ').toUpperCase()}"
                        "${(t['description'] ?? '').isNotEmpty ? ' • ${t['description']}' : ''}",
                      ),
                      trailing: Wrap(
                        spacing: 8,
                        children: [
                          IconButton(
                            onPressed: () => _openAddEdit(t),
                            icon: const Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () => _delete(t),
                            icon: const Icon(Icons.delete_forever),
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
