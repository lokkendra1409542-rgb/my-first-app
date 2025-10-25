import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_first_app/theme/app_colors.dart';
import 'package:my_first_app/core/auth_store.dart';

class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onMenuTap;
  final ValueChanged<String>? onSearch;
  final Future<void> Function()? onAddTask;

  const AppAppBar({
    super.key,
    required this.title,
    required this.onMenuTap,
    this.onSearch,
    this.onAddTask,
  });

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF101113) : Colors.white;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: bg,
        elevation: 0,
        toolbarHeight: 72,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: bg,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.25 : 0.06),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
        ),
        title: _Toolbar(
          onMenuTap: onMenuTap,
          onSearch: onSearch,
          onAddTask: onAddTask,
        ),
        actions: [
          // 👇 Logout
          IconButton(
            tooltip: "Logout",
            icon: const Icon(Icons.logout_rounded),
            onPressed: () async {
              await AuthStore.clear();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, "/");
              }
            },
          ),
        ],
      ),
    );
  }
}

class _Toolbar extends StatelessWidget {
  final VoidCallback onMenuTap;
  final ValueChanged<String>? onSearch;
  final Future<void> Function()? onAddTask;
  const _Toolbar({required this.onMenuTap, this.onSearch, this.onAddTask});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isTight = w < 900;

    return Row(
      children: [
        if (isTight)
          IconButton(
            onPressed: onMenuTap,
            icon: const Icon(Icons.menu),
            tooltip: 'Menu',
          ),
        const _Logo(),
        SizedBox(width: isTight ? 12 : 28),
        Expanded(child: _SearchField(onSearch: onSearch)),
        SizedBox(width: isTight ? 8 : 12),
        if (!isTight && onAddTask != null)
          FilledButton.icon(
            onPressed: () => onAddTask!.call(),
            icon: const Icon(Icons.add_task_rounded, size: 18),
            label: const Text('Add Task'),
          ),
      ],
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo();
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Container(
        height: 36,
        width: 36,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.primaryDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Center(
          child: Text(
            'V',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
          ),
        ),
      ),
      const SizedBox(width: 8),
      Text(
        'Vertex',
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
      ),
    ],
  );
}

class _SearchField extends StatelessWidget {
  final ValueChanged<String>? onSearch;
  const _SearchField({this.onSearch});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        color: isDark ? const Color(0xFF16181B) : Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 8),
          Icon(Icons.search_rounded, color: Colors.grey.shade600),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: "Search tasks...",
                hintStyle: TextStyle(color: Colors.grey.shade500),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onSubmitted: (v) => onSearch?.call(v.trim()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.clear_rounded, size: 18),
            onPressed: () => onSearch?.call(""),
          ),
        ],
      ),
    );
  }
}
