import 'dart:developer' as dev;

import 'package:challenger/users/domain/user.dart';
import 'package:challenger/users/domain/user_api.dart';
import 'package:challenger/users/user_validator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'domain/logged_user_store.dart';

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
      onPressed: _toggleNewPasswordVisibility,
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

  _changePassword(String oldPassword, String newPassword) async {
    _toggleProgress();
    final userStore = LoggedUserStore(await SharedPreferences.getInstance());
    final userApi = UserApi('http://192.168.0.106:8080/api', userStore);
    userApi.updateUser(userStore.getUser().id, UpdateUser(oldPassword: oldPassword, newPassword: newPassword))
        .then((user) => Navigator.pop(context))
        .catchError(_handleError)
        .whenComplete(() => { _toggleProgress()});
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
                            suffixIcon: _newPasswordVisibilityIcon()),
                        validator: validatePassword,
                        maxLength: 64,
                      ),
                      SizedBox(height: 16.0,),
                      RaisedButton(
                          child: _editButtonChild(),
                          elevation: 8.0,
                          onPressed: _isProgressing ? null : () => {
                            if (!_isProgressing && _formKey.currentState.validate()) {
                              _changePassword(_oldPasswordController.text, _newPasswordController.text)
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
