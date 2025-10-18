import 'package:flutter/material.dart';
import 'package:my_first_app/features/dashboard/dashboard_page.dart';
import 'package:my_first_app/features/order/order_page.dart';
import 'package:my_first_app/features/support/support_page.dart';
import 'package:my_first_app/features/setting/setting_page.dart';

/// 4 working routes only: Dashboard(0), Orders(1), Support(2), Settings(3)
class AppRouteMap {
  static const dashboard = '/';
  static const orders    = '/orders';
  static const support   = '/support';
  static const settings  = '/settings';

  static const titles = <String>['Dashboard', 'Orders', 'Support', 'Settings'];

  static String pathForIndex(int i) => [dashboard, orders, support, settings][i];

  static int indexForPath(String? path) {
    switch (path) {
      case orders:   return 1;
      case support:  return 2;
      case settings: return 3;
      case dashboard:
      default:       return 0;
    }
  }
}

Map<String, WidgetBuilder> appRoutes() => {
  AppRouteMap.dashboard: (_) => const DashboardPage(),
  AppRouteMap.orders:    (_) => const OrdersPage(),
  AppRouteMap.support:   (_) => const SupportPage(),
  AppRouteMap.settings:  (_) => const SettingsPage(),
};
