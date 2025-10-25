import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_first_app/core/auth_store.dart';

const _blueDark = Color(0xFF0D4E81);
const _blueMid = Color(0xFF1876C1);
const _blueLight = Color(0xFF59B6F3);
const _chipBg = Color(0x1A59B6F3);
const _dividerC = Color(0x3359B6F3);

class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onMenuTap;
  final ValueChanged<String>? onSearch; // desktop/tablet only
  final Future<void> Function()? onAddTask; // optional

  const AppAppBar({
    super.key,
    required this.title,
    required this.onMenuTap,
    this.onSearch,
    this.onAddTask,
  });

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    final isNarrow = MediaQuery.of(context).size.width < 900;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: _blueMid,
        elevation: 0,
        toolbarHeight: 70,
        surfaceTintColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [_blueLight, _blueMid, _blueDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        titleSpacing: 8,
        title: Row(
          children: [
            if (isNarrow)
              IconButton(
                onPressed: onMenuTap,
                icon: const Icon(Icons.menu_rounded, color: Colors.white),
              ),
            const _LogoMark(),
            const SizedBox(width: 10),
            if (!isNarrow)
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            if (!isNarrow) ...[
              const SizedBox(width: 14),
              Expanded(child: _SearchField(onSearch: onSearch)),
            ] else
              const Spacer(),
          ],
        ),
        actions: [
          if (onAddTask != null)
            Container(
              height: 40,
              margin: const EdgeInsets.only(right: 6),
              decoration: BoxDecoration(
                color: _chipBg,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _dividerC),
              ),
              child: TextButton.icon(
                onPressed: () => onAddTask!.call(),
                icon: const Icon(Icons.add_task_rounded, color: Colors.white),
                label: const Text(
                  "Add Task",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          IconButton(
            tooltip: "Logout",
            onPressed: () async {
              try {
                await AuthStore.clear();
                if (!context.mounted) return;
                Navigator.of(
                  context,
                  rootNavigator: true,
                ).pushNamedAndRemoveUntil('/', (route) => false);
              } catch (e) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Logout failed: $e')));
              }
            },
            icon: const Icon(Icons.logout_rounded, color: Colors.white),
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }
}

class _LogoMark extends StatelessWidget {
  const _LogoMark();
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [_blueLight, _blueMid],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Image.asset("assets/logo.png", width: 22, height: 22),
          ),
        ),
        const SizedBox(width: 8),
        const Text(
          "Vertex",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
        ),
      ],
    );
  }
}

/* ---------- desktop/tablet search ---------- */
class _SearchField extends StatefulWidget {
  final ValueChanged<String>? onSearch;
  const _SearchField({this.onSearch});
  @override
  State<_SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<_SearchField> {
  final _c = TextEditingController();
  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0x1AFFFFFF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _dividerC),
      ),
      child: Row(
        children: [
          const Icon(Icons.search_rounded, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _c,
              style: const TextStyle(color: Colors.white),
              cursorColor: Colors.white,
              textInputAction: TextInputAction.search,
              decoration: const InputDecoration(
                hintText: "Search…",
                hintStyle: TextStyle(color: Colors.white70),
                border: InputBorder.none,
                isDense: true,
              ),
              onSubmitted: (v) => widget.onSearch?.call(v.trim()),
            ),
          ),
          IconButton(
            tooltip: _c.text.isEmpty ? "Filters" : "Clear",
            onPressed: () {
              if (_c.text.isEmpty) return;
              _c.clear();
              widget.onSearch?.call("");
              setState(() {});
            },
            icon: Icon(
              _c.text.isEmpty ? Icons.tune_rounded : Icons.close_rounded,
              size: 18,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
