import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:voc_truck_tracking/core/storage/secure_storage.dart';
import 'package:voc_truck_tracking/features/auth/screens/splash_screen.dart';
import 'package:voc_truck_tracking/features/auth/screens/login_screen.dart';
import 'package:voc_truck_tracking/features/dashboard/screens/dashboard_screen.dart';

Widget buildTestApp() {
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
    ],
  );

  return ProviderScope(child: MaterialApp.router(routerConfig: router));
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
  });

  testWidgets('splash redirects to login when no JWT token exists', (
    tester,
  ) async {
    await tester.pumpWidget(buildTestApp());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));
    await tester.pump();

    expect(find.text('Login'), findsWidgets);
    expect(find.text('Mobile'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
  });

  testWidgets('splash redirects to dashboard when JWT token exists', (
    tester,
  ) async {
    await SecureStorage.saveToken('test-jwt-token');

    await tester.pumpWidget(buildTestApp());
    await tester.pump(const Duration(seconds: 3));
    await tester.pump();

    expect(find.text('Admin Dashboard'), findsOneWidget);
  });

  testWidgets('login screen shows mobile, password, and submit controls', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: ProviderScope(child: LoginScreen())),
    );

    expect(find.text('Login'), findsWidgets);
    expect(find.text('Mobile'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });
}
