import 'package:flutter/material.dart';
import 'package:my_first_app/features/features/features_page.dart';
import 'package:my_first_app/features/setting/setting_page.dart';
import 'package:my_first_app/widgets/side_menu.dart';
import 'package:my_first_app/widgets/left_drawer.dart';
import 'package:my_first_app/widgets/app_app_bar.dart';

// pages
import 'package:my_first_app/features/dashboard/dashboard_page.dart';
import 'package:my_first_app/features/order/orders_page.dart';
import 'package:my_first_app/features/users/profile_page.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  static const double _desktopBreakpoint = 900;
  static const double _sidebarWidth = 260;
  bool _collapsed = false; // desktop/web collapse toggle
  int _index = 0;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  // ---- helpers ----
  bool get _isWide => MediaQuery.of(context).size.width >= _desktopBreakpoint;

  void _onMenuTap() {
    if (_isWide) {
      setState(() => _collapsed = !_collapsed);
    } else {
      _scaffoldKey.currentState?.openDrawer();
    }
  }

  Widget _pageForIndex(int i) {
    switch (i) {
      case 0:
        return const DashboardPage();
      case 1:
        return const OrdersPage();
      case 2:
        return const SupportPage();
      case 3:
        return const SettingsPage();
      case 4:
        return const ProfilePage();
      default:
        return const DashboardPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWide = _isWide;

    return Scaffold(
      key: _scaffoldKey,

      // 🔼 same AppBar you use everywhere (logout/search/add task supported)
      appBar: AppAppBar(
        title: const [
          'Dashboard',
          'Orders',
          'Support',
          'Settings',
          'My Profile',
        ].elementAt(_index),
        onMenuTap: _onMenuTap,
        onSearch: (q) {
          if (q.isNotEmpty) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text("Search: $q")));
          }
        },
        onAddTask: () async {
          // DashboardPage के अंदर Add Task dialog already है,
          // यहां generic message रख देते हैं (optional).
          if (_index != 0) {
            setState(() => _index = 0);
          }
        },
      ),

      // 📱 Drawer केवल mobile/tablet पर
      drawer: isWide
          ? null
          : LeftDrawer(
              currentIndex: _index,
              onSelect: (i) {
                Navigator.pop(context); // close drawer
                setState(() => _index = i);
              },
            ),

      body: Row(
        children: [
          // 💻 Desktop: collapsible sidebar
          if (isWide)
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              width: _collapsed ? 0 : _sidebarWidth,
              child: _collapsed
                  ? const SizedBox.shrink()
                  : Material(
                      elevation: 1,
                      child: SafeArea(
                        child: SideMenu(
                          currentIndex: _index,
                          onSelect: (i) => setState(() => _index = i),
                        ),
                      ),
                    ),
            ),

          if (isWide && !_collapsed) const VerticalDivider(width: 1),

          // 📄 Page content
          Expanded(child: _pageForIndex(_index)),
        ],
      ),
    );
  }
}
