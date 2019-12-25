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

  _login(String usernameOrEmail, String password) {
    Navigator.pop(context);
  }

  Widget _buildField(String label, TextEditingController controller, String Function(String) validator, {bool isPassword = false, int maxLength}) {
    return Theme(
      data: Theme.of(context),
      child: TextFormField(
        obscureText: isPassword,
        controller: controller,
        decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
        validator: validator,
        maxLength: maxLength,
      ),
    );
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
              _buildField("Email or username", _emailOrUsernameController, validateEmail),
              SizedBox(height: 12.0,),
              _buildField("Password", _passwordController, validatePassword, isPassword: true, maxLength: 64),
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
