import 'package:flutter/material.dart';
import 'package:my_first_app/app/app_layout.dart';
import 'package:my_first_app/app/app_routes.dart';
import 'package:my_first_app/widgets/app_page_body.dart';
import 'package:my_first_app/widgets/app_section_card.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final idx = AppRouteMap.indexForPath(ModalRoute.of(context)?.settings.name);
    return AppLayout(
      title: AppRouteMap.titles[idx],
      currentIndex: idx,
      body: AppPageBody(
        children: [
          AppSectionCard(
            title: 'Orders overview',
            subtitle: 'Track shipments, fulfilment status and COD settlements.',
            trailing: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.file_download_outlined),
              label: const Text('Download manifest'),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _StatusRow(
                  color: Colors.blue.shade100,
                  label: 'Ready to ship',
                  value: '12 packages',
                  description: 'Manifest generated and waiting for pickup.',
                ),
                const SizedBox(height: 16),
                _StatusRow(
                  color: Colors.orange.shade100,
                  label: 'Awaiting confirmation',
                  value: '5 packages',
                  description: 'Payment pending or address clarification required.',
                ),
                const SizedBox(height: 16),
                _StatusRow(
                  color: Colors.green.shade100,
                  label: 'Delivered this week',
                  value: '38 shipments',
                  description: 'All consignments successfully delivered to customers.',
                ),
              ],
            ),
          ),
          AppSectionCard(
            title: 'Latest updates',
            subtitle:
                'Get a pulse of recent order movement across carriers and channels.',
            child: Column(
              children: const [
                _TimelineTile(
                  title: 'Order #SH1243 reached the destination hub',
                  subtitle: 'BlueDart • Pune',
                  timeAgo: '12 minutes ago',
                  icon: Icons.flight_takeoff,
                ),
                _TimelineTile(
                  title: 'NDR raised for Order #SH1288',
                  subtitle: 'Customer requested re-attempt tomorrow',
                  timeAgo: '1 hour ago',
                  icon: Icons.info_outline_rounded,
                ),
                _TimelineTile(
                  title: 'COD remittance for ₹46,200 initiated',
                  subtitle: 'Expected credit in 2 working days',
                  timeAgo: 'Yesterday',
                  icon: Icons.payments_rounded,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusRow extends StatelessWidget {
  final Color color;
  final String label;
  final String value;
  final String description;

  const _StatusRow({
    required this.color,
    required this.label,
    required this.value,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  height: 1.4,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _TimelineTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String timeAgo;
  final IconData icon;

  const _TimelineTile({
    required this.title,
    required this.subtitle,
    required this.timeAgo,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: colors.primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: colors.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey.shade600, height: 1.4),
                ),
                const SizedBox(height: 8),
                Text(
                  timeAgo,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
