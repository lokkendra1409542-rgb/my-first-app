import 'package:flutter/material.dart';
import 'package:my_first_app/app/app_routes.dart';
import 'package:my_first_app/widgets/app_app_bar.dart';
import 'package:my_first_app/widgets/left_drawer.dart';
import 'package:my_first_app/widgets/side_menu.dart';

class AppLayout extends StatefulWidget {
  final Widget body;
  final int currentIndex;
  final String title;
  final ValueChanged<String>? onSearch;
  final Future<void> Function()? onAddTask;

  const AppLayout({
    super.key,
    required this.body,
    required this.currentIndex,
    required this.title,
    this.onSearch,
    this.onAddTask,
  });

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  static const double _breakpoint = 900;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void _navigate(int i) {
    Navigator.pushReplacementNamed(context, AppRouteMap.pathForIndex(i));
  }

  void _onMenuTap(bool isWide) {
    if (!isWide) _scaffoldKey.currentState?.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= _breakpoint;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppAppBar(
        title: widget.title,
        onMenuTap: () => _onMenuTap(isWide),
        onSearch: widget.onSearch,
        onAddTask: widget.onAddTask,
      ),
      drawer: isWide
          ? null
          : LeftDrawer(currentIndex: widget.currentIndex, onSelect: _navigate),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE9F2FF), Color(0xFFFDFEFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (isWide)
              SideMenu(currentIndex: widget.currentIndex, onSelect: _navigate),
            Expanded(
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1280),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(26),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x14000000),
                              blurRadius: 30,
                              offset: Offset(0, 20),
                            ),
                          ],
                        ),
                        child: Material(
                          borderRadius: BorderRadius.circular(26),
                          clipBehavior: Clip.antiAlias,
                          color: Theme.of(context).colorScheme.surface,
                          child: widget.body,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
