import 'package:flutter/material.dart';
import 'package:my_first_app/app/app_layout.dart';
import 'package:my_first_app/app/app_routes.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final routeName = ModalRoute.of(context)?.settings.name;
    final idx = AppRouteMap.indexForPath(routeName);

    return AppLayout(
      title: AppRouteMap.titles[idx], // "Orders"
      currentIndex: idx,              // 1
      body: const SafeArea(
        child: Center(child: Text('Orders Page')),
      ),
    );
  }
}
