import 'package:flutter/material.dart';
import 'package:my_first_app/app/app_layout.dart';
import 'package:my_first_app/app/app_routes.dart';
import 'package:my_first_app/widgets/app_page_body.dart';
import 'package:my_first_app/widgets/app_section_card.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final idx = AppRouteMap.indexForPath(ModalRoute.of(context)?.settings.name);
    return AppLayout(
      title: AppRouteMap.titles[idx],
      currentIndex: idx,
      body: AppPageBody(
        children: [
          AppSectionCard(
            title: 'Account overview',
            subtitle: 'Manage your personal information, preferences and security.',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 38,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: const Icon(Icons.person, size: 34, color: Colors.white),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Priya Sharma',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text('Operations Manager • Vertex Logistics'),
                          SizedBox(height: 6),
                          Text(
                            'priya.sharma@example.com',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    FilledButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit profile'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 20),
                Wrap(
                  runSpacing: 16,
                  spacing: 16,
                  children: const [
                    _DetailChip(label: 'Phone', value: '+91 98765 43210'),
                    _DetailChip(label: 'Team', value: 'Fulfilment'),
                    _DetailChip(label: 'Time zone', value: 'Asia/Kolkata'),
                    _DetailChip(label: 'Language', value: 'English (India)'),
                  ],
                ),
              ],
            ),
          ),
          AppSectionCard(
            title: 'Security shortcuts',
            subtitle: 'Keep your account secure with recommended actions.',
            child: Column(
              children: const [
                _SecurityTile(
                  icon: Icons.lock_outline,
                  title: 'Update password',
                  description: 'Last changed 60 days ago. Improve security with a new passphrase.',
                ),
                _SecurityTile(
                  icon: Icons.phonelink_lock_outlined,
                  title: 'Enable two-factor authentication',
                  description:
                      'Add an extra layer of protection using SMS or authenticator apps.',
                ),
                _SecurityTile(
                  icon: Icons.notifications_active_outlined,
                  title: 'Notification preferences',
                  description: 'Choose what alerts you receive for shipments and billing.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailChip extends StatelessWidget {
  final String label;
  final String value;

  const _DetailChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0E6F6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF6F7A94),
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _SecurityTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _SecurityTile({
    required this.icon,
    required this.title,
    required this.description,
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
                const SizedBox(height: 6),
                Text(
                  description,
                  style: TextStyle(color: Colors.grey.shade600, height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Icon(Icons.arrow_forward_ios_rounded,
              size: 16, color: Colors.grey.shade400),
        ],
      ),
    );
  }
}
