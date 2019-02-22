import 'dart:convert';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kscope/auth/login.dart';
import 'package:kscope/auth/signup.dart';
import 'package:kscope/blog/blogDetails.dart';
import 'package:kscope/blog/blogMore.dart';
import 'package:kscope/category/category.dart';
import 'package:kscope/discounts/discountMore.dart';
import 'package:kscope/functions/drawer.dart';
import 'package:kscope/functions/pushNotifs.dart';
import 'package:kscope/models/blog.dart';
import 'package:kscope/models/category.dart';
import 'package:kscope/models/profile.dart';
import 'package:kscope/models/video.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kscope/utils/margin_utils.dart';
import 'package:kscope/video/videoDetails.dart';
import 'package:kscope/video/videoMore.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  /* Home({Key key, this.title}) : super(key: key);*/

  final String userId;

  final FirebaseUser user;
  Home({
    Key key,
    @required this.userId,
    @required this.user,
  }) : super(key: key);

  @override
  _HomePageState createState() =>
      new _HomePageState(userId: userId, user: user);
}

class _HomePageState extends State<Home> {
  final String userId;
  final FirebaseUser user;
  _HomePageState({Key key, @required this.userId, @required this.user});

  //PUSH NOTIFICATIONS
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final TextEditingController _search = new TextEditingController();
  List<String> notifItem = [];
  var notificationNumber = 0;
  var emptyNotif = true;
  var searching = false;
  ProfileModel profileRef;
  DocumentSnapshot docv;
  DocumentSnapshot querySnapshot;

  @override
  void initState() {
    super.initState();
    //initiatePushNotif();
    //firebaseCloud();
    loadProfile();
    Firestore.instance.enablePersistence(true);
  }

  Future initiatePushNotif() async {
    //Building Native Notication
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    // If you have skipped STEP 3 then change app_icon to @mipmap/ic_launcher

    // ---------------------CODE FOR INITIALIZING NOTIFICATION------------------------------

    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  // ---------------------CODE FOR NOTIFICATION------------------------------
  void firebaseCloud() async {
    // if (Platform.isIOS) {}

    _firebaseMessaging.getToken().then((token) async {
      print("NEW FCM Token: " + token);
     await PushNotifs.setPref(context, notifItem);
    });

    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
      print('on message $message');
      String notify = message['notification']['title'] +
          " : " +
          " \n" +
          message['notification']['body'];

      setState(() {
        notifItem.add(notify);
        notificationNumber = notificationNumber + 1;
        emptyNotif = false;
      });
     PushNotifs.showNotificationWithDefaultSound(
          message['notification']['title'], message['notification']['body'], flutterLocalNotificationsPlugin);

      await PushNotifs.setPref(context, notifItem);
    });
  }

  Future onSelectNotification(String payload) async {
    showDialog(
      context: context,
      builder: (_) {
        _showDialog();
        return new AlertDialog(
          title: Text("$payload"),
        );
      },
    );
  }

  // ---------------------CODE FOR PROFILE LOADING-----------------------------

  loadProfile() async {
    //print("SAVE DATA " + prefs.getString('_onBoarding')?? "ERROR");

    try {
      if (user == null || userId.isEmpty) {
        await new Future.delayed(const Duration(seconds: 5));
        sleepLogin(context);
      } else {
         datax();
      }
    } catch (e) {}
  }

  // ---------------------CODE FOR PUSH NOTIFICATIONS DIALOG------------------------------
  _showDialog() async {
    setState(() {
      emptyNotif = true;
    });
    await showDialog<String>(
        context: context,
        child: new Dialog(
            child: Container(
          padding: const EdgeInsets.all(9.0),
          color: Theme.of(context).primaryColor,
          child: new Column(children: <Widget>[
            Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  IconButton(
                      onPressed: () {
                        setState(() {
                          notifItem = [];
                          Navigator.pop(context);
                          notificationNumber = 0;
                          emptyNotif = true;
                        });
                      },
                      icon: new Icon(
                        Icons.delete,
                        color: Colors.white,
                        size: 17.0,
                      ))
                ]),
            new Expanded(child: _buildList())
          ]),
        )));
  }

  // ---------------------CODE FOR PUSH NOTIFICATION LIST------------------------------
  Widget _buildList() {
    return new ListView.builder(itemBuilder: (context, index) {
      // itemBuilder will be automatically be called as many times as it takes for the
      // list to fill up its available space, which is most likely more than the
      // number of status items we have. So, we need to check the index is OK.

      if (index < notifItem.length) {
        return Card(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  trailing: Icon(Icons.notifications,
                      size: 29, color: Theme.of(context).primaryColor),
                  onTap: () {
                    onSelectNotification(notifItem[index]);
                  },
                  title: Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                SizedBox(
                                  width: 150,
                                  child: Text(
                                    notifItem[index],
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 10.0),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }
    });
  }

  
  //STREAM BUILDERS FOR FIRESTORE ITEMS
  Stream<QuerySnapshot> _videoDB =
      Firestore.instance.collection('videos').snapshots();

  Stream<QuerySnapshot> _blogDB =
      Firestore.instance.collection('blog').snapshots();

  Stream<QuerySnapshot> _discountDB =
      Firestore.instance.collection('categories').snapshots();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 3.0),
          child: new Card(
            shape: const RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(const Radius.circular(40.0)),
            ),
            child: new Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Expanded(
                      child: new TextField(
                    controller: _search,
                    onChanged: (value) {
                      _setupSearch();
                    },
                    decoration: InputDecoration.collapsed(
                        hintStyle: TextStyle(fontSize: 12),
                        hintText: 'Search for anything'),
                  )),
                  new Icon(
                    Icons.search,
                    color: Colors.grey,
                  )
                ],
              ),
            ),
          ),
        ),
        centerTitle: true,
        actions: <Widget>[
          new IconButton(
              icon: new Stack(children: <Widget>[
                new Icon(
                  Icons.notifications_none,
                  size: 30.0,
                ),
                emptyNotif
                    ? new Positioned(
                        child: new Container(
                          padding: const EdgeInsets.all(5.0),
                          child: new Text(
                            notificationNumber.toString(),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 7.5),
                          ),
                          decoration: new BoxDecoration(
                              color: Colors.red, shape: BoxShape.circle),
                        ),
                        right: 0.0,
                        top: 0.0,
                      )
                    : SizedBox()
              ]),
              onPressed: _showDialog)
        ],
      ),
      body: new Container(
        color: Theme.of(context).primaryColor,
        child: _getBody(context),
      ),
      drawer: MenuDrawer.getDrawer(querySnapshot, user, profileRef, context), // This trailing comma makes auto-formatting
    );
  }

  
  //BUILDING BODY OF THE HOME SCREEN
  Widget _getBody(BuildContext context) {
    ///--------------------VIDEOS FROM FIRESTORE CONFIG--------------------------///
    ///ACTUAL LISVIEW BUILDER FOR VIDEOS
    ///

    Widget _buildVideoListItem(BuildContext context, DocumentSnapshot data) {
      final video = Video.fromSnapshot(data);
      if (searching && _search.text != "") {
        return video.name.toLowerCase().contains(_search.text.toLowerCase())
            ? InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VideoDetail(video: video),
                    ),
                  );
                },
                child: new Container(
                  width: 170.0,
                  height: 300.0,
                  padding: const EdgeInsets.only(left: 5.0),
                  child: new Card(
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          const BorderRadius.all(const Radius.circular(7.0)),
                    ),
                    child: new Stack(
                      children: <Widget>[
                        new Positioned.fill(
                            child: new Image.network(
                          video.img,
                          fit: BoxFit.cover,
                        )),
                        new Positioned(
                            width: 170.0,
                            bottom: 0.0,
                            height: 120.0,
                            child: new Container(
                              decoration: BoxDecoration(
                                  gradient: new LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                    Colors.transparent,
                                    const Color(0x99000000)
                                  ])),
                            )),
                        new Positioned(
                          bottom: 10.0,
                          left: 10.0,
                          right: 10.0,
                          child: new Column(
                            children: <Widget>[
                              new Text(
                                video.name,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              new SizedBox(
                                height: 10.0,
                              ),
                              new Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  new Row(
                                    children: <Widget>[
                                      new Icon(
                                        Icons.remove_red_eye,
                                        color: Colors.white,
                                        size: 15.0,
                                      ),
                                      new Text(
                                        '${video.views}k',
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 11.0),
                                      )
                                    ],
                                  ),
                                  new Row(
                                    children: <Widget>[
                                      new Icon(
                                        Icons.favorite_border,
                                        color: Colors.white,
                                        size: 15.0,
                                      ),
                                      new Text(
                                        '${video.likes}k',
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 11.0),
                                      )
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            : Container();
      }

      return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VideoDetail(video: video),
            ),
          );
        },
        child: new Container(
          width: 170.0,
          height: 300.0,
          padding: const EdgeInsets.only(left: 5.0),
          child: new Card(
            shape: const RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(const Radius.circular(7.0)),
            ),
            child: new Stack(
              children: <Widget>[
                new Positioned.fill(
                    child: new Image.network(
                  video.img,
                  fit: BoxFit.cover,
                )),
                new Positioned(
                    width: 170.0,
                    bottom: 0.0,
                    height: 120.0,
                    child: new Container(
                      decoration: BoxDecoration(
                          gradient: new LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                            Colors.transparent,
                            const Color(0x99000000)
                          ])),
                    )),
                new Positioned(
                  bottom: 10.0,
                  left: 10.0,
                  right: 10.0,
                  child: new Column(
                    children: <Widget>[
                      new Text(
                        video.name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      new SizedBox(
                        height: 10.0,
                      ),
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Row(
                            children: <Widget>[
                              new Icon(
                                Icons.remove_red_eye,
                                color: Colors.white,
                                size: 15.0,
                              ),
                              new Text(
                                '${video.views}k',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 11.0),
                              )
                            ],
                          ),
                          new Row(
                            children: <Widget>[
                              new Icon(
                                Icons.favorite_border,
                                color: Colors.white,
                                size: 15.0,
                              ),
                              new Text(
                                '${video.likes}k',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 11.0),
                              )
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }

    //MAPING VIDEOS TO LIST AND PASSING CONTEXT
    Widget _buildVideoList(
        BuildContext context, List<DocumentSnapshot> snapshot) {
      return ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(top: 20.0),
        children:
            snapshot.map((data) => _buildVideoListItem(context, data)).toList(),
      );
    }

    //VIDEO WIDGET TO CREATE VIDEO LIST
    Widget videos = new Column(
      children: <Widget>[
        new Container(
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.only(left: 15.0),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Text(
                'Latest Videos',
                style: const TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              new FlatButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VideoMore(),
                      ),
                    );
                  },
                  child: const Text(
                    'Show more',
                    style: const TextStyle(color: Colors.white),
                  ))
            ],
          ),
        ),
        new Container(
            height: 210.0,
            margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: StreamBuilder<QuerySnapshot>(
              stream: _videoDB,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return LinearProgressIndicator();
                return _buildVideoList(context, snapshot.data.documents);
              },
            )),
      ],
    );

    ///--------------------BLOGS FROM FIRESTORE CONFIG--------------------------///

    ///ACTUAL LISVIEW BUILDER FOR BLOG POSTS

    Widget _buildBlogListItem(BuildContext context, DocumentSnapshot data) {
      final blog = Blog.fromSnapshot(data);
      if (searching && _search.text != "") {
        return blog.title.toLowerCase().contains(_search.text.toLowerCase())
            ? new Container(
                width: 320.0,
                height: double.infinity,
                padding: const EdgeInsets.only(left: 5.0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlogDetail(blog: blog),
                      ),
                    );
                  },
                  child: new Card(
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          const BorderRadius.all(const Radius.circular(3.0)),
                    ),
                    child: new Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Stack(children: [
                          Card(
                              child: SizedBox(
                            width: 100.0,
                            height: 200.0,
                          )),
                          Positioned.fill(
                            child: new Image.network(
                              blog.img,
                              width: 100.0,
                              fit: BoxFit.cover,
                            ),
                          )
                        ]),
                        new Expanded(
                            child: new Container(
                          padding: const EdgeInsets.all(10.0),
                          child: new Column(
                            children: <Widget>[
                              new Text(
                                blog.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              new SizedBox(
                                height: 7.0,
                              ),
                              new Text(
                                blog.content,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: Colors.grey),
                              ),
                              new Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  new InkWell(
                                    child: new Container(
                                        padding: new EdgeInsets.only(
                                            left: 5.0,
                                            top: 10.0,
                                            right: 10.0,
                                            bottom: 5.0),
                                        child: new Text(
                                          'Read More',
                                          style: new TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 12.0),
                                        )),
                                  ),
                                  new Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: new Row(
                                      children: <Widget>[
                                        new Row(
                                          children: <Widget>[
                                            new Icon(
                                              Icons.remove_red_eye,
                                              size: 15.0,
                                            ),
                                            new Text(
                                              '${blog.views}k',
                                              style: const TextStyle(
                                                  fontSize: 11.0),
                                            )
                                          ],
                                        ),
                                        new SizedBox(
                                          width: 10.0,
                                        ),
                                        new Row(
                                          children: <Widget>[
                                            new Icon(
                                              Icons.favorite_border,
                                              size: 15.0,
                                            ),
                                            new Text(
                                              '${blog.likes}k',
                                              style: const TextStyle(
                                                  fontSize: 11.0),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ))
                      ],
                    ),
                  ),
                ),
              )
            : Container();
      }

      return new Container(
        width: 320.0,
        height: double.infinity,
        padding: const EdgeInsets.only(left: 5.0),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlogDetail(blog: blog),
              ),
            );
          },
          child: new Card(
            shape: const RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(const Radius.circular(3.0)),
            ),
            child: new Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Stack(children: [
                  Card(
                      child: SizedBox(
                    width: 100.0,
                    height: 200.0,
                  )),
                  Positioned.fill(
                    child: new Image.network(
                      blog.img,
                      width: 100.0,
                      fit: BoxFit.cover,
                    ),
                  )
                ]),
                new Expanded(
                    child: new Container(
                  padding: const EdgeInsets.all(10.0),
                  child: new Column(
                    children: <Widget>[
                      new Text(
                        blog.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      new SizedBox(
                        height: 7.0,
                      ),
                      new Text(
                        blog.content,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new InkWell(
                            child: new Container(
                                padding: new EdgeInsets.only(
                                    left: 5.0,
                                    top: 10.0,
                                    right: 10.0,
                                    bottom: 5.0),
                                child: new Text(
                                  'Read More',
                                  style: new TextStyle(
                                      color: Colors.grey[600], fontSize: 12.0),
                                )),
                          ),
                          new Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: new Row(
                              children: <Widget>[
                                new Row(
                                  children: <Widget>[
                                    new Icon(
                                      Icons.remove_red_eye,
                                      size: 15.0,
                                    ),
                                    new Text(
                                      '${blog.views}k',
                                      style: const TextStyle(fontSize: 11.0),
                                    )
                                  ],
                                ),
                                new SizedBox(
                                  width: 10.0,
                                ),
                                new Row(
                                  children: <Widget>[
                                    new Icon(
                                      Icons.favorite_border,
                                      size: 15.0,
                                    ),
                                    new Text(
                                      '${blog.likes}k',
                                      style: const TextStyle(fontSize: 11.0),
                                    )
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ))
              ],
            ),
          ),
        ),
      );
    }

    //MAPING BLOGS TO LIST AND PASSING CONTEXT
    Widget _buildBlogList(
        BuildContext context, List<DocumentSnapshot> snapshot) {
      return ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(top: 20.0),
        children:
            snapshot.map((data) => _buildBlogListItem(context, data)).toList(),
      );
    }

    //BLOG  WIDGET TO CREATE BLOG LIST
    Widget blog = new Column(
      children: <Widget>[
        new Container(
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.only(left: 15.0),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Text(
                'Blog',
                style: const TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              new FlatButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlogMore(),
                      ),
                    );
                  },
                  child: const Text(
                    'Show more',
                    style: const TextStyle(color: Colors.white),
                  ))
            ],
          ),
        ),
        new Container(
          height: 143.0,
          margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: StreamBuilder<QuerySnapshot>(
            stream: _blogDB,
            builder: (context, snap) {
              if (!snap.hasData) return LinearProgressIndicator();

              return _buildBlogList(context, snap.data.documents);
            },
          ),
        ),
      ],
    );

    ///ACTUAL LISVIEW BUILDER FOR DISCOUNTS
    ///

    Widget _buildDiscountListItem(BuildContext context, DocumentSnapshot data) {
      var randomColor = [
        Colors.lightBlue[800].withOpacity(0.9),
        Colors.green[800].withOpacity(0.9),
        Colors.amber[800].withOpacity(0.9),
        Colors.pink[800].withOpacity(0.9),
        Colors.purple[800].withOpacity(0.9)
      ];

      final _random = new Random();
      Color randomColorBg = randomColor[_random.nextInt(randomColor.length)];

      final discount = Category.fromSnapshot(data);

      if (searching && _search.text != "") {
        return discount.catTitle
                .toLowerCase()
                .contains(_search.text.toLowerCase())
            ? new InkWell(
                onTap: () async {
                  print("categories" +
                      "/" +
                      discount.reference.documentID +
                      "/" +
                      "subCat");

                  QuerySnapshot querySnapshot = await Firestore.instance
                      .collection("categories")
                      .document(discount.reference.documentID)
                      .collection("subCat")
                      .getDocuments();

                  var list = querySnapshot.documents;
                  print(list.toString());

                  if (list.length > 0) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryUI(category: discount),
                      ),
                    );
                  }
                },
                child: Container(
                  width: 150.0,
                  height: double.infinity,
                  padding: const EdgeInsets.only(left: 5.0),
                  child: new Card(
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          const BorderRadius.all(const Radius.circular(5.0)),
                    ),
                    child: new Stack(
                      children: <Widget>[
                        new Positioned.fill(
                            child: new Image.asset(
                          'assets/images/${discount.imageUrl}',
                          fit: BoxFit.cover,
                        )),
                        new Positioned(
                            width: 150.0,
                            bottom: 0.0,
                            top: 0.0,
                            child: new Container(
                              decoration: BoxDecoration(
                                  gradient: new LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                    Colors.transparent,
                                    randomColorBg
                                  ])),
                            )),
                        new Positioned(
                          bottom: 20.0,
                          left: 10.0,
                          right: 10.0,
                          child: new Text(
                            discount.catTitle,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            : Container();
      }

      return new InkWell(
        onTap: () async {
          print("categories" +
              "/" +
              discount.reference.documentID +
              "/" +
              "subCat");

          QuerySnapshot querySnapshot = await Firestore.instance
              .collection("categories")
              .document(discount.reference.documentID)
              .collection("subCat")
              .getDocuments();

          var list = querySnapshot.documents;
          print(list.toString());

          if (list.length > 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CategoryUI(category: discount),
              ),
            );
          }
        },
        child: Container(
          width: 150.0,
          height: double.infinity,
          padding: const EdgeInsets.only(left: 5.0),
          child: new Card(
            shape: const RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(const Radius.circular(5.0)),
            ),
            child: new Stack(
              children: <Widget>[
                new Positioned.fill(
                    child: new Image.asset(
                  'assets/images/${discount.imageUrl}',
                  fit: BoxFit.cover,
                )),
                new Positioned(
                    width: 150.0,
                    bottom: 0.0,
                    top: 0.0,
                    child: new Container(
                      decoration: BoxDecoration(
                          gradient: new LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.transparent, randomColorBg])),
                    )),
                new Positioned(
                  bottom: 20.0,
                  left: 10.0,
                  right: 10.0,
                  child: new Text(
                    discount.catTitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }

    //MAPING DISCOUNTS TO LIST AND PASSING CONTEXT
    Widget _buildDiscountList(
        BuildContext context, List<DocumentSnapshot> snapshot) {
      return ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(top: 20.0),
        children: snapshot
            .map((data) => _buildDiscountListItem(context, data))
            .toList(),
      );
    }

    Widget discount = new Column(
      children: <Widget>[
        new Container(
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.only(left: 15.0),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Text(
                'Discount',
                style: const TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              new FlatButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DiscountMore(),
                      ),
                    );
                  },
                  child: const Text(
                    'Show more',
                    style: const TextStyle(color: Colors.white),
                  ))
            ],
          ),
        ),
        new Container(
          height: 180.0,
          margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: StreamBuilder<QuerySnapshot>(
            stream: _discountDB,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return LinearProgressIndicator();

              return _buildDiscountList(context, snapshot.data.documents);
            },
          ),
        ),
      ],
    );
    //RETURNING LIST TO BULD MAIN LAYOUT
    return new ListView(
      children: <Widget>[
        new SizedBox(
          height: 10.0,
        ),
        videos,
        new SizedBox(
          height: 10.0,
        ),
        blog,
        new SizedBox(height: 10.0),
        discount
      ],
    );
  }

  //SETING UP SEARCH QUERY FUNCTIONS
  void _setupSearch() {
    print(_search.text);

    setState(() {
      if (_search.text == "") {
        searching = false;

        _videoDB = Firestore.instance.collection('videos').snapshots();

        _blogDB = Firestore.instance.collection('blog').snapshots();

        _discountDB = Firestore.instance.collection('categories').snapshots();
      } else {
        searching = true;

        _videoDB =
            Firestore.instance.collection('videos').orderBy('name').snapshots();

        _blogDB =
            Firestore.instance.collection('blog').orderBy('title').snapshots();

        _discountDB = Firestore.instance.collection('categories').snapshots();
      }
    });
  }

  void sleepLogin(BuildContext context) async {
    await showDialog<String>(
        context: context,
        child: new AlertDialog(
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Login(),
                    ),
                  );
                },
                child: Text(
                  "LOGIN",
                ),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Signup(),
                    ),
                  );
                },
                child: Text(
                  "SIGNUP",
                ),
              )
            ],
            title: Container(
              padding: const EdgeInsets.all(9.0),
              child: Center(
                child: new Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.insert_emoticon,
                          )
                        ],
                      ),
                      MarginUtils.mg30,
                      Text(
                          "To Enjoy all the features of KSCope Please Signin to an Existing account or Create a new account",
                          style: TextStyle(fontSize: 18)),
                    ]),
              ),
            )));
  }

   datax() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //loading data from profile in firestore based on userId
    querySnapshot =
        await Firestore.instance.collection("users").document(userId).get();
    print("ProfileModel data");
/* var string = "foo",
    substring = "oo";
var d = string.indexOf(substring) != -1;
 */
    if (querySnapshot != null) {
      docv = querySnapshot;
      
      profileRef = ProfileModel.fromSnapshot(docv);
      prefs.remove('_profile');
      prefs.setString('_profile', jsonEncode(docv.data));
      print("ProfileModel data:" + docv.data.toString());
    } else {
      // doc.data() will be undefined in this case
      print("No such document!");
    }

    if (prefs.getString('_profile') != null) {
     // querySnapshot = jsonDecode(prefs.getString('snap'));
      var data = jsonDecode(prefs.getString('_profile'));
      setState(() {
        profileRef = ProfileModel.fromMap(data);
      });
      print("SAVED Profile " + prefs.getString('_profile') ?? "ERROR");
    }
  }
}
