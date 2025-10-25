// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:my_first_app/app/app_layout.dart';
import 'package:my_first_app/app/app_routes.dart';

class CompanyDetailsPage extends StatefulWidget {
  const CompanyDetailsPage({super.key});
  @override
  State<CompanyDetailsPage> createState() => _CompanyDetailsPageState();
}

class _CompanyDetailsPageState extends State<CompanyDetailsPage> {
  final _companyName = TextEditingController(text: "Lokendra Nath");
  final _companyEmail = TextEditingController(
    text: "lokendraverma225@gmail.com",
  );
  final _brandName = TextEditingController();
  final _website = TextEditingController();

  @override
  void dispose() {
    _companyName.dispose();
    _companyEmail.dispose();
    _brandName.dispose();
    _website.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final routeName = ModalRoute.of(context)?.settings.name;
    final idx = AppRouteMap.indexForPath(routeName);

    return AppLayout(
      title: "Company Details",
      currentIndex: idx,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1400),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () =>
                        Navigator.pushReplacementNamed(context, "/settings"),
                    child: const Text(
                      "Settings",
                      style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.chevron_right,
                    size: 18,
                    color: Colors.black45,
                  ),
                  const SizedBox(width: 6),
                  InkWell(
                    onTap: () => Navigator.pushReplacementNamed(
                      context,
                      "/settings/company",
                    ),
                    child: const Text(
                      "Company Setup",
                      style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.chevron_right,
                    size: 18,
                    color: Colors.black45,
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    "Company Details",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              const Text(
                "Company Details",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 4),
              const Text(
                "View, edit and update the company related details",
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 16),

              LayoutBuilder(
                builder: (context, c) {
                  final isWide = c.maxWidth >= 1000;
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isWide)
                        const SizedBox(width: 280, child: _LeftSectionMenu()),
                      if (isWide) const SizedBox(width: 16),
                      Expanded(child: _contentCard(context)),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _contentCard(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _InfoStrip(
              items: [
                const _InfoItem(label: "Company ID", value: "7993473"),
                _InfoItem(
                  label: "Plan",
                  value: "Lite Plan",
                  action: TextButton(
                    onPressed: () {},
                    child: const Text("Change plan"),
                  ),
                ),
                _InfoItem(
                  label: "Plan Subscription Status",
                  chip: _StatusChip(
                    text: "ACTIVE",
                    color: Colors.green.shade600,
                  ),
                ),
                const _InfoItem(
                  label: "Plan Subscription Duration",
                  value: "NA",
                ),
                const _InfoItem(label: "Renewal Date", value: "NA"),
              ],
            ),
            const SizedBox(height: 16),

            _sectionBox(
              title: "Registered Company Name",
              child: _readOnlyField(controller: _companyName),
            ),
            const SizedBox(height: 12),

            _sectionBox(
              title: "Company Email ID",
              child: _readOnlyField(controller: _companyEmail),
            ),
            const SizedBox(height: 12),

            _sectionBox(
              title: "Company Logo",
              caption: "Optional",
              child: _logoPicker(),
            ),
            const SizedBox(height: 12),

            _sectionBox(
              title: "Brand Name",
              caption: "Optional",
              child: _textField(
                controller: _brandName,
                hint: "Enter Brand name",
              ),
            ),
            const SizedBox(height: 12),

            _sectionBox(
              title: "Website",
              caption: "Optional",
              child: _textField(
                controller: _website,
                hint: "Enter Website link",
              ),
            ),

            const SizedBox(height: 18),
            SizedBox(
              height: 44,
              child: FilledButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Company details updated")),
                  );
                },
                child: const Text("Update Details"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // field helpers
  Widget _readOnlyField({required TextEditingController controller}) {
    return TextField(
      readOnly: true,
      controller: controller,
      decoration: _dec(),
    );
  }

  Widget _textField({required TextEditingController controller, String? hint}) {
    return TextField(
      controller: controller,
      decoration: _dec().copyWith(hintText: hint),
    );
  }

  InputDecoration _dec() => InputDecoration(
    isDense: true,
    filled: true,
    fillColor: Colors.grey.shade100,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
    ),
  );

  Widget _logoPicker() {
    return Container(
      height: 56,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              "No logo uploaded",
              style: TextStyle(color: Colors.black54),
            ),
          ),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.upload_rounded, size: 18),
            label: const Text("Upload"),
          ),
        ],
      ),
    );
  }

  Widget _sectionBox({
    required String title,
    String? caption,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13.5,
              ),
            ),
            if (caption != null) ...[
              const SizedBox(width: 6),
              Text(
                "($caption)",
                style: const TextStyle(color: Colors.black45, fontSize: 12),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

class _LeftSectionMenu extends StatelessWidget {
  const _LeftSectionMenu();
  @override
  Widget build(BuildContext context) {
    final items = const [
      "Company Details",
      "Domestic KYC",
      "Pick Up Address",
      "Labels",
      "Billing, Invoice, & GSTIN",
      "Password & Login Security",
      "Label Settings",
    ];
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListView.separated(
        itemCount: items.length + 1,
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(vertical: 10),
        separatorBuilder: (_, __) => const SizedBox(height: 2),
        itemBuilder: (_, i) {
          if (i == 0) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 10),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: const Color(0xFFE8F5E9),
                    child: Icon(
                      Icons.apartment_rounded,
                      color: Colors.green.shade600,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "COMPANY SETUP",
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      letterSpacing: .6,
                    ),
                  ),
                ],
              ),
            );
          }
          final label = items[i - 1];
          final selected = (i - 1) == 0;
          return InkWell(
            onTap: () {
              switch (i - 1) {
                case 0:
                  Navigator.pushReplacementNamed(
                    context,
                    "/settings/company/details",
                  );
                  break;
                case 1:
                  Navigator.pushReplacementNamed(
                    context,
                    "/settings/company/kyc",
                  );
                  break;
                default:
                  {}
              }
            },
            child: Container(
              height: 42,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.centerLeft,
              color: selected ? Colors.deepPurple.withOpacity(.06) : null,
              child: Text(
                label,
                style: TextStyle(
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// info strip
class _InfoStrip extends StatelessWidget {
  final List<_InfoItem> items;
  const _InfoStrip({required this.items});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Wrap(
        runSpacing: 10,
        spacing: 10,
        children: items
            .map(
              (it) => SizedBox(
                width: 280,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      it.label,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (it.chip != null)
                      it.chip!
                    else
                      Text(
                        it.value ?? "-",
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14.5,
                        ),
                      ),
                    if (it.action != null) it.action!,
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _InfoItem {
  final String label;
  final String? value;
  final Widget? chip;
  final Widget? action;
  const _InfoItem({required this.label, this.value, this.chip, this.action});
}

class _StatusChip extends StatelessWidget {
  final String text;
  final Color color;
  const _StatusChip({required this.text, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(.1),
        border: Border.all(color: color.withOpacity(.2)),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }
}
