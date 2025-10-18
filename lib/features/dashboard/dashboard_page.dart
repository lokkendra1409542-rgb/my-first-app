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
              // 🔴 Top alert bar
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.red[400],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "Click here to complete your KYC and get non-disrupted shipping and COD remittances",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ),

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
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () {},
                      child: const Text("Recharge Now"),
                    )
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
                _metricCard("Average Shipping Cost", "₹0", color: Colors.blue[100]),
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
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
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
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(1, 2),
          )
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
