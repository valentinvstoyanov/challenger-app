import 'package:challenger/user/register.dart';
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

  _login(String usernameOrEmail, String password) {
    Navigator.pop(context);
  }

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

  @override
  void dispose() {
    super.dispose();
    _emailOrUsernameController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        children: <Widget>[
          SizedBox(height: 80.0),
          Text(
            "Challenger",
            style: Theme.of(context).textTheme.display1,
          ),
          SizedBox(height: 100.0),
          _buildField("Email or username", _emailOrUsernameController),
          SizedBox(
            height: 12.0,
          ),
          _buildField("Password", _passwordController, isPassword: true),
          SizedBox(
            height: 16.0,
          ),
          RaisedButton(
            child: Text(
              "SIGN IN",
            ),
            elevation: 8.0,
            onPressed: () => {_login(_emailOrUsernameController.text, _passwordController.text)},
          ),
          FlatButton(
              onPressed: () => {Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage()))},
              child: Text("Don't have an account? Create one"))
        ],
      )),
    );
  }
}
