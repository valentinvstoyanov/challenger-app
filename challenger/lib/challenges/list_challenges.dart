import 'dart:io';

import 'package:challenger/challenges/domain/challenge.dart';
import 'package:challenger/users/domain/logged_user_store.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'domain/challenge_api.dart';

class ListChallengesPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _ListChallengesPageState();
  }
}

class _ListChallengesPageState extends State<ListChallengesPage> {
  Future<List<Challenge>> _getChallenges() async {
    final userStore = LoggedUserStore(await SharedPreferences.getInstance());
    final challengeApi = ChallengeApi('http://192.168.0.106:8080/api', userStore);
    return challengeApi.getAllChallenges();
  }

  ListTile _challengeTile(Challenge challenge) =>
      ListTile(
        title: Text(
            challenge.name,
            style: Theme.of(context).textTheme.title,
        ),
        subtitle: Text(
          challenge.description,
          style: Theme.of(context).textTheme.subtitle,
        ),
        onTap: () {
          Navigator.pushNamed(context, '/detailChallenge', arguments: challenge.id);
        },
      );

  ListView _challengesListView(List<Challenge> challenges) =>
      ListView.builder(
        itemCount: challenges.length,
        itemBuilder: (context, index) => _challengeTile(challenges[index]),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Challenges"),
        ),
        body: Center(
          child: FutureBuilder<List<Challenge>>(
            future: _getChallenges(),
            builder: (context, snapshot) {
              if (snapshot.hasData)
                return _challengesListView(snapshot.data);
              if (snapshot.hasError)
                return Text("${snapshot.error}");
              return CircularProgressIndicator();
            },
          )
        )
    );
  }
}