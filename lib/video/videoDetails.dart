import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_youtube/flutter_youtube.dart';
import 'package:flutter/material.dart';
import 'package:kscope/models/video.dart';
import 'package:kscope/video/videoPlay.dart';

class VideoDetail extends StatefulWidget {
  @override
  final Video video;
  // In the constructor, require a Video of the Videos details
  VideoDetail({Key key, @required this.video}) : super(key: key);
  VideoState createState() => new VideoState(video: video);
}

// SingleTickerProviderStateMixin is used for animation
class VideoState extends State<VideoDetail> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final Video video;
  var likes;
  VideoState({Key key, @required this.video});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double imgHeight = screenHeight * 0.34;
    const cardMargin =
        const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0);
    addViews();

    return new Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        appBar: new AppBar(
          backgroundColor: const Color(0xFFad1f52),
          title: Text(video.name),
          centerTitle: true,
        ),
        body: new SingleChildScrollView(
          child: new Column(
            children: <Widget>[
              new Card(
                elevation: 3.0,
                margin: cardMargin,
                shape: new RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(1.0)),
                child: new Image.network(
                  video.img,
                  height: imgHeight,
                  width: width,
                  fit: BoxFit.cover,
                ),
              ),
              new SizedBox(
                height: 15.0,
              ),
              new Card(
                elevation: 3.0,
                margin: cardMargin,
                shape: new RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(1.0)),
                child: new Container(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          new Row(
                            children: <Widget>[
                              new Icon(
                                Icons.remove_red_eye,
                                size: 16.0,
                              ),
                              new Text(
                                '${video.views}k',
                                style: const TextStyle(fontSize: 12.0),
                              )
                            ],
                          ),
                          new SizedBox(
                            width: 20.0,
                          ),
                          new Row(
                            children: <Widget>[
                              new Icon(
                                Icons.favorite_border,
                                size: 16.0,
                              ),
                              new Text(
                                '${video.likes}',
                                style: const TextStyle(fontSize: 12.0),
                              )
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: 16),
                      Text(
                        video.name,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 19),
                      ),
                      SizedBox(height: 16),
                      Text(
                        video.content,
                        textAlign: TextAlign.left,
                        style: const TextStyle(height: 1.2),
                      ),
                      SizedBox(height: 16),
                      MaterialButton(
                        color: Colors.amber,
                        onPressed: () {
                          
                          
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VideoPlay(video: video,
                            )
                          ));
                        
                        
                        },
                        child: Text("Play Video",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Color(0xFF292e42))),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: "fab",
          onPressed: () {
            addLikes();
          },
          child: Icon(Icons.favorite, color: Color(0xFF292e42)),
          backgroundColor: Colors.amber,
        ));
  }

  void addViews() {}

  void addLikes() {
    likes = video.likes;

    setState(() {
      likes = likes + 1;
    });

    setState(() {
      Firestore.instance.runTransaction((transaction) async {
        await transaction.update(video.reference, {"likes": likes});
      }).then((onValue) {
        print("You Liked this article");
        _scaffoldKey.currentState.showSnackBar(new SnackBar(
          content: new Text("You Liked this Video"),
        ));
      });
    });
  }
}
