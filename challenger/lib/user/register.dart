import 'dart:developer';

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

  @override
  Widget build(BuildContext context) {
    final fieldStyle = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

    final emailField = TextField(
      style: fieldStyle,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Email",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0))),
      controller: _emailController,
    );

    final usernameField = TextField(
      style: fieldStyle,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Username",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0))),
      controller: _usernameController,
    );

    final nameField = TextField(
      style: fieldStyle,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Name",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0))),
      controller: _nameController,
    );

    final passwordField = TextField(
      obscureText: true,
      style: fieldStyle,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Password",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0))),
      controller: _passwordController,
    );

    final registerButton = Material(
      elevation: 4.0,
      borderRadius: BorderRadius.circular(2.0),
      color: Colors.amber,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          final client = Client();
          final userApi = UserApi(client, 'http://192.168.0.106:8080/api');
          userApi.registerUser(CreateUserRequest(email: _emailController.text,
              name: _nameController.text,
              password: _passwordController.text,
              username: _usernameController.text))
              .then((user) => _emailController.text = user.toString())
              .catchError((e) => { log("Registration error: ", error: e)});
        },
        child: Text("Sign up",
            textAlign: TextAlign.center,
            style: fieldStyle.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    final loginButton = Material(
      elevation: 4.0,
      borderRadius: BorderRadius.circular(2.0),
      color: Colors.deepOrangeAccent,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text("Sign in",
            textAlign: TextAlign.center,
            style: fieldStyle.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
        body: Center(
      child: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Challenger',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 42.0,
                  ),
                ),
                SizedBox(height: 32.0),
                emailField,
                SizedBox(height: 16.0),
                usernameField,
                SizedBox(height: 16.0),
                nameField,
                SizedBox(height: 16.0),
                passwordField,
                SizedBox(
                  height: 20.0,
                ),
                registerButton,
                SizedBox(
                  height: 20.0,
                ),
                loginButton,
                SizedBox(
                  height: 15.0,
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
