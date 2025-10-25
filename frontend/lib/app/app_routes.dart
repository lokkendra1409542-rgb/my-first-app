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

  static int indexForPath(String? p) {
    final path = p ?? "/dashboard";
    final i = paths.indexOf(path);
    return i >= 0 ? i : 0;
  }

  static String pathForIndex(int i) {
    if (i < 0 || i >= paths.length) return "/dashboard";
    return paths[i];
  }

  static String titleForPath(String? p) {
    final i = indexForPath(p);
    return titles[i];
  }
}
