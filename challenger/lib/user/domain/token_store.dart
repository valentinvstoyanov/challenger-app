import 'package:shared_preferences/shared_preferences.dart';

class TokenStore {
  static const tokenKey = 'Token';
  final SharedPreferences prefs;

  TokenStore(this.prefs);

  Future<bool> saveToken(String token) {
    return prefs.setString(tokenKey, token);
  }

  String getToken() {
    return prefs.getString(tokenKey);
  }

  Future<bool> clearToken() {
    return prefs.remove(tokenKey);
  }
}