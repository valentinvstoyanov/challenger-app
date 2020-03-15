import 'dart:developer' as dev;

import 'package:challenger/user/domain/user.dart';
import 'package:challenger/user/domain/user_api.dart';
import 'package:challenger/user/validator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';

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
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _isNewPasswordVisible = false;
  var _isOldPasswordVisible = false;
  var _isProgressing = false;
  String _emailError;
  String _usernameError;
  String _nameError;
  String _newPasswordError;
  String _oldPasswordError;

  _toggleOldPasswordVisibility() {
    setState(() {
      _isOldPasswordVisible = !_isOldPasswordVisible;
    });
  }

  _toggleNewPasswordVisibility() {
    setState(() {
      _isNewPasswordVisible = !_isNewPasswordVisible;
    });
  }

  _toggleProgress() {
    setState(() {
      _isProgressing = !_isProgressing;
    });
  }

  IconButton _newPasswordVisibilityIcon() {
    return IconButton(
      icon: Icon(_isNewPasswordVisible ? Icons.visibility : Icons.visibility_off),
      onPressed: _toggleOldPasswordVisibility,
    );
  }

  IconButton _oldPasswordVisibilityIcon() {
    return IconButton(
      icon: Icon(_isOldPasswordVisible ? Icons.visibility : Icons.visibility_off),
      onPressed: _toggleOldPasswordVisibility,
    );
  }

  Widget _editButtonChild() {
    return _isProgressing
        ? CircularProgressIndicator()
        : Text("Save");
  }

  _handleError(e, stackTrace) {
    dev.log("Edit profile error: ", error: e, stackTrace: stackTrace);
    Fluttertoast.showToast(msg: "Oops, something went wrong!");
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
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
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
                    SizedBox(height: 12.0,),
                    TextFormField(
                      obscureText: !_isOldPasswordVisible,
                      controller: _oldPasswordController,
                      decoration: InputDecoration(
                          labelText: "Password",
                          errorText: _oldPasswordError,
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.lock_outline),
                          suffixIcon: _oldPasswordVisibilityIcon()
                      ),
                      validator: validatePassword,
                      maxLength: 64,
                    ),
                    SizedBox(height: 12.0,),
                    TextFormField(
                      obscureText: !_isNewPasswordVisible,
                      controller: _newPasswordController,
                      decoration: InputDecoration(
                          labelText: "New password",
                          errorText: _newPasswordError,
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.lock_outline),
                          suffixIcon: _oldPasswordVisibilityIcon()
                      ),
                      validator: validatePassword,
                      maxLength: 64,
                    ),
                    SizedBox(height: 16.0,),
                    RaisedButton(
                        child: _editButtonChild(),
                        elevation: 8.0,
                        onPressed: _isProgressing ? null : () => {
                          if (!_isProgressing && _formKey.currentState.validate()) {
                           //edit profile
                          }
                        }
                    ),
                    SizedBox(height: 10.0),
                  ],
                )
            )
        )
    );
  }
}
