import 'package:go_router/go_router.dart';

import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/splash_screen.dart';
import '../features/dashboard/screens/dashboard_screen.dart';
import '../features/driver/screens/driver_login_screen.dart';
import '../features/driver/screens/driver_dashboard_screen.dart';

final appRouter = GoRouter(
  initialLocation: "/",

  routes: [
    GoRoute(path: "/", builder: (context, state) => const SplashScreen()),
    GoRoute(
      path: "/driver-login",
      builder: (context, state) => const DriverLoginScreen(),
    ),

    GoRoute(
      path: "/driver-dashboard",
      builder: (context, state) => const DriverDashboardScreen(),
    ),

    GoRoute(path: "/login", builder: (context, state) => const LoginScreen()),

    GoRoute(
      path: "/dashboard",
      builder: (context, state) => const DashboardScreen(),
    ),
  ],
);
