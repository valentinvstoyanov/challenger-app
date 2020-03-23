import 'dart:developer' as dev;

import 'package:challenger/user/domain/user.dart';
import 'package:challenger/user/domain/user_api.dart';
import 'package:challenger/user/validator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _ChangePasswordPage();
  }
}

class _ChangePasswordPage extends State<ChangePasswordPage> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _isNewPasswordVisible = false;
  var _isOldPasswordVisible = false;
  var _isProgressing = false;
  String _newPasswordError;
  String _oldPasswordError;

  _toggleProgress() {
    setState(() {
      _isProgressing = !_isProgressing;
    });
  }

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
    return _isProgressing ? CircularProgressIndicator() : Text("Save");
  }

  _handleError(e, stackTrace) {
    dev.log("Password change error: ", error: e, stackTrace: stackTrace);
    Fluttertoast.showToast(msg: "Oops, something went wrong!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Change password"),
        ),
        body: SafeArea(
            child: Form(
                key: _formKey,
                child: ListView(
                    padding: EdgeInsets.all(20.0),
                    children: <Widget>[
                      TextFormField(
                        obscureText: !_isOldPasswordVisible,
                        controller: _oldPasswordController,
                        decoration: InputDecoration(
                            labelText: "Current password",
                            errorText: _oldPasswordError,
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.lock_outline),
                            suffixIcon: _oldPasswordVisibilityIcon()),
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
                            suffixIcon: _oldPasswordVisibilityIcon()),
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
                    ]
                )
            )
        )
    );
  }
}
