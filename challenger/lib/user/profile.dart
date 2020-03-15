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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 20.0, right: 10.0, top: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage('https://i1.wp.com/www.nationalreview.com/wp-content/uploads/2020/03/vladimir-putin-erdogan.jpg?fit=789%2C460&ssl=1'),
                    ),
                    FlatButton(
                        onPressed: () {},
                        child: Text("Edit Profile")
                    ),
                  ]
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                child: Text('Vladimir Putin',
                  style: Theme.of(context).textTheme.title,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left:20.0),
                child: Text('Moscow, RU',
                  style: Theme.of(context).textTheme.subtitle,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left:20.0, top: 20.0, right: 20.0),
                child: Text('Hello, I am Vlad. I love making cool photos, beautiful architecture and icecream.',
                  style: Theme.of(context).textTheme.body1,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text('1789',
                          style: Theme.of(context).textTheme.button,
                        ),
                        Text('Followers',
                          style: Theme.of(context).textTheme.overline,
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text('236',
                          style: Theme.of(context).textTheme.button,
                        ),
                        Text('Following',
                          style: Theme.of(context).textTheme.overline,
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text('990',
                          style: Theme.of(context).textTheme.button,
                        ),
                        Text('Challenges',
                          style: Theme.of(context).textTheme.overline,
                        )
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 25.0),
              Container(
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                height: 200.0,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    Container(
                      height: 200.0,
                      width: 200.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          image: DecorationImage(
                              image: AssetImage('assets/picone.jpeg'),
                              fit: BoxFit.cover
                          )
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Container(
                      height: 200.0,
                      width: 200.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          image: DecorationImage(
                              image: AssetImage('assets/pictwo.jpeg'),
                              fit: BoxFit.cover
                          )
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 10.0),
              Container(
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                height: 100.0,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    Container(
                      height: 100.0,
                      width: 100.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          image: DecorationImage(
                              image: AssetImage('assets/picthree.jpeg'),
                              fit: BoxFit.cover
                          )
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Container(
                      height: 100.0,
                      width: 100.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          image: DecorationImage(
                              image: AssetImage('assets/picfour.jpeg'),
                              fit: BoxFit.cover
                          )
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Container(
                      height: 100.0,
                      width: 100.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          image: DecorationImage(
                              image: AssetImage('assets/picfive.jpeg'),
                              fit: BoxFit.cover
                          )
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 10.0),
            ],
          )
        ],
      ),
    );
  }
}