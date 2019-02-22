import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kscope/auth/baseAuth.dart';
import 'package:kscope/auth/login.dart';
import 'package:kscope/home/home.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    return new MaterialApp(
        title: 'The Kscope',
        debugShowCheckedModeBanner: false,
        theme: new ThemeData(
          primaryColor: const Color(0xFF292e42),
        ),
        home: new Splash(),
        routes: {
          '/login': (BuildContext context) => Login(),
        });
  }
}

class Splash extends StatefulWidget {
  @override
  SplashState createState() => new SplashState();
}

// SingleTickerProviderStateMixin is used for animation
class SplashState extends State<Splash> {
  Timer _timer;
  BaseAuth auth = new Auth();

//LOADING DATA FOR PROFILES

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
  statusBarIconBrightness: Brightness.light
));

    _runLoad();
  }

  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 37.0,
        child: Image.asset('assets/appicon/icon.gif'),
      ),
    );

    return new Scaffold(
      // Appbar
      // Set the TabBar view as the body of the Scaffold
      body: Container(
        color: Theme.of(context).primaryColor,
        child: new Center(child: logo),
      ),
    );
  }

  _runLoad() async {
    await Future.delayed(const Duration(seconds: 10));
    FirebaseUser user = await auth.getCurrentUser();
    print('Signed in: $user');

    if (user != null) {
      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Home(userId: user.uid, user: user),
        ),
      );
    } else {
      Navigator.pop(context);
      Navigator.pushReplacementNamed(context, "/login");
    }
  }
}
