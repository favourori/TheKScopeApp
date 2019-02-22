import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kscope/auth/baseAuth.dart';
import 'package:kscope/auth/signup.dart';
import 'package:kscope/home/home.dart';
import 'package:kscope/utils/color_loader.dart';
import 'package:kscope/utils/color_utils.dart';
import 'package:kscope/utils/margin_utils.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => new _LoginState();
}

class _LoginState extends State<Login> {
  final BaseAuth auth = new Auth();
  final _formKey = GlobalKey<FormState>();
  String email;
  String password;
  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    bool isEmail(String em) {
      String p =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regExp = new RegExp(p);
      return regExp.hasMatch(em);
    }

    final loginButton = ButtonTheme(
      minWidth: 150.0,
      height: 50.0,
      child: RaisedButton(
        onPressed: () => postData(),
        color: Colors.white,
        textColor: Theme.of(context).primaryColor,
        child: Text('Login'),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
    );
    return Material(
      child: Theme(
          data: ThemeData(
              primaryColor: Colors.white,
              accentColor: Colors.white,
              hintColor: Colors.white,
              inputDecorationTheme: new InputDecorationTheme(
                  labelStyle: new TextStyle(color: Colors.white))),
          child: Container(
            color: ColorUtils.primary,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  MarginUtils.mg30,
                  Image(
                    image: AssetImage('assets/appicon/icon.png'),
                    width: 110.0,
                  ),
                  MarginUtils.mg30,
                  Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(30.0, 0, 30.0, 0),
                            child: TextFormField(
                              validator: (value) {
                                if (isEmail(value)) {
                                  setState(() {
                                    email = value;
                                  });
                                } else if (value.isEmpty) {
                                  return "This field can't be left empty";
                                } else {
                                  return "Email is Invalid";
                                }
                              },
                              style: TextStyle(color: Colors.amber),
                              decoration: InputDecoration(
                                  labelText: 'Email',
                                  labelStyle: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      decorationColor: Colors.white)),
                              //  keyboardType: TextInputType.number,
                            ),
                          ),
                          MarginUtils.mg30,
                          Padding(
                            padding: EdgeInsets.fromLTRB(30.0, 0, 30.0, 0),
                            child: TextFormField(
                              validator: (value) {
                                if (value.length > 4) {
                                  setState(() {
                                    password = value;
                                  });
                                } else if (value.isEmpty) {
                                  return "This field can't be left empty";
                                } else {
                                  return "Password is Invalid";
                                }
                              },
                              style: TextStyle(color: Colors.amber),
                              decoration: InputDecoration(
                                  labelText: 'Password',
                                  labelStyle: TextStyle(fontSize: 14)),
                              keyboardType: TextInputType.text,
                              obscureText: true,
                            ),
                          ),
                          MarginUtils.mg20,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(right: 30, bottom: 30),
                                child: InkWell(
                                  onTap: () {
                                    /* Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Signup(),
                                      ),
                                    ); */
                                  },
                                  child: Text(
                                    "Forgot Password?",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              )
                            ],
                          ),
                          MarginUtils.mg20,
                          Container(
                              child: isLoading
                                  ? Center(
                                      child:
                                          ColorLoader(radius: 20, dotRadius: 5),
                                    )
                                  : loginButton),
                          Padding(
                            padding: EdgeInsets.only(top: 30),
                            child: Material(
                              color: ColorUtils.primary,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Signup(),
                                    ),
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                      "New User? Signup",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    HMarginUtils.mg10,
                                    Text(
                                      "Here",
                                      style: TextStyle(color: Colors.orange),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ))
                ],
              ),
            ),
          )),
    );
  }

  postData() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      String userId = "";
      try {
        userId = await auth.signIn(email, password);
        print('Signed in: $userId');

        if (userId.length > 0 && userId != null) {
          FirebaseUser user = await auth.getCurrentUser();

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Home(userId: userId, user: user),
            ),
          );
        }
      } catch (e) {
        print('Error: $e');
        setState(() {
          isLoading = false;
        });
        if (e.toString().contains("invalid")) {
          showDialog(
              context: context,
              builder: (_) => new AlertDialog(
                    title: new Text("Error"),
                    content: new Text("This password is invalid"),
                  ));
        }
      }
    }
  }
}
