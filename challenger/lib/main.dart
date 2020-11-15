import 'package:challenger/challenges/create_challenge.dart';
import 'package:challenger/challenges/detail_challenge.dart';
import 'package:challenger/challenges/list_challenges.dart';
import 'package:challenger/colors.dart';
import 'package:challenger/settings/settings.dart';
import 'package:challenger/users/change_password.dart';
import 'package:challenger/users/edit_profile.dart';
import 'package:challenger/users/login.dart';
import 'package:challenger/users/profile.dart';
import 'package:challenger/users/register.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final _appName = 'Challenger';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _appName,
      theme: _buildTheme(_buildColorScheme(), _buildTextTheme()),
      //home: MyHomePage(),
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(),
        '/editProfile': (context) => EditProfilePage(),
        '/changePassword': (context) => ChangePasswordPage(),
        '/settings': (context) => SettingsPage(),
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/detailChallenge': (context) => DetailChallengePage(),
      },
    );
  }

  ThemeData _buildTheme(ColorScheme colorScheme, TextTheme textTheme) {
    return ThemeData(
      colorScheme: colorScheme,
      primaryColor: colorScheme.primary,
      accentColor: colorScheme.secondary,
      backgroundColor: colorScheme.background,
      scaffoldBackgroundColor: colorScheme.background,
      buttonTheme: ButtonThemeData(
        textTheme: ButtonTextTheme.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: colorScheme.secondary, foregroundColor: colorScheme.onSecondary),
      inputDecorationTheme: InputDecorationTheme(border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
      cardTheme: CardTheme(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
      dividerColor: kChallengerDivider,
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      accentTextTheme: textTheme
    );
  }

  ColorScheme _buildColorScheme() {
    return ColorScheme.light(
      primary: kChallengerBlue,
      primaryVariant: kChallengerDarkBlue,
      secondary: kChallengerYellow,
      secondaryVariant: kChallengerLightYellow,
      surface: kChallengerBackground,
      background: kChallengerBackground,
      error: kChallengerError,
      onPrimary: kChallengerWhite,
      onSecondary: kChallengerBlack,
      onSurface: kChallengerBlack,
      onBackground: kChallengerBlack,
      onError: kChallengerBlack,
      brightness: Brightness.light
    );
  }

  TextTheme _buildTextTheme() {
    return TextTheme(
      display4: GoogleFonts.raleway(fontSize: 98),
      display3: GoogleFonts.raleway(fontSize: 61),
      display2: GoogleFonts.raleway(fontSize: 49),
      display1: GoogleFonts.raleway(fontSize: 35),
      headline: GoogleFonts.raleway(fontSize: 24),
      title: GoogleFonts.raleway(fontSize: 20),
      subhead: GoogleFonts.raleway(fontSize: 16),
      body2: GoogleFonts.raleway(fontSize: 17),
      body1: GoogleFonts.raleway(fontSize: 15),
      caption: GoogleFonts.raleway(fontSize: 13),
      button: GoogleFonts.raleway(fontSize: 15),
      subtitle: GoogleFonts.raleway(fontSize: 14),
      overline: GoogleFonts.raleway(fontSize: 11),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _getChild() {
    if (_selectedIndex == 0) {
      return ListChallengesPage();
    }

    if (_selectedIndex == 1) {
      return CreateChallengePage();
    }

    if (_selectedIndex == 2) {
      return ProfilePage();
    }

    return ListView.builder(
        itemCount: 0,
        itemBuilder: (context, index) => ListTile(title: Text(""),)
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
          child: _getChild()
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/login');
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            title: Text('School'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('Profile'),
          ),
        ],
        currentIndex: _selectedIndex,
       // selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
