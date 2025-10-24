import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_first_app/theme/app_colors.dart';

class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title; // kept for API
  final VoidCallback onMenuTap;

  const AppAppBar({super.key, required this.title, required this.onMenuTap});

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF101113) : Colors.white;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: bg,
        elevation: 0,
        toolbarHeight: 72,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: bg,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.25 : 0.06),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
        ),
        title: _Toolbar(onMenuTap: onMenuTap),
      ),
    );
  }
}

class _Toolbar extends StatelessWidget {
  final VoidCallback onMenuTap;
  const _Toolbar({required this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isTight = w < 900;

    return Row(
      children: [
        if (isTight)
          IconButton(
            onPressed: onMenuTap,
            icon: const Icon(Icons.menu),
            tooltip: 'Menu',
          ),

        // LEFT: Logo
        const _Logo(),

        SizedBox(width: isTight ? 12 : 28),

        // CENTER: Search expands
        const Expanded(child: _SearchField()),

        SizedBox(width: isTight ? 8 : 12),

        // RIGHT: actions
        if (!isTight) ...[
          const _IconPill(icon: Icons.speed_rounded, label: 'Free Credit Score'),
          const SizedBox(width: 6),
          const _WalletPill(),
          const SizedBox(width: 6),
          _RoundIconButton(icon: Icons.refresh_rounded, onTap: () {}),
          const SizedBox(width: 8),
          const _IconPill(icon: Icons.help_outline_rounded, label: 'Need Help'),
          const SizedBox(width: 8),
          _RoundIconButton(icon: Icons.bolt_rounded, onTap: () {}),
          const SizedBox(width: 8),
          const _DropdownPill(label: 'ALL PRODUCTS'),
          const SizedBox(width: 8),
        ],
      ],
    );
  }
}

/* ---------------- Left: Logo ---------------- */

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 36,
          width: 36,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.primaryDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const Center(
            child: Text(
              'V',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'Vertex',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

/* ---------------- Center: Search ---------------- */

class _SearchField extends StatelessWidget {
  const _SearchField();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        color: isDark ? const Color(0xFF16181B) : Colors.white, // theme-friendly
        boxShadow: const [
          BoxShadow(color: Color(0x11000000), blurRadius: 12, offset: Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 8),
          Icon(Icons.search_rounded, color: Colors.grey.shade600),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: "Search via 'SKU'",
                hintStyle: TextStyle(color: Colors.grey.shade500),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onSubmitted: (v) {},
            ),
          ),
          const _KbdChip(keys: ['Ctrl', 'K']),
          const SizedBox(width: 8),
          _RoundIconButton(icon: Icons.mic_none_rounded, onTap: () {}),
        ],
      ),
    );
  }
}

/* ---------------- Right: Pills & Buttons ---------------- */

class _IconPill extends StatelessWidget {
  final IconData icon;
  final String label;
  const _IconPill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.primaryLightBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primaryBorder),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
              letterSpacing: .2,
            ),
          ),
        ],
      ),
    );
  }
}

class _WalletPill extends StatelessWidget {
  const _WalletPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.primaryLightBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primaryBorder),
      ),
      child: Row(
        children: [
          const Icon(Icons.account_balance_wallet_outlined, size: 16, color: AppColors.primary),
          const SizedBox(width: 6),
          const Text(
            '₹0',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
              letterSpacing: .2,
            ),
          ),
          const SizedBox(width: 6),
          Container(
            height: 20,
            width: 20,
            decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
            child: const Icon(Icons.add, size: 14, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _DropdownPill extends StatelessWidget {
  final String label;
  const _DropdownPill({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primaryBorder),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
              letterSpacing: .3,
            ),
          ),
          const SizedBox(width: 6),
          const Icon(Icons.apps_rounded, size: 14, color: AppColors.primary),
        ],
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _RoundIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: isDark ? const Color(0xFF16181B) : Colors.white, // theme-friendly
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          height: 36,
          width: 36,
          child: Center(
            child: Icon(icon, size: 18, color: AppColors.primary),
          ),
        ),
      ),
    );
  }
}

/* ---------------- Small UI atoms ---------------- */

class _KbdChip extends StatelessWidget {
  final List<String> keys;
  const _KbdChip({required this.keys});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: keys
          .map(
            (k) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFF6F7FB),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0xFFE3E6EF)),
              ),
              child: Text(
                k,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF6B7280),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
