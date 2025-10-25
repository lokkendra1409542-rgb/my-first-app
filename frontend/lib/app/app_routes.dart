class AppRouteMap {
  static const paths = [
    "/dashboard",
    "/orders",
    "/support",
    "/settings",
    "/profile",
  ];

  static const titles = [
    "Dashboard",
    "Orders",
    "Support",
    "Settings",
    "My Profile",
  ];

  // subroutes under settings
  static const settingsSubroutes = [
    "/settings/company",
    "/settings/company/details",
    "/settings/company/kyc",
    "/settings/company/kyc/photo",
  ];

  static int indexForPath(String? p) {
    final path = p ?? "/dashboard";
    final i = paths.indexOf(path);
    if (i >= 0) return i;
    if (path.startsWith("/settings")) return 3; // keep Settings highlighted
    return 0;
  }

  static String pathForIndex(int i) {
    if (i < 0 || i >= paths.length) return "/dashboard";
    return paths[i];
  }
}
