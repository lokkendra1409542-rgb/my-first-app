import 'package:flutter/material.dart';
import 'package:my_first_app/theme/app_colors.dart';

/// Top-level nav indices you can map to routes later.
class NavIndex {
  static const home = 0;
  static const dashboard = 1;
  static const orders = 2;
  static const returns = 3;
  static const deliveryBoost = 4;
  static const quickInstant = 5;
  static const weightMgmt = 6;
  static const buyerExperience = 7;
  static const setupManage = 8;
  static const tools = 9;
  static const apps = 10;
  static const billing = 11;
  static const settings = 12;
  static const support = 13; // help & support CTA
}

class SideMenu extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onSelect;
  const SideMenu({
    super.key,
    required this.currentIndex,
    required this.onSelect,
  });

  // rail colors (match screenshot vibe)
  static const navBg = Color(0xFF0B0F2D);
  static const navIconBg = Color(0x1FFFFFFF); // faint white
  static const navText = Color(0xFFE8EAF6);
  static const navTextDim = Color(0xFFB8C1EC);
  static const navActiveBg = Color(0x1AFFFFFF); // translucent white
  static const navDivider = Color(0x22FFFFFF);

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  // which sections with children are expanded
  final _expanded = <int>{};

  @override
  Widget build(BuildContext context) {
    final items = <_NavItem>[
      _NavItem(NavIndex.home, 'Home', Icons.home_rounded),
      _NavItem(
        NavIndex.dashboard,
        'Dashboard',
        Icons.show_chart_rounded,
        trailingHint: 'G+D',
      ),
      _NavItem(
        NavIndex.orders,
        'Orders',
        Icons.shopping_cart_checkout_rounded,
        hasChildren: true,
      ),
      _NavItem(NavIndex.returns, 'Returns', Icons.assignment_return_rounded),
      _NavItem(
        NavIndex.deliveryBoost,
        'Delivery Boost',
        Icons.local_shipping_rounded,
      ),
      _NavItem(
        NavIndex.quickInstant,
        'Quick – Instant Delivery',
        Icons.speed_rounded,
      ),
      _NavItem(
        NavIndex.weightMgmt,
        'Weight Management',
        Icons.lock_rounded,
        hasChildren: true,
      ),
      _NavItem(
        NavIndex.buyerExperience,
        'Buyer Experience',
        Icons.groups_rounded,
        hasChildren: true,
      ),
      _NavItem(
        NavIndex.setupManage,
        'Setup & Manage',
        Icons.auto_awesome_mosaic_rounded,
        hasChildren: true,
      ),
      _NavItem(
        NavIndex.tools,
        'Tools',
        Icons.handyman_rounded,
        hasChildren: true,
      ),
      _NavItem(NavIndex.apps, 'Apps', Icons.apps_rounded, hasChildren: true),
      _NavItem(NavIndex.billing, 'Billing', Icons.description_rounded),
      _NavItem(NavIndex.settings, 'Settings', Icons.settings_rounded),
    ];

    return Column(
      children: [
        // ===== Menu list =====
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 12),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 4),
            itemBuilder: (context, i) {
              final it = items[i];
              final selected = it.index == widget.currentIndex;
              final expanded = _expanded.contains(it.index);

              return _NavTile(
                item: it,
                selected: selected,
                expanded: expanded,
                onTap: () {
                  if (it.hasChildren) {
                    setState(() {
                      if (expanded) {
                        _expanded.remove(it.index);
                      } else {
                        _expanded.add(it.index);
                      }
                    });
                  } else {
                    widget.onSelect(it.index);
                  }
                },
                // you can hook subitems to routes later
                onTapChild: (childLabel) {
                  widget.onSelect(it.index); // or map by label if you want
                },
              );
            },
          ),
        ),

        const SizedBox(height: 8),
        const Divider(color: SideMenu.navDivider, height: 1),

        // ===== Help & Support CTA (white pill) =====
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
          child: SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: () => widget.onSelect(NavIndex.support),
              icon: const Icon(
                Icons.help_outline_rounded,
                color: AppColors.primary,
              ),
              label: const Text(
                'Help & Support',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/* ---------------- UI pieces ---------------- */

class _NavItem {
  final int index;
  final String label;
  final IconData icon;
  final bool hasChildren;
  final String? trailingHint;

  // (stub) sample children – you can replace with your real ones
  final List<String> children;

  _NavItem(
    this.index,
    this.label,
    this.icon, {
    this.hasChildren = false,
    this.trailingHint,
    List<String>? children,
  }) : children =
           children ??
           (hasChildren
               ? <String>['Overview', 'Reports', 'Settings']
               : const <String>[]);
}

class _NavTile extends StatelessWidget {
  final _NavItem item;
  final bool selected;
  final bool expanded;
  final VoidCallback onTap;
  final ValueChanged<String> onTapChild;

  const _NavTile({
    required this.item,
    required this.selected,
    required this.expanded,
    required this.onTap,
    required this.onTapChild,
  });

  @override
  Widget build(BuildContext context) {
    final base = _tileBase(selected);

    return Column(
      children: [
        // main row
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: base.decoration,
            child: Row(
              children: [
                // icon chip
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: base.iconBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(item.icon, size: 18, color: base.iconColor),
                ),
                const SizedBox(width: 12),

                // label
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        item.label,
                        style: TextStyle(
                          color: base.textColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (item.trailingHint != null) ...[
                        const SizedBox(width: 8),
                        Text(
                          item.trailingHint!,
                          style: TextStyle(
                            color: SideMenu.navTextDim.withOpacity(0.85),
                            fontSize: 11,
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // chevron for sections
                if (item.hasChildren)
                  Icon(
                    expanded
                        ? Icons.expand_less_rounded
                        : Icons.expand_more_rounded,
                    size: 18,
                    color: base.iconColor,
                  ),
              ],
            ),
          ),
        ),

        // children (collapse)
        if (item.hasChildren && expanded)
          Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 8),
            child: Column(
              children: item.children
                  .map(
                    (c) => InkWell(
                      onTap: () => onTapChild(c),
                      borderRadius: BorderRadius.circular(10),
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: Container(
                        margin: const EdgeInsets.only(
                          left: 58,
                          right: 10,
                          bottom: 4,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: SideMenu.navActiveBg.withOpacity(0.35),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: SideMenu.navIconBg.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.chevron_right_rounded,
                                size: 16,
                                color: SideMenu.navTextDim,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              c,
                              style: const TextStyle(
                                color: SideMenu.navTextDim,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
      ],
    );
  }

  _TileBase _tileBase(bool selected) {
    final textColor = selected
        ? AppColors.primary
        : const Color.fromARGB(255, 0, 0, 0);
    final iconColor = selected ? AppColors.primary : Colors.black; // accent
    return _TileBase(
      textColor: textColor,
      iconColor: iconColor,
      iconBg: SideMenu.navIconBg,
      decoration: BoxDecoration(
        color: selected ? SideMenu.navActiveBg : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}

class _TileBase {
  final Color textColor;
  final Color iconColor;
  final Color iconBg;
  final BoxDecoration decoration;
  _TileBase({
    required this.textColor,
    required this.iconColor,
    required this.iconBg,
    required this.decoration,
  });
}
