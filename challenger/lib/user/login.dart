import 'dart:developer' as dev;

import 'package:challenger/user/domain/token_store.dart';
import 'package:challenger/user/domain/user.dart';
import 'package:http/http.dart';
import 'package:challenger/user/register.dart';
import 'package:challenger/user/validator.dart';
import 'package:flutter/material.dart';

import 'package:challenger/api_error.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'domain/user_api.dart';


class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  final _emailOrUsernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _isPasswordVisible = false;
  var _isProgressing = false;

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

  _login(String emailOrUsername, String password) {
    _toggleProgress();
    final client = Client();
    final userApi = UserApi(client, 'http://192.168.0.106:8080/api');

    userApi.loginUser(LoginUserRequest(emailOrUsername: emailOrUsername, password: password))
        .then((jwt) => _saveJwt(jwt))
        .catchError(_handleApiError, test: (e) => e is ApiException)
        .catchError(_handleException, test: (e) => e is Exception)
        .whenComplete(() => {
          _toggleProgress(),
          Navigator.pop(context)
        });
  }

  Future<bool> _saveJwt(String jwt) async {
    dev.log("JWT Token: " + jwt);
    return TokenStore(await SharedPreferences.getInstance()).saveToken(jwt);
  }

  _handleApiError(e) {
    dev.log("Login api exception: ", error: e);
    //TODO: show errors in each text field
  }

  _handleException(e, stackTrace) {
    dev.log("Registration error: ", error: e, stackTrace: stackTrace);
    //TODO: show unexpected error
  }

  @override
  void dispose() {
    _emailOrUsernameController.dispose();
    _passwordController.dispose();
    super.dispose();
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
              SizedBox(height: 80.0),
              Text(
                "Challenger",
                style: Theme.of(context).textTheme.display1,
              ),
              SizedBox(height: 100.0),
              TextFormField(
                controller: _emailOrUsernameController,
                decoration: InputDecoration(
                  labelText: "Email or username",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.perm_identity)
                ),
                validator: validateEmailOrUsername,
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
                child: Text('SIGN IN',),
                elevation: 8.0,
                onPressed: _isProgressing ? null : () => {
                  if (!_isProgressing && _formKey.currentState.validate()) {
                    _login(_emailOrUsernameController.text, _passwordController.text)
                  }
                },
              ),
              FlatButton(
                  child: Text("Don't have an account? Create one"),
                  onPressed: () => {Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage()))},
              )
            ],
          )
        ),
      )
    );
  }
}
