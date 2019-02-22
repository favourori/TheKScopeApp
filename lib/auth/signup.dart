import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kscope/auth/baseAuth.dart';
import 'package:kscope/auth/login.dart';
import 'package:kscope/home/home.dart';
import 'package:kscope/utils/color_utils.dart';
import 'package:kscope/utils/margin_utils.dart';

class Signup extends StatefulWidget {
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final BaseAuth auth = new Auth();
  final _formKey = GlobalKey<FormState>();
  String name;
  String email;
  String location;
  String password;
  String gender = "Gender";
  String confirmPassword;

  DateTime selectedDate = DateTime.now();

  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width * 0.9;
    final signupButton = ButtonTheme(
      minWidth: 150.0,
      height: 50.0,
      child: RaisedButton(
        onPressed: () => postData(),
        color: Colors.white,
        textColor: ColorUtils.primary,
        child: Text('Signup Now'),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
    );

    Future<Null> _selectDate(BuildContext context) async {
      final DateTime picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(1930, 8),
          lastDate: DateTime(2020));
      if (picked != null && picked != selectedDate)
        setState(() {
          selectedDate = picked;
        });
    }

    return Material(
      child: Theme(
          data: ThemeData(
              primaryColor: Colors.orange,
              inputDecorationTheme: new InputDecorationTheme(
                  labelStyle: new TextStyle(color: Colors.white))),
          child: Center(
            child: ListView(
              children: <Widget>[
                MarginUtils.mg10,
                Container(
                  height: 120,
                  child: Image(
                    image: AssetImage('assets/appicon/icon.png'),
                    width: 30.0,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Material(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          "Signup to Kscope",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w300),
                        )
                      ],
                    ),
                  ),
                ),
                MarginUtils.mg20,
                Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(30.0, 0, 30.0, 0),
                          child: TextFormField(
                            validator: (value) {
                              if (value.isNotEmpty) {
                                setState(() {
                                  name = value;
                                });
                              } else if (value.isEmpty) {
                                return "This field can't be left empty";
                              } else {
                                return "Please enter a Name";
                              }
                            },
                            style: TextStyle(color: Colors.redAccent),
                            decoration: InputDecoration(
                                labelText: 'Name',
                                labelStyle: TextStyle(fontSize: 14)),
                            keyboardType: TextInputType.text,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(30.0, 0, 30.0, 0),
                          child: TextFormField(
                            validator: (value) {
                              if (value.length > 4) {
                                setState(() {
                                  email = value;
                                });
                              } else if (value.isEmpty) {
                                return "This field can't be left empty";
                              } else {
                                return "Please enter a valid Email";
                              }
                            },
                            style: TextStyle(color: Colors.redAccent),
                            decoration: InputDecoration(
                                labelText: 'Email',
                                hintText: 'jondoe@mail.com',
                                labelStyle: TextStyle(fontSize: 14)),
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(30.0, 0, 30.0, 0),
                          child: TextFormField(
                            validator: (value) {
                              if (value.length > 2) {
                                setState(() {
                                  location = value;
                                });
                              } else if (value.isEmpty) {
                                return "This field can't be left empty";
                              } else {
                                return "Please enter a valid Location";
                              }
                            },
                            style: TextStyle(color: Colors.redAccent),
                            decoration: InputDecoration(
                                labelText: 'Location',
                                hintText: '',
                                labelStyle: TextStyle(fontSize: 14)),
                            keyboardType: TextInputType.text,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(30.0, 0, 30.0, 0),
                          child: TextFormField(
                            validator: (value) {
                              if (value.isNotEmpty && value.length >= 6) {
                                setState(() {
                                  password = value;
                                });
                              } else if (value.isEmpty) {
                                return "This field can't be left empty";
                              } else {
                                return "Password must be at least 6 characters";
                              }
                            },
                            style: TextStyle(color: Colors.redAccent),
                            decoration: InputDecoration(
                                labelText: 'Password',
                                labelStyle: TextStyle(fontSize: 14)),
                            keyboardType: TextInputType.text,
                            obscureText: true,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(30.0, 0, 30.0, 0),
                          child: TextFormField(
                            validator: (value) {
                              if (value.isNotEmpty && value == password) {
                                setState(() {
                                  confirmPassword = value;
                                });
                              } else if (value.isEmpty) {
                                return "This field can't be left empty";
                              } else {
                                return "Passwords don't match";
                              }
                            },
                            style: TextStyle(color: Colors.redAccent),
                            decoration: InputDecoration(
                                labelText: 'Confirm Password',
                                labelStyle: TextStyle(fontSize: 14)),
                            obscureText: true,
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.fromLTRB(30.0, 20, 30.0, 0),
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: new DropdownButton<String>(
                                    hint: new Text(gender),
                                    items: <String>[
                                      'Prefer Not to Say',
                                      'Male',
                                      'Female'
                                    ].map((String value) {
                                      return new DropdownMenuItem<String>(
                                        value: value,
                                        child: new Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (_) {
                                      print(_);
                                      setState(() {
                                        gender = _;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            )),
                        Padding(
                            padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 45,
                              child: RaisedButton(
                                color: ColorUtils.primary,
                                onPressed: () {
                                  _selectDate(context);
                                },
                                child: Text(
                                  "Select BirthDay",
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )),
                        MarginUtils.mg20,
                        Container(
                            child: isLoading
                                ? Center(
                                    child: LinearProgressIndicator(),
                                  )
                                : signupButton),
                        Padding(
                          padding: EdgeInsets.only(top: 30),
                          child: Material(
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Login(),
                                  ),
                                );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    "Not a new User? Login",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  HMarginUtils.mg10,
                                  Text(
                                    "Here",
                                    style: TextStyle(color: Colors.orange),
                                  ),
                                  HMarginUtils.mg10,
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ))
              ],
            ),
          )),
    );
  }

  postData() async {
    String userId = "";
    if (_formKey.currentState.validate() &&
        // selectedDate.year != null &&
        !gender.contains("en")) {
      setState(() {
        isLoading = true;
      });
      try {
        userId = await auth.signUp(email, password);

        saveData(name, email, password, location, gender,
            selectedDate.toLocal(), userId);

        print('Signed in: $userId');

        if (userId.length > 0 && userId != null) {}
      } catch (e) {
        print('Error: $e');
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  saveData(String name, String email, String password, String location,
      String gender, DateTime birthday, userId) async {
    try {
      Firestore.instance.runTransaction((transaction) async {
        await transaction
            .set(Firestore.instance.collection("users").document(userId), {
          'name': name,
          'email': email,
          'location': location,
          'gender': gender,
          'birthday': DateFormat("MMMM d y").format(birthday).toString(),
          'userId': userId,
          'imageUrl': ""
        });
      });
      FirebaseUser user = await auth.getCurrentUser();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Home(userId: userId, user: user),
        ),
      );
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }
}
