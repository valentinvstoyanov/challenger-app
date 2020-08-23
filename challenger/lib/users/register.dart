import 'dart:developer' as dev;

import 'package:challenger/users/domain/logged_user_store.dart';
import 'package:challenger/users/domain/user.dart';
import 'package:challenger/users/domain/user_api.dart';
import 'package:challenger/users/user_validator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _RegisterPageState();
  }
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _isPasswordVisible = false;
  var _isProgressing = false;
  String _emailError;
  String _usernameError;
  String _nameError;
  String _passwordError;

  _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  _toggleProgress() {
    setState(() {
      _isProgressing = !_isProgressing;
    });
  }

  IconButton _passwordVisibilityIcon() {
    return IconButton(
      icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
      onPressed: _togglePasswordVisibility,
    );
  }

  Widget _registerButtonChild() {
    return _isProgressing
        ? CircularProgressIndicator()
        : Text("SIGN UP");
  }

  _register(String email, String username, String name, String password) async {
    _toggleProgress();
    final userApi = UserApi('http://192.168.0.106:8080/api', LoggedUserStore(await SharedPreferences.getInstance()));
    userApi.registerUser(CreateUserRequest(email: email, name: name, password: password, username: username))
        .then((user) => Navigator.pushNamedAndRemoveUntil(context, '/login', (Route<dynamic> route) => false))
        .catchError(_handleError)
        .whenComplete(() => { _toggleProgress()});
  }

  _handleError(e, stackTrace) {
    dev.log("Registration error: ", error: e, stackTrace: stackTrace);
    Fluttertoast.showToast(msg: "Oops, registration failed!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                children: <Widget>[
                  SizedBox(height: 20.0),
                  Text(
                    "Challenger",
                    style: Theme.of(context).textTheme.display1,
                  ),
                  SizedBox(height: 30.0),
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
                  SizedBox(height: 12.0,),
                  TextFormField(
                    obscureText: !_isPasswordVisible,
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: "Password",
                      errorText: _passwordError,
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock_outline),
                      suffixIcon: _passwordVisibilityIcon()
                    ),
                    validator: validatePassword,
                    maxLength: 64,
                  ),
                  SizedBox(height: 16.0,),
                  RaisedButton(
                      child: _registerButtonChild(),
                      elevation: 8.0,
                      onPressed: _isProgressing ? null : () => {
                        if (!_isProgressing && _formKey.currentState.validate()) {
                          _register(_emailController.text, _usernameController.text, _nameController.text, _passwordController.text)
                        }
                      }
                  ),
                  FlatButton(
                      child: Text('Already registered? Sign in'),
                      onPressed: () => { Navigator.pop(context) }
                  )
                ],
              )
            )
        )
    );
  }
}
