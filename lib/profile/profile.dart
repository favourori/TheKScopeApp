import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:kscope/auth/baseAuth.dart';
import 'package:kscope/home/home.dart';
import 'package:kscope/models/profile.dart';
import 'package:kscope/profile/editProfile.dart';
import 'package:kscope/utils/color_utils.dart';
import 'package:kscope/utils/margin_utils.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  final ProfileModel profileData;

  Profile({Key key, @required this.profileData}) : super(key: key);

  @override
  ProfileState createState() => new ProfileState(profileData: profileData);
}

class ProfileState extends State<Profile> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final BaseAuth auth = new Auth();
  ProfileModel profileData;
  File imageFile;
  var isLoading = false;
  var isEnabled = false;
  ProfileState({Key key, @required this.profileData});
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Widget _buildDiagonalImage(BuildContext context) {
      var screenWidth = MediaQuery.of(context).size.width;

      return new Container(
        child: new Image.asset(
          "",
          width: screenWidth,
          height: 300.0,
          fit: BoxFit.cover,
        ),
        color: Colors.green,
      );
    }

    Widget _buildAvatar() {
      return new Hero(
        tag: "avatar",
        child: InkWell(
          onTap: () {
            _setImage();
          },
          child: new CircleAvatar(
            child: Container(
              width: 156.0,
              height: 156.0,
              decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  image: new DecorationImage(
                      fit: BoxFit.fill,
                      image: new NetworkImage(
                          "http://medicumbrella.co.uk/wp-content/uploads/2014/09/icon_user_male.jpg"))),
            ),
            backgroundColor: Colors.white,
            radius: 56.0,
          ),
        ),
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text("Profile"),
        centerTitle: true,
        // screen title
      ),
      body: Container(
          color: ColorUtils.primary,
          child: MediaQuery.removePadding(
              removeTop: true,
              context: context,
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            _buildDiagonalImage(context),
                            new Align(
                              alignment: FractionalOffset.bottomCenter,
                              child: new Column(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  MarginUtils.mg50,
                                  _buildAvatar(),
                                  MarginUtils.mg10,
                                  Text(
                                    profileData.name != null
                                        ? profileData.name
                                        : "",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  MarginUtils.mg5,
                                  Text(
                                    profileData.email != null
                                        ? profileData.email
                                        : "",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w200),
                                  ),
                                  MarginUtils.mg5,
                                  Text(
                                    profileData.gender != null
                                        ? profileData.gender
                                        : "",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w200),
                                  ),
                                  MarginUtils.mg5,
                                  Text(
                                    profileData.birthday != null
                                        ? profileData.birthday
                                        : "",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w200),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    MarginUtils.mg40,
                    Container(
                      // height: 300,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          ButtonTheme(
                            minWidth: 300.0,
                            height: 50.0,
                            child: RaisedButton(
                              onPressed: () async => await auth.resetPassword(
                                  profileData.email, context),
                              color: Colors.grey.shade800,
                              textColor: Colors.white,
                              child: Text('Reset Password'),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                            ),
                          ),
                          MarginUtils.mg10,
                          ButtonTheme(
                            minWidth: 300.0,
                            height: 50.0,
                            child: RaisedButton(
                              onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          EditProfile(profileData: profileData),
                                    ),
                                  ),
                              color: Colors.white,
                              textColor: Colors.black,
                              child: Text('Edit Details'),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                            ),
                          ),
                          MarginUtils.mg10,
                          ButtonTheme(
                            minWidth: 300.0,
                            height: 50.0,
                            child: RaisedButton(
                              onPressed: () async {
                                await auth.signOut(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        Home(userId: null, user: null),
                                  ),
                                );
                              },
                              color: ColorUtils.primary,
                              textColor: Colors.white,
                              child: Text('Log Out'),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ))),
    );
  }

  Future<File> _loadImage() async {
    imageFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    return imageFile;
  }

  void updateImage(downloadUrl) {
    setState(() {
      isLoading = true;
    });

    setState(() {
      Firestore.instance.runTransaction((transaction) async {
        await transaction
            .update(profileData.reference, {"imageUrl": downloadUrl});
      }).then((onValue) {
       // print("You updated your profile Image");
        _scaffoldKey.currentState.showSnackBar(new SnackBar(
          content: new Text("You Liked this article"),
        ));
      });
    });
  }

  _setImage() async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child("img_" + profileData.userId + ".jpg");
    StorageUploadTask uploadTask = storageReference.putFile(await _loadImage());
    Uri downloadUrl = await uploadTask.lastSnapshot.ref.getDownloadURL();

    print("Upload URL: " + downloadUrl.toString());
    updateImage(downloadUrl);
  }
}
