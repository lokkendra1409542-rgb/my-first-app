import 'package:flutter/material.dart';
import 'package:my_first_app/widgets/side_menu.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;
  bool _collapsed = false; // desktop/web collapse toggle

  static const _desktopBreakpoint = 1000.0;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width >= _desktopBreakpoint;

    final body = IndexedStack(
      index: _index,
      children: const [
        Center(child: Text('Dashboard')),
        Center(child: Text('Orders')),
        Center(child: Text('Support')),
        Center(child: Text('Settings')),
        Center(child: Text('My Profile')),
      ],
    );

    if (isDesktop) {
      // FIXED sidebar with collapse/expand
      final sidebarWidth = _collapsed ? 72.0 : 250.0;

      return Scaffold(
        appBar: AppBar(
          title: const Text('My App'),
          // optional: quick toggle from AppBar too
          actions: [
            IconButton(
              tooltip: _collapsed ? 'Expand sidebar' : 'Collapse sidebar',
              icon: Icon(_collapsed ? Icons.chevron_right : Icons.chevron_left),
              onPressed: () => setState(() => _collapsed = !_collapsed),
            ),
          ],
        ),
        body: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              width: sidebarWidth,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                border: Border(
                  right: BorderSide(color: Theme.of(context).dividerColor),
                ),
              ),
              child: SafeArea(
                child: SideMenu(
                  currentIndex: _index,
                  isCollapsed: _collapsed,
                  onToggle: () => setState(() => _collapsed = !_collapsed),
                  onSelect: (i) => setState(() => _index = i),
                ),
              ),
            ),
            // content
            Expanded(child: body),
          ],
        ),
      );
    }

    // MOBILE/TABLET: Drawer
    return Scaffold(
      appBar: AppBar(title: const Text('My App')),
      drawer: Drawer(
        child: SafeArea(
          child: SideMenu(
            currentIndex: _index,
            isCollapsed: false, // drawer always expanded
            onToggle: () {}, // not used in drawer
            onSelect: (i) => setState(() => _index = i),
          ),
        ),
      ),
      body: body,
    );
  }
}
