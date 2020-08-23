import 'dart:convert';
import 'dart:io';

import 'package:challenger/challenges/domain/challenge.dart';
import 'package:challenger/users/domain/logged_user_store.dart';
import 'package:http/http.dart' as http;

import '../../api_error.dart';

class ChallengeApi {
  final String baseUrl;
  final LoggedUserStore userStore;

  ChallengeApi(this.baseUrl, this.userStore);

  Future<Challenge> createChallenge(CreateChallenge request) async {
    final headers = {HttpHeaders.contentTypeHeader:'application/json', HttpHeaders.authorizationHeader:userStore.getToken()};
    final response = await http.post('$baseUrl/challenges', headers: headers, body: json.encode(request));

    if (response.statusCode == HttpStatus.created) {
      return Challenge.fromJson(json.decode(response.body));
    }

    if (response.statusCode == HttpStatus.badRequest) {
      throw ApiException(ApiError.fromMap(json.decode(response.body)));
    }

    throw Exception("Unexpected error occured while trying to create new challenge");
  }

  Future<Challenge> getChallengeById(String id) async {
    final headers = {HttpHeaders.authorizationHeader:userStore.getToken()};
    final response = await http.get('$baseUrl/challenges/$id', headers: headers);

    if (response.statusCode == HttpStatus.ok) {
      return Challenge.fromJson(json.decode(response.body));
    }

    throw Exception("Unexpected error occured while trying to get challenge by id");
  }

  Future<List<Challenge>> getAllChallenges() async {
    final headers = {HttpHeaders.authorizationHeader:userStore.getToken()};
    final response = await http.get('$baseUrl/challenges', headers: headers);

    if (response.statusCode == HttpStatus.ok) {
      final List xs = json.decode(response.body);
      final List<Challenge> users = xs.map((x) => Challenge.fromJson(x)).toList();
      return users;
    }

    throw Exception("Unexpected error occured while trying to get all challenges");
  }
}