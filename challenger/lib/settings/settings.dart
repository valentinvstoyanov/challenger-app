import 'dart:developer' as dev;

import 'package:challenger/user/domain/token_store.dart';
import 'package:challenger/user/login.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _SettingsPageState();
  }
}

class _SettingsPageState extends State<SettingsPage> {
  void _logout() async {
    TokenStore(await SharedPreferences.getInstance())
        .clearToken()
        .catchError((e, stackTrace) {
          dev.log("Log out error", error: e, stackTrace: stackTrace);
          Fluttertoast.showToast(msg: "Oops, something went wrong!");
        })
        .whenComplete(() => Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text("Log out"),
            leading: Icon(Icons.exit_to_app),
            onTap: _logout,
          )
        ],
      ),
    );
  }
}