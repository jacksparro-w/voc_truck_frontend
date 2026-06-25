import 'package:flutter_riverpod/legacy.dart';

import '../../../core/storage/secure_storage.dart';
import '../models/login_response.dart';
import '../services/auth_service.dart';

final authProvider = StateNotifierProvider<AuthNotifier, bool>(
  (ref) => AuthNotifier(),
);

class AuthNotifier extends StateNotifier<bool> {
  AuthNotifier() : super(false);

  final AuthService _authService = AuthService();

  Future<LoginResponse?> login(String mobile, String password) async {
    try {
      final response = await _authService.login(mobile, password);

      if (response.statusCode == 200) {
        final loginResponse = LoginResponse.fromJson(
          Map<String, dynamic>.from(response.data),
        );

        if (loginResponse.accessToken.isEmpty ||
            loginResponse.role.isEmpty) {
          return null;
        }

        await SecureStorage.saveToken(loginResponse.accessToken);
        await SecureStorage.saveUser(
          role: loginResponse.role,
          name: loginResponse.name,
        );

        state = true;

        return loginResponse;
      }

      return null;
    } catch (_) {
      return null;
    }
  }

  Future<void> logout() async {
    await SecureStorage.clear();

    state = false;
  }

  Future<bool> checkLogin() async {
    final token = await SecureStorage.getToken();

    state = token != null;

    return state;
  }
}
