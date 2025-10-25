import 'package:flutter/material.dart';
import 'package:my_first_app/app/app_layout.dart';
import 'package:my_first_app/app/app_routes.dart';
import 'package:my_first_app/core/kyc_store.dart';

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

  @override
  Widget build(BuildContext context) {
    final idx = AppRouteMap.indexForPath(ModalRoute.of(context)?.settings.name);

    return AppLayout(
      title: "Domestic KYC",
      currentIndex: idx,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1400),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _breadcrumb(context),
              const SizedBox(height: 12),
              const Text(
                "Domestic KYC",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              _stepHeader(),
              const SizedBox(height: 24),
              LayoutBuilder(
                builder: (context, c) {
                  final isWide = c.maxWidth >= 1000;
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isWide)
                        const SizedBox(
                          width: 280,
                          child: _LeftMenu(current: 1),
                        ),
                      if (isWide) const SizedBox(width: 16),
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

class _LeftMenu extends StatelessWidget {
  final int current; // 0=Company Details, 1=Domestic KYC, ...
  const _LeftMenu({required this.current});

  @override
  Widget build(BuildContext context) {
    final items = const [
      ("Company Details", "/settings/company/details"),
      ("Domestic KYC", "/settings/company/kyc"),
      ("Pick Up Address", "/settings/company"),
      ("Labels", "/settings/company"),
      ("Billing, Invoice, & GSTIN", "/settings/company"),
      ("Password & Login Security", "/settings/company"),
      ("Label Settings", "/settings/company"),
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
          final label = items[i - 1].$1;
          final route = items[i - 1].$2;
          final selected = (i - 1) == current;
          return InkWell(
            onTap: () => Navigator.pushReplacementNamed(context, route),
            child: Container(
              height: 42,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 16),
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
