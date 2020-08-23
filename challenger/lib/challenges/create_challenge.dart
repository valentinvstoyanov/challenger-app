import 'package:challenger/challenges/challenge_validator.dart';
import 'package:flutter/material.dart';

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
  double _difficultySliderValue = 5;
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
                  "Starting difficulty: ${_difficultySliderValue.round()}",
                  style: Theme.of(context).textTheme.body1,
                ),
                Slider(
                  value: _difficultySliderValue,
                  min: 1,
                  max: 10,
                  divisions: 9,
                  label: _difficultySliderValue.round().toString(),
                  onChanged: (double value) {
                    setState(() {
                      _difficultySliderValue = value;
                    });
                  },
                ),
                SizedBox(height: 12.0,),
                RaisedButton(
                  child: _createButtonChild(),
                  elevation: 8.0,
                  onPressed: _isProgressing ? null : () => {
                    if (!_isProgressing && _formKey.currentState.validate()) {
                      _createChallenge(_nameController.text, _descriptionController.text, _difficultySliderValue)
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
