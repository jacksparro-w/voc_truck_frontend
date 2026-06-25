import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {

  static const FlutterSecureStorage _storage =
      FlutterSecureStorage();

  static Future<void> saveToken(
      String token) async {

    await _storage.write(
      key: 'access_token',
      value: token,
    );
  }

  static Future<void> saveUser({
    required String role,
    required String name,
  }) async {
    await _storage.write(
      key: 'user_role',
      value: role,
    );

    await _storage.write(
      key: 'user_name',
      value: name,
    );
  }

  static Future<String?>
      getRole() async {

    return await _storage.read(
      key: 'user_role',
    );
  }

  static Future<String?>
      getName() async {

    return await _storage.read(
      key: 'user_name',
    );
  }

  static Future<String?>
      getToken() async {

    return await _storage.read(
      key: 'access_token',
    );
  }

  static Future<void> clear() async {

    await _storage.deleteAll();
  }
}
