import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kscope/auth/baseAuth.dart';
import 'package:kscope/functions/drawer.dart';
import 'package:kscope/utils/color_utils.dart';
import 'package:kscope/utils/margin_utils.dart';
import 'package:kscope/models/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfile extends StatefulWidget {
  final ProfileModel profileData;

  EditProfile({Key key, @required this.profileData}) : super(key: key);
  _EditProfileState createState() =>
      _EditProfileState(profileData: profileData);
}

class _EditProfileState extends State<EditProfile> {
  final BaseAuth auth = new Auth();
  final _formKey = GlobalKey<FormState>();
  ProfileModel profileData;
  String name;
  String email;
  String location;
  String imageUrl;
  String gender = "Gender";

  ProfileModel profileRef;
  DocumentSnapshot docv;
  DocumentSnapshot querySnapshot;

  FirebaseUser user;

  _EditProfileState({Key key, @required this.profileData});

  DateTime selectedDate = DateTime.now();

  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    setState(() {
      name = profileData.name;
      email = profileData.email;
      location = profileData.location;
      gender = profileData.gender;
      imageUrl = profileData.imageUrl;
    });
    double screenWidth = MediaQuery.of(context).size.width * 0.9;
    final signupButton = ButtonTheme(
      minWidth: 150.0,
      height: 50.0,
      child: RaisedButton(
        onPressed: () => postData(),
        color: Colors.white,
        textColor: ColorUtils.primary,
        child: Text('Update Profile Details'),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
    );

    Future<Null> _selectDate(BuildContext context) async {
      final DateTime picked = await showDatePicker(
          context: context,
          initialDate: DateTime.parse(profileData.birthday),
          firstDate: DateTime(1930, 8),
          lastDate: DateTime(2020));
      if (picked != null && picked != selectedDate)
        setState(() {
          selectedDate = picked;
        });
    }

    return Scaffold(
      appBar: AppBar(title: Text('Edit Profile')),
      drawer: MenuDrawer.getDrawer(querySnapshot, user, profileRef,
          context), // This trailing comma makes auto-formatting

      body: Theme(
          data: ThemeData(
              primaryColor: ColorUtils.primary,
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
                          "Edit Profile",
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
                            initialValue: profileData.name,
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
                            initialValue: profileData.email,
                            enabled: false,
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
                            initialValue: profileData.location,
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
                      ],
                    ))
              ],
            ),
          )),
    );
  }

  postData() async {
    user = await auth.getCurrentUser();
    if (_formKey.currentState.validate() &&
        // selectedDate.year != null &&
        !gender.contains("en")) {
      setState(() {
        isLoading = true;
      });
      try {
        saveData(name, email, imageUrl, location, gender,
            selectedDate.toLocal(), user.uid);

        print('Signed in: ${user.uid}');

        if (user.uid.length > 0 && user.uid != null) {}
      } catch (e) {
        print('Error: $e');
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  saveData(String name, String email, String imageUrl, String location,
      String gender, DateTime birthday, userId) async {
    try {
      Firestore.instance.runTransaction((transaction) async {
        await transaction
            .update(Firestore.instance.collection("users").document(userId), {
          'name': name,
          'email': email,
          'location': location,
          'gender': gender,
          'birthday': DateFormat("MMMM d y").format(birthday).toString(),
          'userId': userId,
          'imageUrl': imageUrl
        });
      });
      datax();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future datax() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //loading data from profile in firestore based on userId
    querySnapshot =
        await Firestore.instance.collection("users").document(user.uid).get();
    // print("ProfileModel data");
/* var string = "foo",
    substring = "oo";
var d = string.indexOf(substring) != -1;
 */
    if (querySnapshot != null) {
      docv = querySnapshot;
      profileRef = ProfileModel.fromSnapshot(docv);
      prefs.remove('_profile');
      prefs.setString('_profile', jsonEncode(docv.data));
      //print("ProfileModel data:" + docv.data.toString());
    } else {
      // doc.data() will be undefined in this case
      print("No such document!");
    }

    if (prefs.getString('_profile') != null) {
      var data = jsonDecode(prefs.getString('_profile'));
      setState(() {
        profileRef = ProfileModel.fromMap(data);
      });
      //print("SAVED Profile " + prefs.getString('_profile') ?? "ERROR");
    }
  }
}
