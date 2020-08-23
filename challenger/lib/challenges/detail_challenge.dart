import 'dart:io';

import 'package:challenger/challenges/domain/challenge.dart';
import 'package:challenger/users/domain/logged_user_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'domain/challenge_api.dart';

class DetailChallengePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _DetailChallengePageState();
  }
}

class _DetailChallengePageState extends State<DetailChallengePage> {
  var title = "Challenge";

  Future<Challenge> _getChallenge(String id) async {
    final userStore = LoggedUserStore(await SharedPreferences.getInstance());
    final challengeApi = ChallengeApi('http://192.168.0.106:8080/api', userStore);
    return challengeApi.getChallengeById(id).then((challenge) {
      setState(() {
        title = challenge.name;
      });

      return challenge;
    });
  }

  Widget _challengeView(Challenge challenge) {
    return SafeArea(
        child: ListView(
            padding: EdgeInsets.symmetric(
                horizontal: 24.0
            ),
            children: <Widget>[
              SizedBox(height: 20.0),
              Text(
                challenge.description,
                style: Theme.of(context).textTheme.body1,
              ),
              SizedBox(height: 20.0),
              Text(
                "Difficulty",
                style: Theme.of(context).textTheme.body1,
              ),
              RatingBar(
                initialRating: challenge.difficulty,
                itemCount: 5,
                ignoreGestures: true,
                itemBuilder: (context, index) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
              )
            ]
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    final challengeId = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Center(
            child: FutureBuilder<Challenge>(
              future: _getChallenge(challengeId),
              builder: (context, snapshot) {
                if (snapshot.hasData)
                  return _challengeView(snapshot.data);
                if (snapshot.hasError)
                  return Text("${snapshot.error}");
                return CircularProgressIndicator();
              },
            )
        )
    );
  }
}