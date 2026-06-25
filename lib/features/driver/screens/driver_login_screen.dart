import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/storage/secure_storage.dart';
import '../../auth/models/login_response.dart';
import '../../auth/services/auth_service.dart';

class DriverLoginScreen extends StatefulWidget {
  const DriverLoginScreen({super.key});

  @override
  State<DriverLoginScreen> createState() =>
      _DriverLoginScreenState();
}

class _DriverLoginScreenState
    extends State<DriverLoginScreen> {

  final mobileController =
      TextEditingController();

  final passwordController =
      TextEditingController();

  final authService =
      AuthService();

  bool loading = false;

  Future<void> login() async {

    setState(() {
      loading = true;
    });

    try {

      final response =
          await authService.login(
        mobileController.text.trim(),
        passwordController.text.trim(),
      );

      final loginResponse =
          LoginResponse.fromJson(
        Map<String, dynamic>.from(
          response.data,
        ),
      );

      final role =
          loginResponse.role.toUpperCase();

      if (loginResponse.accessToken.isEmpty ||
          role.isEmpty) {
        throw Exception(
          "Invalid login response",
        );
      }

      if (!mounted) return;

      if (role == "DRIVER") {
        await SecureStorage.saveToken(
          loginResponse.accessToken,
        );

        await SecureStorage.saveUser(
          role: role,
          name: loginResponse.name,
        );

        context.go(
          "/driver-dashboard",
        );

        return;
      } else {

        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content: Text(
              "This account is not a driver account",
            ),
          ),
        );
      }

    } catch (e) {

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }

    if (!mounted) return;

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(
      BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints:
                  const BoxConstraints(
                maxWidth: 430,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.all(20),
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
                            color: AppTheme.accent,
                            borderRadius:
                                BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.badge_outlined,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        Text(
                          "Driver Workspace",
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                color: Colors.white,
                              ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Start your shift, track assigned trips, and keep GPS reporting online.",
                          style: TextStyle(
                            color: Color(0xFFCBD5E1),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 22,
                  ),
                  TextField(
                    controller:
                        mobileController,
                    keyboardType:
                        TextInputType.phone,
                    decoration:
                        const InputDecoration(
                      labelText:
                          "Mobile Number",
                      prefixIcon: Icon(
                        Icons.phone_android,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextField(
                    controller:
                        passwordController,
                    obscureText: true,
                    decoration:
                        const InputDecoration(
                      labelText: "Password",
                      prefixIcon: Icon(
                        Icons.lock_outline,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  ElevatedButton.icon(
                    onPressed:
                        loading ? null : login,
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
                    label: const Text(
                      "Login",
                    ),
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  OutlinedButton.icon(
                    onPressed: loading
                        ? null
                        : () {
                            context.go("/login");
                          },
                    icon: const Icon(
                      Icons.admin_panel_settings,
                    ),
                    label: const Text(
                      "Control Room Login",
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {

    mobileController.dispose();

    passwordController.dispose();

    super.dispose();
  }
}
