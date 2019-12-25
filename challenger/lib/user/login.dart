import 'package:challenger/user/register.dart';
import 'package:challenger/user/validator.dart';
import 'package:flutter/material.dart';

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

  _login(String usernameOrEmail, String password) {
    Navigator.pop(context);
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
                validator: validateEmail,
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
                onPressed: () => {
                  if (_formKey.currentState.validate()) {
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
