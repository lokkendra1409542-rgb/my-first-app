import 'package:flutter/material.dart';
import 'package:my_first_app/app/app_layout.dart';
import 'package:my_first_app/app/app_routes.dart';
import 'package:my_first_app/features/setting/company_menu.dart';

class CompanySetupPage extends StatelessWidget {
  const CompanySetupPage({super.key});

  void _goMenu(BuildContext context, int i) {
    switch (i) {
      case 0:
        Navigator.pushReplacementNamed(context, "/settings/company/details");
        break;
      case 1:
        Navigator.pushReplacementNamed(context, "/settings/company/kyc");
        break;
      default:
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Placeholder")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final idx = AppRouteMap.indexForPath(ModalRoute.of(context)?.settings.name);

    return AppLayout(
      title: "Company Setup",
      currentIndex: idx,
      body: SafeArea(
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(
            context,
          ).copyWith(scrollbars: false, overscroll: false),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            physics: const ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // top-left
              children: [
                _breadcrumb(context),
                const SizedBox(height: 12),
                const Text(
                  "Company Setup",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 16),
                LayoutBuilder(
                  builder: (context, c) {
                    final isDesktop = c.maxWidth >= 1000;
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: isDesktop ? 280 : 280,
                          child: CompanyMenu(
                            current: -1,
                            onTap: (i) => _goMenu(context, i),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                              side: BorderSide(color: Colors.grey.shade200),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                16,
                                16,
                                16,
                                18,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Choose a section on the left",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "All options are aligned to the top-left and won’t move on click.",
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
        const Text(
          "Company Setup",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),
        ),
      ],
    );
  }
}
