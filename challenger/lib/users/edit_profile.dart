import 'dart:developer' as dev;

import 'package:challenger/users/change_password.dart';
import 'package:challenger/users/domain/user.dart';
import 'package:challenger/users/domain/user_api.dart';
import 'package:challenger/users/user_validator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'domain/logged_user_store.dart';

class EditProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _EditProfilePageState();
  }
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _isProgressing = false;
  String _emailError;
  String _usernameError;
  String _nameError;

  _toggleProgress() {
    setState(() {
      _isProgressing = !_isProgressing;
    });
  }

  Widget _editButtonChild() {
    return _isProgressing ? CircularProgressIndicator() : Text("Save");
  }


  _ediProfile(String email, String username, String name) async {
    _toggleProgress();
    final userStore = LoggedUserStore(await SharedPreferences.getInstance());
    final userApi = UserApi('http://192.168.0.106:8080/api', userStore);
    userApi.updateUser(userStore.getUser().id, UpdateUser(email: email, username: username, name: name))
        .then((user) => {
          userStore.saveUser(user),
          Navigator.pop(context, true)
        })
        .catchError(_handleError)
        .whenComplete(() => { _toggleProgress()});
  }

  _handleError(e, stackTrace) {
    dev.log("Edit profile error: ", error: e, stackTrace: stackTrace);
    Fluttertoast.showToast(msg: "Oops, something went wrong!");
  }

  _updateUserInfo(User user) {
    setState(() {
      _emailController.text = user.email;
      _usernameController.text = user.username;
      _nameController.text = user.name;
    });
  }

  _populateViews() async {
    final userStore = LoggedUserStore(await SharedPreferences.getInstance());
    final userApi = UserApi('http://192.168.0.106:8080/api', userStore);
    userApi.getLoggedUser()
        .then((user) => _updateUserInfo(user))
        .catchError((e, stackTrace) {
          dev.log("Failed to get current user by id", error: e, stackTrace: stackTrace);
          Fluttertoast.showToast(msg: "Oops, something went wrong!");
        });
  }

  @override
  void initState() {
    super.initState();
    _populateViews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Edit profile"),
        ),
        body: SafeArea(
            child: Form(
                key: _formKey,
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 16.0),
                      child: Center(
                        child: CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage('https://i1.wp.com/www.nationalreview.com/wp-content/uploads/2020/03/vladimir-putin-erdogan.jpg?fit=789%2C460&ssl=1'),
                        ),
                      ),
                    ),
                    SizedBox(height: 12.0),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                          labelText: "Email",
                          errorText: _emailError,
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.email)
                      ),
                      validator: validateEmail,
                    ),
                    SizedBox(height: 12.0,),
                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                          labelText: "Username",
                          errorText: _usernameError,
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person_outline)
                      ),
                      validator: validateUsername,
                      maxLength: 64,
                    ),
                    SizedBox(height: 12.0,),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                          labelText: "Name",
                          errorText: _nameError,
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person)
                      ),
                      validator: validateName,
                      maxLength: 128,
                    ),
                    SizedBox(height: 16.0,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        FlatButton(
                          child: Text("Change password"),
                          onPressed: () {
                            Navigator.pushNamed(context, '/changePassword');
                          },
                        ),
                        RaisedButton(
                            child: _editButtonChild(),
                            elevation: 8.0,
                            onPressed: _isProgressing ? null : () => {
                              if (!_isProgressing && _formKey.currentState.validate()) {
                                _ediProfile(_emailController.text, _usernameController.text, _nameController.text)
                              }
                            }
                        ),
                      ],
                    ),
                  ],
                )
            )
        )
    );
  }
}
