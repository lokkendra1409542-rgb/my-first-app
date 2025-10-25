import 'package:flutter/material.dart';
import 'package:my_first_app/app/app_layout.dart';
import 'package:my_first_app/app/app_routes.dart';
import 'package:my_first_app/widgets/app_page_body.dart';
import 'package:my_first_app/widgets/app_section_card.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final idx = AppRouteMap.indexForPath(ModalRoute.of(context)?.settings.name);
    return AppLayout(
      title: AppRouteMap.titles[idx],
      currentIndex: idx,
      body: AppPageBody(
        children: [
          AppSectionCard(
            title: 'How can we help?',
            subtitle: 'Reach us anytime for onboarding, integrations or escalations.',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                _SupportChannel(
                  icon: Icons.mail_outline_rounded,
                  title: 'Email support',
                  value: 'support@example.com',
                  description:
                      'Average response within 2 business hours on working days.',
                ),
                SizedBox(height: 18),
                _SupportChannel(
                  icon: Icons.call_outlined,
                  title: 'Priority hotline',
                  value: '+91 80000 12345',
                  description: 'Dedicated success manager for enterprise customers.',
                ),
                SizedBox(height: 18),
                _SupportChannel(
                  icon: Icons.chat_bubble_outline_rounded,
                  title: 'Live chat',
                  value: 'Available 9AM – 9PM IST',
                  description: 'Chat with our agents directly from the web dashboard.',
                ),
              ],
            ),
          ),
          AppSectionCard(
            title: 'Guides & FAQs',
            subtitle: 'Get answers quickly from our curated documentation.',
            child: Wrap(
              spacing: 16,
              runSpacing: 16,
              children: const [
                _GuideChip(label: 'Shipping policy & weight slabs'),
                _GuideChip(label: 'Connecting a marketplace'),
                _GuideChip(label: 'Setting up webhooks'),
                _GuideChip(label: 'Troubleshooting pickups'),
                _GuideChip(label: 'Invoice & remittance queries'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SupportChannel extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String description;

  const _SupportChannel({
    required this.icon,
    required this.title,
    required this.value,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: colors.primary.withOpacity(0.12),
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
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                description,
                style: TextStyle(color: Colors.grey.shade600, height: 1.4),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _GuideChip extends StatelessWidget {
  final String label;

  const _GuideChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F6FF),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFD6E4FF)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Color(0xFF1D4FB8),
        ),
      ),
    );
  }
}
