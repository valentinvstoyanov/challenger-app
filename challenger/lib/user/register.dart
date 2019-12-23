import 'dart:developer' as dev;

import 'package:challenger/api_error.dart';
import 'package:challenger/user/domain/user.dart';
import 'package:challenger/user/domain/user_api.dart';
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

  Widget _buildField(String label, TextEditingController controller, {bool isPassword = false}) {
    return Theme(
      data: Theme.of(context),
      child: TextField(
        obscureText: isPassword,
        controller: controller,
        decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
      ),
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
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              children: <Widget>[
                SizedBox(height: 40.0),
                Text(
                  "Challenger",
                  style: Theme.of(context).textTheme.display1,
                ),
                SizedBox(height: 50.0),
                _buildField("Email", _emailController),
                SizedBox(height: 12.0,),
                _buildField("Username", _usernameController),
                SizedBox(height: 12.0,),
                _buildField("Name", _nameController),
                SizedBox(height: 12.0,),
                _buildField("Password", _passwordController, isPassword: true),
                SizedBox(height: 16.0,),
                RaisedButton(
                  child: Text('Sign up'),
                  elevation: 8.0,
                  onPressed: () => { _register(_emailController.text, _usernameController.text, _nameController.text, _passwordController.text)}
                ),
                FlatButton(
                    child: Text('Already registered? Sign in'),
                    onPressed: () => { Navigator.pop(context) }
                )
              ],
            )
        )
    );
  }
}
