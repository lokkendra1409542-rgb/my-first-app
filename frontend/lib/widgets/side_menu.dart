import 'package:flutter/material.dart';

// Theme (same as AppBar logo palette)
const _blueDark = Color(0xFF0D4E81);
const _blueMid = Color(0xFF1876C1);
const _blueLight = Color(0xFF59B6F3);
const _textDim = Color(0xFFDAEEFF);
const _pillBg = Color(0x1459B6F3);

class SideMenu extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onSelect;

  const SideMenu({
    super.key,
    required this.currentIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 248,
      color: _blueDark,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top strip with logo
            Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.centerLeft,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [_blueMid, _blueDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border(bottom: BorderSide(color: Color(0x3359B6F3))),
              ),
              child: Row(
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
                      child: Image.asset(
                        "assets/logo.png",
                        width: 22,
                        height: 22,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "Vertex",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      letterSpacing: .2,
                    ),
                  ),
                ],
              ),
            ),

            // Menu items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 6),
                children: [
                  _item(Icons.dashboard_rounded, "Dashboard", 0),
                  _item(Icons.shopping_bag_outlined, "Orders", 1),
                  _item(Icons.support_agent, "Support", 2),
                  _item(Icons.settings, "Settings", 3),
                  const Divider(color: Color(0x3359B6F3)),
                  _item(Icons.person_outline, "My Profile", 4),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _item(IconData icon, String label, int idx) {
    final selected = currentIndex == idx;
    return InkWell(
      onTap: () => onSelect(idx),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? _pillBg : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, size: 22, color: selected ? Colors.white : _blueLight),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: selected ? Colors.white : _textDim,
                  fontWeight: FontWeight.w600,
                  fontSize: 13.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
