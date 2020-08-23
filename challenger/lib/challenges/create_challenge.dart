import 'dart:developer' as dev;

import 'package:challenger/challenges/challenge_validator.dart';
import 'package:challenger/challenges/domain/challenge.dart';
import 'package:challenger/users/domain/logged_user_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'domain/challenge_api.dart';

class CreateChallengePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _CreateChallengePageState();
  }
}

class _CreateChallengePageState extends State<CreateChallengePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  double _difficultyValue = 1;
  var _isProgressing = false;

  _toggleProgress() {
    setState(() {
      _isProgressing = !_isProgressing;
    });
  }

  Widget _createButtonChild() {
    return _isProgressing ? CircularProgressIndicator() : Text("Create");
  }

  _createChallenge(String name, String description, double difficulty) async {
    _toggleProgress();
    final userStore = LoggedUserStore(await SharedPreferences.getInstance());
    final challengeApi = ChallengeApi('http://192.168.0.106:8080/api', userStore);
    final challengeRequest = CreateChallenge(name: name, description: description, difficulty: difficulty, createdBy: userStore.getUserId());
    challengeApi.createChallenge(challengeRequest).then((challenge) => {
      //TODO: maybe navigate to the created challenge detail page.
      Fluttertoast.showToast(msg: "Challenge successfully created!"),
    }).catchError(_handleError)
      .whenComplete(() => { _toggleProgress()});
  }

  _handleError(e, stackTrace) {
    dev.log("Create challenge error: ", error: e, stackTrace: stackTrace);
    Fluttertoast.showToast(msg: "Oops, something went wrong!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Create challenge"),
        ),
        body: SafeArea(
          child: Form(
           key: _formKey,
            child: ListView(
              padding: EdgeInsets.symmetric(
                horizontal: 24.0
              ),
              children: <Widget>[
                SizedBox(height: 20.0),
                TextFormField(
                  controller: _nameController,
                  maxLength: 64,
                  decoration: InputDecoration(
                      labelText: "Name",
                      border: OutlineInputBorder(),
                  ),
                  validator: validateName,
                ),
                SizedBox(height: 12.0,),
                TextFormField(
                  controller: _descriptionController,
                  maxLength: 256,
                  decoration: InputDecoration(
                    labelText: "Description",
                    border: OutlineInputBorder(),
                  ),
                  validator: validateDescription,
                ),
                SizedBox(height: 12.0,),
                Text(
                  "Starting difficulty",
                  style: Theme.of(context).textTheme.body1,
                ),
                RatingBar(
                  initialRating: _difficultyValue,
                  itemCount: 5,
                  allowHalfRating: true,
                  minRating: 0,
                  maxRating: 5,
                  onRatingUpdate: (rating) => _difficultyValue = rating,
                  itemBuilder: (context, index) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                ),
                SizedBox(height: 12.0,),
                RaisedButton(
                  child: _createButtonChild(),
                  elevation: 8.0,
                  onPressed: _isProgressing ? null : () => {
                    if (!_isProgressing && _formKey.currentState.validate()) {
                      _createChallenge(_nameController.text, _descriptionController.text, _difficultyValue)
                    }
                  },
                ),
              ]
            )
          )
        )
    );
  }
}
