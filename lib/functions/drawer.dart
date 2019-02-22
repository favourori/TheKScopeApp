import 'package:flutter/material.dart';
import 'package:kscope/about/about.dart';
import 'package:kscope/auth/baseAuth.dart';
import 'package:kscope/auth/login.dart';
import 'package:kscope/blog/blogMore.dart';
import 'package:kscope/discounts/discountMore.dart';
import 'package:kscope/events/events_calender.dart';
import 'package:kscope/notification/notification.dart';
import 'package:kscope/profile/profile.dart';
import 'package:kscope/support/support.dart';
import 'package:kscope/terms/terms.dart';
import 'package:kscope/video/videoMore.dart';

class MenuDrawer {
  static final BaseAuth auth = new Auth();

  static Drawer getDrawer(querySnapshot, user, profileRef, context) {
    return new Drawer(
      child: Container(
        color: Theme.of(context).primaryColor,
        child: new ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
                margin: const EdgeInsets.all(0.0),
                currentAccountPicture: new Hero(
                    tag: "img",
                    child: Container(
                        width: 56.0,
                        height: 56.0,
                        decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            image: new DecorationImage(
                                fit: BoxFit.fill,
                                image: new NetworkImage(
                                    "http://medicumbrella.co.uk/wp-content/uploads/2014/09/icon_user_male.jpg"))))),
                accountName: new Text(
                    querySnapshot != null ? profileRef.name : 'KScope'),
                accountEmail:
                    new Text(user != null ? user.email : 'info@kscope.com')),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Divider(
                color: Colors.white,
              ),
            ),
            Container(
                margin: EdgeInsets.all(20),
                color: Theme.of(context).primaryColor,
                child: Column(children: <Widget>[
                  user != null
                      ? Column(
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                querySnapshot != null
                                    ? Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              Profile(profileData: profileRef),
                                        ),
                                      )
                                    : print(null);
                              },
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.dashboard,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 20),
                                  Text(
                                    "Profile",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 30),
                          ],
                        )
                      : Container(),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlogMore(),
                        ),
                      );
                    },
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.library_books,
                          color: Colors.white,
                        ),
                        SizedBox(width: 20),
                        Text(
                          "Blog",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VideoMore(),
                        ),
                      );
                    },
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.music_video,
                          color: Colors.white,
                        ),
                        SizedBox(width: 20),
                        Text(
                          "Videos",
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DiscountMore(),
                          ),
                        );
                      },
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.attach_money,
                            color: Colors.white,
                          ),
                          SizedBox(width: 20),
                          Text(
                            "Discounts",
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      )),
                  SizedBox(height: 30),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EventsCalender(),
                        ),
                      );
                    },
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.event,
                          color: Colors.white,
                        ),
                        SizedBox(width: 20),
                        Text(
                          "Events",
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Notify(),
                          ),
                        );
                      },
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.notifications,
                            color: Colors.white,
                          ),
                          SizedBox(width: 20),
                          Text(
                            "Notification",
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      )),
                  SizedBox(height: 30),
                  InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => About(),
                          ),
                        );
                      },
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.info,
                            color: Colors.white,
                          ),
                          SizedBox(width: 20),
                          Text(
                            "About Kscope",
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      )),
                  SizedBox(height: 30),
                  InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Support(),
                          ),
                        );
                      },
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.settings_applications,
                            color: Colors.white,
                          ),
                          SizedBox(width: 20),
                          Text(
                            "Contact Support",
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      )),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 17),
                    child: Divider(
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Terms(),
                          ),
                        );
                      },
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.bookmark,
                            color: Colors.white,
                          ),
                          SizedBox(width: 20),
                          Text(
                            "Terms & Conditions",
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      )),
                  SizedBox(height: 20),
                  user != null
                      ? InkWell(
                          onTap: () {
                            auth.signOut(context);
                          },
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.do_not_disturb_on,
                                color: Colors.white,
                              ),
                              SizedBox(width: 20),
                              Text(
                                "Log Out",
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          ))
                      : Column(
                          children: <Widget>[
                            InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Login(),
                                    ),
                                  );
                                },
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.lock_open,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 20),
                                    Text(
                                      "Log In",
                                      style: TextStyle(color: Colors.white),
                                    )
                                  ],
                                )),
                          ],
                        ),
                  SizedBox(height: 20),
                ]))
          ],
        ),
      ),
    );
  }
}
