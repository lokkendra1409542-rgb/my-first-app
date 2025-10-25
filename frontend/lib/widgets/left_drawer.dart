import 'package:flutter/material.dart';
import 'side_menu.dart';

class LeftDrawer extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onSelect;
  const LeftDrawer({
    super.key,
    required this.currentIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 300,
      child: SideMenu(
        currentIndex: currentIndex,
        onSelect: (i) {
          Navigator.pop(context); // close drawer
          onSelect(i);
        },
      ),
    );
  }
}
