import 'dart:developer' as dev;

import 'package:challenger/api_error.dart';
import 'package:challenger/user/domain/user.dart';
import 'package:challenger/user/domain/user_api.dart';
import 'package:challenger/user/validator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

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

  _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  IconButton _passwordVisibilityIcon() {
    return IconButton(
      icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
      onPressed: _togglePasswordVisibility,
    );
  }

  _register(String email, String username, String name, String password) {
    final client = Client();
    final userApi = UserApi(client, 'http://192.168.0.106:8080/api');
    userApi.registerUser(CreateUserRequest(email: email, name: name, password: password, username: username))
      .then((user) => _emailController.text = user.toString())
      .catchError(_handleApiError, test: (e) => e is ApiError)
      .catchError(_handleException, test: (e) => e is Exception);
  }

  _handleApiError(apiError) {
    //TODO: show errors

  }

  _handleException(e, stackTrace) {
    dev.log("Registration error: ", error: e, stackTrace: stackTrace);
    //TODO: show unexpected error
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
                    decoration: InputDecoration(labelText: "Email", border: OutlineInputBorder(), prefixIcon: Icon(Icons.email)),
                    validator: validateEmail,
                  ),
                  SizedBox(height: 12.0,),
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(labelText: "Username", border: OutlineInputBorder(), prefixIcon: Icon(Icons.person_outline)),
                    validator: validateUsername,
                    maxLength: 64,
                  ),
                  SizedBox(height: 12.0,),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: "Name", border: OutlineInputBorder(), prefixIcon: Icon(Icons.person)),
                    validator: validateName,
                    maxLength: 128,
                  ),
                  SizedBox(height: 12.0,),
                  TextFormField(
                    obscureText: !_isPasswordVisible,
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock_outline),
                      suffixIcon: _passwordVisibilityIcon()
                    ),
                    validator: validatePassword,
                    maxLength: 64,
                  ),
                  SizedBox(height: 16.0,),
                  RaisedButton(
                      child: Text('Sign up'),
                      elevation: 8.0,
                      onPressed: () => {
                        if (_formKey.currentState.validate()) {
                          _register(_emailController.text, _usernameController.text, _nameController.text,
                              _passwordController.text)
                        }
                      }
                  ),
                  FlatButton(
                      child: Text('Already registered? Sign in'),
                      onPressed: () => { Navigator.pop(context)}
                  )
                ],
              )
            )
        )
    );
  }
}
