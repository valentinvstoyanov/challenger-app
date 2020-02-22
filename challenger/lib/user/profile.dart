import 'dart:developer' as dev;

import 'package:challenger/settings/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';

import 'domain/user.dart';
import 'domain/user_api.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _ProfilePageState();
  }
}

class _ProfilePageState extends State<ProfilePage> {
  User user;
  var id = "";
  final client = Client();

  _getUser() {
    final userApi = UserApi(client, 'http://192.168.0.106:8080/api');
    userApi.getUserById(id).then((user) {
      setState(() {
        this.user = user;
      });
    }).catchError((e, stackTrace) {
      dev.log("Failed to get current user by id", error: e, stackTrace: stackTrace);
      Fluttertoast.showToast(msg: "Oops, something went wrong!");
    });
  }

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  @override
  void dispose() {
    super.dispose();
    client.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user == null ? "Profile" : user.username),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage()));
            },
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Text(user == null ? "" : user.username)
        ],
      ),
    );
  }
}