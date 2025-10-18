import 'package:flutter/material.dart';
import 'package:my_first_app/widgets/side_menu.dart';

/// Phone-only Drawer wrapper (desktop shows inline sidebar)
class LeftDrawer extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onSelect;
  const LeftDrawer({super.key, required this.currentIndex, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: SideMenu.navBg, // ← dark rail bg
      child: SafeArea(
        child: SideMenu(
          currentIndex: currentIndex,
          onSelect: (i) {
            Navigator.pop(context); // close drawer
            onSelect(i);
          },
        ),
      ),
    );
  }
}
