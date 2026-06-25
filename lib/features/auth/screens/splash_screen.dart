import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/storage/secure_storage.dart';

class SplashScreen
    extends StatefulWidget {
  const SplashScreen({
    super.key,
  });

  @override
  State<SplashScreen>
      createState() =>
          _SplashScreenState();
}

class _SplashScreenState
    extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    checkLogin();
  }

  Future<void> checkLogin()
      async {

    final token =
        await SecureStorage.getToken();

    final role =
        (await SecureStorage.getRole())?.toUpperCase();

    await Future.delayed(
      const Duration(seconds: 2),
    );

    if (!mounted) return;

    if (token != null) {
      if (role == "DRIVER") {
        GoRouter.of(context).go("/driver-dashboard");
      } else {
        GoRouter.of(context).go("/dashboard");
      }
    } else {
      GoRouter.of(context).go("/login");
    }
  }

  @override
  Widget build(
      BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
