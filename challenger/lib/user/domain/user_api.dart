import 'dart:convert';
import 'dart:io';

import 'package:challenger/api_error.dart';
import 'package:challenger/user/domain/logged_user_store.dart';
import 'package:challenger/user/domain/user.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as dev;

class UserApi {
  final String baseUrl;
  final LoggedUserStore userStore;

  UserApi(this.baseUrl, this.userStore);

  Future<User> registerUser(CreateUserRequest request) async {
    final headers = {HttpHeaders.contentTypeHeader:'application/json'};
    final response = await http.post('$baseUrl/users', headers: headers, body: json.encode(request));

    if (response.statusCode == HttpStatus.created) {
      return User.fromJson(json.decode(response.body));
    }

    if (response.statusCode == HttpStatus.badRequest) {
      throw ApiException(ApiError.fromMap(json.decode(response.body)));
    }

    throw Exception("Unexpected error occured while trying to register new user");
  }

  Future<bool> loginUser(LoginUserRequest request) async {
    final headers = {HttpHeaders.contentTypeHeader:'application/json'};
    final response = await http.post('$baseUrl/users/login', headers: headers, body: json.encode(request));

    if (response.statusCode == HttpStatus.ok) {
      final userId = json.decode(response.body)['id'];
      final jwt = json.decode(response.body)['token']['jwt'];
      return Future.wait([userStore.saveToken(jwt), userStore.saveUserId(userId)]).then((bs) => bs.reduce((b1, b2) => b1 && b2));
    }

    if (response.statusCode == HttpStatus.unauthorized) {
      throw ApiException(ApiError.fromMap(json.decode(response.body)));
    }

    throw Exception("Unexpected error occured while trying to login");
  }

  Future<User> getUserById(String id) async {
    final headers = {HttpHeaders.authorizationHeader:userStore.getToken()};
    final response = await http.get('$baseUrl/users/$id', headers: headers);

    if (response.statusCode == HttpStatus.ok) {
      return User.fromJson(json.decode(response.body));
    }

    throw Exception("Unexpected error occured while trying to get user by id");
  }

  Future<User> getLoggedUser() async {
    final storedUser = userStore.getUser();
    if (storedUser != null) {
      return storedUser;
    }

    final user = getUserById(userStore.getUserId());
    user.then((user) => userStore.saveUser(user));
    return user;
  }

  Future<List<User>> getAllUsers() async {
    final headers = {HttpHeaders.authorizationHeader:userStore.getToken()};
    final response = await http.get('$baseUrl/users', headers: headers);

    if (response.statusCode == HttpStatus.ok) {
      final List xs = json.decode(response.body);
      final List<User> users = xs.map((x) => User.fromJson(x)).toList();
      return users;
    }

    throw Exception("Unexpected error occured while trying to get all users");
  }

  Future<User> updateUser(String id, UpdateUser request) async {
    final headers = {HttpHeaders.contentTypeHeader:'application/json', HttpHeaders.authorizationHeader:userStore.getToken()};
    final response = await http.post('$baseUrl/users/$id', headers: headers, body: json.encode(request));

    if (response.statusCode == HttpStatus.ok) {
      return User.fromJson(json.decode(response.body));
    }

    if (response.statusCode == HttpStatus.badRequest) {
      throw ApiException(ApiError.fromMap(json.decode(response.body)));
    }

    throw Exception("Unexpected error occured while trying to update user");
  }
}