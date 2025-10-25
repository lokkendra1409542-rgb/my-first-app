import 'package:flutter/material.dart';

class SideMenu extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onSelect;

  /// when true => icons-only (collapsed)
  final bool isCollapsed;

  /// called when user taps collapse/expand button
  final VoidCallback onToggle;

  const SideMenu({
    super.key,
    required this.currentIndex,
    required this.onSelect,
    required this.isCollapsed,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final selectedBg = isDark
        ? const Color(0xFF1E2A3A)
        : const Color(0xFFE8F0FF);
    final hoverBg = isDark ? const Color(0xFF16202C) : const Color(0xFFF3F6FF);
    final selectedFg = isDark
        ? const Color(0xFFBFD2FF)
        : const Color(0xFF0B57D0);
    final normalIconFg = isDark ? Colors.grey[300] : Colors.grey[800];

    Widget header = Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
      child: Row(
        children: [
          if (!isCollapsed)
            const CircleAvatar(
              radius: 14,
              child: Icon(Icons.widgets, size: 16),
            ),
          if (!isCollapsed) const SizedBox(width: 8),
          if (!isCollapsed)
            const Expanded(
              child: Text(
                "Vertex Suite",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          IconButton(
            tooltip: isCollapsed ? 'Expand' : 'Collapse',
            icon: Icon(isCollapsed ? Icons.chevron_right : Icons.chevron_left),
            onPressed: onToggle,
          ),
        ],
      ),
    );

    List<Widget> items = [
      _item(
        context,
        Icons.dashboard,
        "Dashboard",
        0,
        isCollapsed,
        currentIndex,
        selectedBg,
        hoverBg,
        selectedFg,
        normalIconFg,
      ),
      _item(
        context,
        Icons.list_alt,
        "Orders",
        1,
        isCollapsed,
        currentIndex,
        selectedBg,
        hoverBg,
        selectedFg,
        normalIconFg,
      ),
      _item(
        context,
        Icons.support_agent,
        "Support",
        2,
        isCollapsed,
        currentIndex,
        selectedBg,
        hoverBg,
        selectedFg,
        normalIconFg,
      ),
      _item(
        context,
        Icons.settings,
        "Settings",
        3,
        isCollapsed,
        currentIndex,
        selectedBg,
        hoverBg,
        selectedFg,
        normalIconFg,
      ),
      const Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Divider(height: 1),
      ),
      _item(
        context,
        Icons.person,
        "My Profile",
        4,
        isCollapsed,
        currentIndex,
        selectedBg,
        hoverBg,
        selectedFg,
        normalIconFg,
      ),
    ];

    return ListView(
      padding: EdgeInsets.zero,
      children: [header, ...items, const SizedBox(height: 12)],
    );
  }

  Widget _item(
    BuildContext context,
    IconData icon,
    String text,
    int idx,
    bool isCollapsed,
    int currentIndex,
    Color selectedBg,
    Color hoverBg,
    Color selectedFg,
    Color? normalIconFg,
  ) {
    final selected = currentIndex == idx;
    final tile = ListTile(
      dense: true,
      contentPadding: EdgeInsets.symmetric(
        horizontal: isCollapsed ? 8 : 12,
        vertical: 4,
      ),
      leading: Icon(icon, color: selected ? selectedFg : normalIconFg),
      title: isCollapsed
          ? null
          : Text(
              text,
              style: TextStyle(
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                color: selected ? selectedFg : null,
              ),
            ),
      minLeadingWidth: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      selected: selected,
      selectedTileColor: selectedBg,
      hoverColor: hoverBg,
      onTap: () {
        onSelect(idx);
        Navigator.maybePop(context); // mobile drawer close
      },
    );

    // collapsed mode: show tooltip on hover
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: isCollapsed ? Tooltip(message: text, child: tile) : tile,
    );
  }
}
