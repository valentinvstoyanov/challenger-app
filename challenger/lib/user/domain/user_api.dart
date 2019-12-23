import 'dart:convert';
import 'dart:io';

import 'package:challenger/api_error.dart';
import 'package:challenger/user/domain/user.dart';
import 'package:http/http.dart';

class UserApi {
  final Client client;
  final String baseUrl;

  UserApi(this.client, this.baseUrl);

  Future<User> registerUser(CreateUserRequest request) async {
    final response = await client.post('$baseUrl/users', headers: {HttpHeaders.contentTypeHeader:'application/json'}, body: json.encode(request));

    if (response.statusCode == HttpStatus.created) {
      return User.fromJson(json.decode(response.body));
    }

    if (response.statusCode == HttpStatus.badRequest) {
      throw ApiException(ApiError.fromMap(json.decode(response.body)));
    }

    throw Exception("Unexpected error occured while trying to register new user");
  }

  Future<List<User>> getAllUsers() async {
    final response = await client.get('$baseUrl/users');
    if (response.statusCode == HttpStatus.ok) {
      final List xs = json.decode(response.body);
      final List<User> users = xs.map((x) => User.fromJson(x)).toList();
      return users;
    }

    throw Exception("Unexpected error occured while trying to get all users");
  }
}