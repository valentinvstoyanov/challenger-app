import 'dart:developer' as dev;

import 'package:challenger/users/domain/logged_user_store.dart';
import 'package:challenger/users/domain/user.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:challenger/users/register.dart';
import 'package:challenger/users/user_validator.dart';
import 'package:flutter/material.dart';

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

  _login(String emailOrUsername, String password) async {
    _toggleProgress();
    final userApi = UserApi('http://192.168.0.106:8080/api', LoggedUserStore(await SharedPreferences.getInstance()));
    userApi.loginUser(LoginUserRequest(emailOrUsername: emailOrUsername, password: password))
        .then((success) {
          if (success) {
            Navigator.pushNamedAndRemoveUntil(context, '/', (Route<dynamic> route) => false);
          } else {
            throw("Failed to login.");
          }
        })
        .catchError(_handleError)
        .whenComplete(() => { _toggleProgress() });
  }

  _handleError(e, stackTrace) {
    dev.log("Login error: ", error: e, stackTrace: stackTrace);
    Fluttertoast.showToast(msg: "Oops, login failed!");
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
                  onPressed: () => {Navigator.pushNamed(context, '/register')},
              )
            ],
          )
        ),
      )
    );
  }
}
