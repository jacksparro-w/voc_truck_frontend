import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final mobileController = TextEditingController();

  final passwordController = TextEditingController();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 430,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppTheme.primary,
                      borderRadius:
                          BorderRadius.circular(18),
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 54,
                          height: 54,
                          decoration: BoxDecoration(
                            color: Colors.white
                                .withOpacity(0.14),
                            borderRadius:
                                BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.local_shipping,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          "VOC Control Room",
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                color: Colors.white,
                              ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Sign in to monitor fleet movement, trips, alerts, and driver operations.",
                          style: TextStyle(
                            color: Color(0xFFCBD5E1),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  TextField(
                    controller: mobileController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: "Mobile",
                      prefixIcon: Icon(Icons.phone_android),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Password",
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: loading ? null : login,
                    icon: loading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child:
                                CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.login),
                    label: const Text("Login"),
                  ),
                  const SizedBox(height: 14),
                  OutlinedButton.icon(
                    onPressed: loading
                        ? null
                        : () {
                            context.go("/driver-login");
                          },
                    icon: const Icon(Icons.badge_outlined),
                    label: const Text("Driver Login"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> login() async {
    setState(() {
      loading = true;
    });

    final loginResponse = await ref
        .read(authProvider.notifier)
        .login(
          mobileController.text,
          passwordController.text,
        );

    if (!mounted) {
      return;
    }

    setState(() {
      loading = false;
    });

    if (loginResponse != null) {
      final role = loginResponse.role.toUpperCase();

      if (role == "DRIVER") {
        context.go("/driver-dashboard");
      } else if (role == "ADMIN" ||
          role == "SUPERVISOR") {
        context.go("/dashboard");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Unsupported role: $role"),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Invalid Credentials"),
        ),
      );
    }
  }

  @override
  void dispose() {
    mobileController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
