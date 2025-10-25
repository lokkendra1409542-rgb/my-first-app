import 'package:flutter/material.dart';
import 'package:my_first_app/app/app_layout.dart';
import 'package:my_first_app/app/app_routes.dart';
import 'package:my_first_app/core/kyc_store.dart';
import 'package:my_first_app/features/setting/company_menu.dart';

class DomesticKycPage extends StatefulWidget {
  const DomesticKycPage({super.key});

  @override
  State<DomesticKycPage> createState() => _DomesticKycPageState();
}

enum BusinessType { individual, proprietor, company }

class _DomesticKycPageState extends State<DomesticKycPage> {
  BusinessType? _type = KycStore.instance.type;
  String? _individualSubType = KycStore.instance.individualType;

  final _individualOptions = const ["Individual", "Freelancer", "Student"];

  void _goMenu(int i) {
    switch (i) {
      case 0:
        Navigator.pushReplacementNamed(context, "/settings/company/details");
        break;
      case 1:
        // already here
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("This section is a placeholder")),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final idx = AppRouteMap.indexForPath(ModalRoute.of(context)?.settings.name);

    return AppLayout(
      title: "Domestic KYC",
      currentIndex: idx,
      // Keep the app bar fixed via AppLayout. Make page content top-aligned and stable.
      body: SafeArea(
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(
            scrollbars: false, // prevent web scrollbar width shift
            overscroll: false, // remove glow/bounce that nudges layout
          ),
          child: LayoutBuilder(
            builder: (context, _) {
              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                physics: const ClampingScrollPhysics(),
                // Align to the TOP (not vertically centered)
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1400),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _breadcrumb(context),
                        const SizedBox(height: 12),
                        const Text(
                          "Domestic KYC",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _stepHeader(),
                        const SizedBox(height: 16),

                        LayoutBuilder(
                          builder: (context, c) {
                            final isDesktop = c.maxWidth >= 1000;
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (isDesktop) ...[
                                  SizedBox(
                                    width: 280,
                                    child: CompanyMenu(
                                      current: 1,
                                      onTap: _goMenu,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                ] else
                                  CompanyMenu(current: 1, onTap: _goMenu),

                                Expanded(child: _contentCard()),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _contentCard() {
    final canNext =
        _type != null &&
        (_type != BusinessType.individual || _individualSubType != null);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Please confirm your Business Type",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 16),

            _radioCard(
              value: BusinessType.individual,
              group: _type,
              title: "Individual",
              subtitle:
                  "A seller who is selling through online selling platforms, and has not registered the firm under Companies Act 2013",
              selectedColor: const Color(0xFFEFF6FF),
              onChanged: (v) => setState(() {
                _type = v;
                _individualSubType = null;
              }),
            ),
            const SizedBox(height: 12),

            _radioCard(
              value: BusinessType.proprietor,
              group: _type,
              title: "Sole Proprietor",
              subtitle:
                  "Registered company as ‘Sole proprietorship’ under Indian Proprietorship Act 1908",
              onChanged: (v) => setState(() => _type = v),
            ),
            const SizedBox(height: 12),

            _radioCard(
              value: BusinessType.company,
              group: _type,
              title: "Company",
              subtitle:
                  "Registered company as LLP, Public and Private under company Act 2013, Partnership Act 1932, & Trusts Act 1882",
              onChanged: (v) => setState(() => _type = v),
            ),
            const SizedBox(height: 16),

            if (_type == BusinessType.individual) ...[
              SizedBox(
                width: 380,
                child: DropdownButtonFormField<String>(
                  value: _individualSubType,
                  decoration: InputDecoration(
                    labelText: "Select Individual Type",
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                  ),
                  items: _individualOptions
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => setState(() => _individualSubType = v),
                ),
              ),
              const SizedBox(height: 16),
            ],

            Row(
              children: [
                OutlinedButton(
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, "/settings"),
                  child: const Text("Cancel"),
                ),
                const SizedBox(width: 10),
                FilledButton(
                  onPressed: canNext ? _onNext : null,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18.0),
                    child: Text("Next"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onNext() {
    KycStore.instance.type = _type!;
    KycStore.instance.individualType = _individualSubType;
    Navigator.pushNamed(context, "/settings/company/kyc/photo");
  }

  /* ---------- UI bits ---------- */

  Widget _breadcrumb(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () => Navigator.pushReplacementNamed(context, "/settings"),
          child: const Text(
            "Settings",
            style: TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 6),
        const Icon(Icons.chevron_right, size: 18, color: Colors.black45),
        const SizedBox(width: 6),
        InkWell(
          onTap: () =>
              Navigator.pushReplacementNamed(context, "/settings/company"),
          child: const Text(
            "Company Setup",
            style: TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 6),
        const Icon(Icons.chevron_right, size: 18, color: Colors.black45),
        const SizedBox(width: 6),
        const Text(
          "Domestic KYC",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),
        ),
      ],
    );
  }

  Widget _stepHeader() {
    Widget step(int n, String label, {bool active = false}) {
      final dotColor = active ? Colors.deepPurple : Colors.grey.shade400;
      final textStyle = TextStyle(
        fontWeight: active ? FontWeight.w800 : FontWeight.w600,
        color: active ? Colors.black : Colors.black54,
      );
      return Row(
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: dotColor,
            child: Text(
              "$n",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(label, style: textStyle),
        ],
      );
    }

    return Row(
      children: [
        step(1, "Business Type", active: true),
        Expanded(
          child: Divider(
            color: Colors.grey.shade300,
            thickness: 1,
            indent: 16,
            endIndent: 16,
          ),
        ),
        step(2, "Photo Identification"),
        Expanded(
          child: Divider(
            color: Colors.grey.shade300,
            thickness: 1,
            indent: 16,
            endIndent: 16,
          ),
        ),
        step(3, "Document Verification"),
      ],
    );
  }

  Widget _radioCard({
    required BusinessType value,
    required BusinessType? group,
    required String title,
    required String subtitle,
    required ValueChanged<BusinessType> onChanged,
    Color? selectedColor,
  }) {
    final selected = value == group;
    return InkWell(
      onTap: () => onChanged(value),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? (selectedColor ?? Colors.white) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? Colors.blue.shade200 : Colors.grey.shade300,
          ),
        ),
        child: Row(
          children: [
            Radio<BusinessType>(
              value: value,
              groupValue: group,
              onChanged: (v) => onChanged(v!),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: selected
                          ? Colors.blueGrey.shade800
                          : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.black54, height: 1.2),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
