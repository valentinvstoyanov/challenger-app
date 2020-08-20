import 'dart:convert';

import 'package:challenger/user/domain/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoggedUserStore {
  static const tokenKey = 'TOKEN';
  static const userKey = 'USER';
  static const userIdKey = 'USER_ID';

  final SharedPreferences prefs;
  String _token;
  String _userId;
  User _user;

  LoggedUserStore(this.prefs);

  Future<bool> saveToken(String token) {
    _token = token;
    return prefs.setString(tokenKey, token);
  }

  String getToken() {
    return _token ?? prefs.getString(tokenKey);
  }

  Future<bool> clear() {
    _user = null;
    return prefs.remove(tokenKey).then((_) => prefs.remove(userKey));
  }

  Future<bool> saveUser(User user) {
    _user = user;
    return prefs.setString(userKey, json.encode(user));
  }

  User getUser() {
    if (_user == null) {
      final savedUser = prefs.getString(userKey);
      if (savedUser != null) {
        _user = User.fromJson(json.decode(savedUser));
      }
    }

    return _user;
  }

  Future<bool> saveUserId(String userId) {
    _userId = userId;
    return prefs.setString(userIdKey, _userId);
  }

  String getUserId() {
    return _userId ?? prefs.get(userIdKey);
  }
}