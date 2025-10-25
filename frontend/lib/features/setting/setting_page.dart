import 'package:flutter/material.dart';
import 'package:my_first_app/app/app_layout.dart';
import 'package:my_first_app/app/app_routes.dart';
import 'package:my_first_app/widgets/app_page_body.dart';
import 'package:my_first_app/widgets/app_section_card.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final idx = AppRouteMap.indexForPath(ModalRoute.of(context)?.settings.name);

    return AppLayout(
      title: "Settings",
      currentIndex: idx,
      body: AppPageBody(
        children: [
          AppSectionCard(
            title: 'Settings',
            subtitle:
                'Configure your company profile, operational preferences and compliance.',
            leading: CircleAvatar(
              radius: 20,
              backgroundColor: const Color(0xFFE8F5E9),
              child: Icon(
                Icons.apartment_rounded,
                color: Colors.green.shade600,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 460),
                  child: TextField(
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      hintText: "Search for any setting or feature",
                      prefixIcon: const Icon(Icons.search_rounded),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 1.5,
                        ),
                      ),
                    ),
                    onSubmitted: (_) {},
                  ),
                ),
                const SizedBox(height: 24),
                Wrap(
                  spacing: 18,
                  runSpacing: 18,
                  children: [
                    _buildSettingTile(
                      title: "Company Details",
                      subtitle:
                          "View, edit and update brand name, email, logo, etc.",
                      onTap: () => Navigator.pushNamed(
                        context,
                        "/settings/company/details",
                      ),
                    ),
                    _buildSettingTile(
                      title: "Domestic KYC",
                      subtitle:
                          "Submit KYC information for uninterrupted shipping.",
                      onTap: () => Navigator.pushNamed(
                        context,
                        "/settings/company/kyc",
                      ),
                    ),
                    _buildSettingTile(
                      title: "Pickup Addresses",
                      subtitle: "Manage all your pickup addresses here.",
                      onTap: () {},
                    ),
                    _buildSettingTile(
                      title: "Billing, Invoice, & GSTIN",
                      subtitle:
                          "Add billing address, invoice preferences and GSTIN details.",
                      onTap: () {},
                    ),
                    _buildSettingTile(
                      title: "Label Settings",
                      subtitle:
                          "Choose the suitable label format for your company.",
                      onTap: () {},
                    ),
                    _buildSettingTile(
                      title: "Password & Login Security",
                      subtitle:
                          "Manage and update password & login security for your team.",
                      onTap: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
          AppSectionCard(
            title: 'Sign out',
            subtitle: 'Finish your session securely when you are done.',
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  "/",
                  (r) => false,
                );
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    Icon(Icons.logout_rounded, color: Colors.red),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Logout",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Icon(Icons.chevron_right, color: Colors.red),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: 360,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0A000000),
                blurRadius: 18,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.chevron_right, color: Colors.black38),
            ],
          ),
        ),
      ),
    );
  }
}
