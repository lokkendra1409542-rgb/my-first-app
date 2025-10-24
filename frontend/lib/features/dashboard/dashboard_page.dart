import 'package:flutter/material.dart';
import 'package:my_first_app/app/app_layout.dart';
import 'package:my_first_app/app/app_routes.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final routeName = ModalRoute.of(context)?.settings.name;
    final idx = AppRouteMap.indexForPath(routeName);

    final body = SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              InkWell(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.red[400],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    "Click here to complete your KYC and get non-disrupted shipping and COD remittances",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              // ✅ KYC Form (new)
              const KycFormSection(),
              const SizedBox(height: 24),

              // 💜 Recharge Banner
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFCBC3E3), Color(0xFFE6E6FA)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Text(
                        "Recharge for ₹200 & get ₹250* \nIn your wallet with chhota recharge",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {},
                      child: const Text("Recharge Now"),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 💡 Section: Shipments Details
              _sectionTitle("Shipments Details"),
              const SizedBox(height: 10),
              _gridCards([
                _metricCard("Total Shipments", "0"),
                _metricCard("Pickup Pending", "0"),
                _metricCard("In-Transit", "0"),
                _metricCard("Delivered", "0"),
                _metricCard("NDR Pending", "0"),
                _metricCard("RTO", "0"),
              ]),
              const SizedBox(height: 20),

              // 💰 Revenue Section
              _sectionTitle("Today's Revenue"),
              const SizedBox(height: 10),
              _gridCards([
                _metricCard("Today's Orders", "0", color: Colors.purple[100]),
                _metricCard("Today's Revenue", "₹0", color: Colors.green[100]),
                _metricCard(
                  "Average Shipping Cost",
                  "₹0",
                  color: Colors.blue[100],
                ),
                _metricCard("Total COD", "₹0", color: Colors.amber[100]),
              ]),
            ],
          ),
        ),
      ),
    );

    return AppLayout(
      title: AppRouteMap.titles[idx],
      currentIndex: idx,
      body: body,
    );
  }

  // 📦 Small helper widget for section heading
  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  // 📊 Grid layout of cards
  Widget _gridCards(List<Widget> cards) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 2.6,
      children: cards,
    );
  }

  // 🧩 Individual metric card widget
  Widget _metricCard(String label, String value, {Color? color}) {
    return Container(
      decoration: BoxDecoration(
        color: color ?? Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(1, 2)),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

/// ========================= KYC FORM SECTION =========================
class KycFormSection extends StatefulWidget {
  const KycFormSection({super.key});

  @override
  State<KycFormSection> createState() => _KycFormSectionState();
}

class _KycFormSectionState extends State<KycFormSection> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _bizName = TextEditingController();
  final _ownerName = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _gstin = TextEditingController();
  final _pan = TextEditingController();
  final _address = TextEditingController();
  final _pincode = TextEditingController();
  final _city = TextEditingController();
  final _state = TextEditingController();
  final _bankAcc = TextEditingController();
  final _ifsc = TextEditingController();

  String? _bizType;
  bool _agree = false;

  @override
  void dispose() {
    _bizName.dispose();
    _ownerName.dispose();
    _email.dispose();
    _phone.dispose();
    _gstin.dispose();
    _pan.dispose();
    _address.dispose();
    _pincode.dispose();
    _city.dispose();
    _state.dispose();
    _bankAcc.dispose();
    _ifsc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxW = constraints.maxWidth;
            final isTwoCol = maxW >= 720;
            final fieldW = isTwoCol ? (maxW - 24) / 2 : maxW;

            List<Widget> rows = [
              _titleRow(),
              const SizedBox(height: 12),

              // Business details
              _rowWrap([
                _input(
                  _bizName,
                  'Business/Store Name',
                  width: fieldW,
                  validator: _required,
                ),
                _dropdownBizType(width: fieldW),
              ]),

              _rowWrap([
                _input(
                  _ownerName,
                  'Owner/Contact Person',
                  width: fieldW,
                  validator: _required,
                ),
                _input(
                  _email,
                  'Email',
                  width: fieldW,
                  keyboard: TextInputType.emailAddress,
                  validator: _emailVal,
                ),
              ]),

              _rowWrap([
                _input(
                  _phone,
                  'Mobile Number',
                  width: fieldW,
                  keyboard: TextInputType.phone,
                  validator: _phoneVal,
                ),
                _input(
                  _gstin,
                  'GSTIN (optional)',
                  width: fieldW,
                  textCapitalization: TextCapitalization.characters,
                ),
              ]),

              _rowWrap([
                _input(
                  _pan,
                  'PAN',
                  width: fieldW,
                  textCapitalization: TextCapitalization.characters,
                  validator: _panVal,
                ),
                _input(
                  _bankAcc,
                  'Bank Account Number',
                  width: fieldW,
                  keyboard: TextInputType.number,
                  validator: _required,
                ),
              ]),

              _rowWrap([
                _input(
                  _ifsc,
                  'IFSC Code',
                  width: fieldW,
                  textCapitalization: TextCapitalization.characters,
                  validator: _ifscVal,
                ),
                _input(
                  _address,
                  'Address',
                  width: fieldW,
                  maxLines: 2,
                  validator: _required,
                ),
              ]),

              _rowWrap([
                _input(_city, 'City', width: fieldW, validator: _required),
                _input(_state, 'State', width: fieldW, validator: _required),
              ]),

              _rowWrap([
                _input(
                  _pincode,
                  'Pincode',
                  width: fieldW,
                  keyboard: TextInputType.number,
                  validator: _pinVal,
                ),
              ]),

              const SizedBox(height: 8),

              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                value: _agree,
                onChanged: (v) => setState(() => _agree = v ?? false),
                title: const Text(
                  'I confirm the above details are correct and I agree to the Terms & Conditions.',
                  style: TextStyle(fontSize: 13.5),
                ),
                controlAffinity: ListTileControlAffinity.leading,
              ),

              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton(
                  onPressed: _onSubmit,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.0,
                      vertical: 10,
                    ),
                    child: Text('Submit KYC'),
                  ),
                ),
              ),
            ];

            return Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: rows,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _titleRow() {
    return Row(
      children: [
        const Icon(Icons.verified_user, size: 22),
        const SizedBox(width: 8),
        const Text(
          'KYC Details',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(.12),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: Colors.orange.withOpacity(.3)),
          ),
          child: const Text(
            'Required for COD/Remittance',
            style: TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }

  // Wrap row helper (handles 1 or 2 columns)
  Widget _rowWrap(List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Wrap(spacing: 12, runSpacing: 12, children: children),
    );
  }

  // Text field builder
  Widget _input(
    TextEditingController c,
    String label, {
    double? width,
    int maxLines = 1,
    TextInputType? keyboard,
    String? Function(String?)? validator,
    TextCapitalization textCapitalization = TextCapitalization.none,
  }) {
    return SizedBox(
      width: width,
      child: TextFormField(
        controller: c,
        maxLines: maxLines,
        keyboardType: keyboard,
        textCapitalization: textCapitalization,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          isDense: true,
        ),
        validator: validator,
      ),
    );
  }

  // Business type dropdown
  Widget _dropdownBizType({double? width}) {
    const items = [
      'Individual',
      'Proprietorship',
      'Partnership',
      'Private Ltd',
      'LLP',
      'Other',
    ];
    return SizedBox(
      width: width,
      child: DropdownButtonFormField<String>(
        value: _bizType,
        decoration: InputDecoration(
          labelText: 'Business Type',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          isDense: true,
        ),
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: (v) => setState(() => _bizType = v),
        validator: (v) =>
            (v == null || v.isEmpty) ? 'Select business type' : null,
      ),
    );
  }

  // ===== Validators =====
  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Required' : null;

  String? _emailVal(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email is required';
    final ok = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(v.trim());
    return ok ? null : 'Invalid email';
  }

  String? _phoneVal(String? v) {
    if (v == null || v.trim().isEmpty) return 'Mobile is required';
    final digits = v.replaceAll(RegExp(r'\D'), '');
    return digits.length == 10 ? null : 'Enter 10-digit number';
  }

  String? _panVal(String? v) {
    if (v == null || v.trim().isEmpty) return 'PAN is required';
    final ok = RegExp(
      r'^[A-Z]{5}[0-9]{4}[A-Z]$',
    ).hasMatch(v.trim().toUpperCase());
    return ok ? null : 'Invalid PAN (e.g., ABCDE1234F)';
  }

  String? _ifscVal(String? v) {
    if (v == null || v.trim().isEmpty) return 'IFSC is required';
    final ok = RegExp(
      r'^[A-Z]{4}0[A-Z0-9]{6}$',
    ).hasMatch(v.trim().toUpperCase());
    return ok ? null : 'Invalid IFSC';
  }

  String? _pinVal(String? v) {
    if (v == null || v.trim().isEmpty) return 'Pincode is required';
    final ok = RegExp(r'^\d{6}$').hasMatch(v.trim());
    return ok ? null : 'Enter 6-digit pincode';
  }

  // ===== Submit =====
  void _onSubmit() {
    if (!_agree) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please agree to Terms & Conditions')),
      );
      return;
    }
    if (_formKey.currentState?.validate() != true) return;

    // 👉 Here you can call your API
    // final payload = {
    //   "business_name": _bizName.text.trim(),
    //   "business_type": _bizType,
    //   "owner_name": _ownerName.text.trim(),
    //   "email": _email.text.trim(),
    //   "phone": _phone.text.trim(),
    //   "gstin": _gstin.text.trim().isEmpty ? null : _gstin.text.trim(),
    //   "pan": _pan.text.trim().toUpperCase(),
    //   "address": _address.text.trim(),
    //   "city": _city.text.trim(),
    //   "state": _state.text.trim(),
    //   "pincode": _pincode.text.trim(),
    //   "bank_account": _bankAcc.text.trim(),
    //   "ifsc": _ifsc.text.trim().toUpperCase(),
    // };

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('KYC Submitted'),
        content: const Text(
          'Your KYC details were submitted successfully. We’ll verify and update your status shortly.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
