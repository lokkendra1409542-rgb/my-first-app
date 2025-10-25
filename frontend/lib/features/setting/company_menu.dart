import 'package:flutter/material.dart';

class CompanyMenu extends StatelessWidget {
  final int current; // 0: details, 1: kyc, others placeholder
  final ValueChanged<int> onTap;
  const CompanyMenu({super.key, required this.current, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // top-left
      children: [
        _item(context, 0, "Company Details", Icons.badge_outlined),
        _item(context, 1, "Domestic KYC", Icons.verified_user_outlined),
        _item(context, 2, "Pickup Addresses", Icons.location_on_outlined),
        _item(context, 3, "Billing & GSTIN", Icons.receipt_long_outlined),
        _item(context, 4, "Label Settings", Icons.print_outlined),
        _item(context, 5, "Security", Icons.shield_outlined),
      ],
    );
  }

  Widget _item(BuildContext context, int idx, String label, IconData icon) {
    final selected = idx == current;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => onTap(idx),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFEFF6FF) : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected ? Colors.blue.shade300 : Colors.grey.shade300,
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 18,
                color: selected ? Colors.blue : Colors.black54,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                    color: selected ? Colors.black : Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
