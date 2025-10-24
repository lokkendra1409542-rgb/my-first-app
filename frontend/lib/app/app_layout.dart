import 'package:flutter/material.dart';
import 'package:my_first_app/app/app_routes.dart';
import 'package:my_first_app/widgets/app_bar.dart';
import 'package:my_first_app/widgets/left_drawer.dart';
import 'package:my_first_app/widgets/side_menu.dart';

/// Common shell: AppBar + responsive sidebar (PC: inline & toggle, Phone: Drawer)
class AppLayout extends StatefulWidget {
  final Widget body;
  final int currentIndex;
  final String title;

  const AppLayout({
    super.key,
    required this.body,
    required this.currentIndex,
    required this.title,
  });

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  static const double _breakpoint = 900; // PC if width >= 900
  static const double _sidebarWidth = 260;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _sidebarOpen = true; // PC: open by default

  void _navigate(int i) {
    final path = AppRouteMap.pathForIndex(i);
    Navigator.pushReplacementNamed(context, path);
  }

  void _onMenuTap(bool isWide) {
    if (isWide) {
      setState(() => _sidebarOpen = !_sidebarOpen); // PC: toggle
    } else {
      _scaffoldKey.currentState?.openDrawer(); // Phone: open drawer
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isWide = w >= _breakpoint;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppAppBar(
        title: widget.title,
        onMenuTap: () => _onMenuTap(isWide),
      ),
      // Drawer only on phone
      drawer: isWide
          ? null
          : LeftDrawer(
              currentIndex: widget.currentIndex,
              onSelect: (i) => _navigate(i),
            ),
      body: Row(
        children: [
          // Inline collapsible sidebar on PC
          if (isWide)
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              width: _sidebarOpen ? _sidebarWidth : 0,
              child: _sidebarOpen
                  ? Material(
                      elevation: 1,
                      child: SafeArea(
                        child: SideMenu(
                          currentIndex: widget.currentIndex,
                          onSelect: (i) => _navigate(i),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),

          if (isWide && _sidebarOpen) const VerticalDivider(width: 1),

          Expanded(child: widget.body),
        ],
      ),
    );
  }
}
