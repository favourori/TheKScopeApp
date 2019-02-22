import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_youtube/flutter_youtube.dart';
import 'package:flutter/material.dart';
import 'package:kscope/models/video.dart';

class VideoPlay extends StatefulWidget {
  @override
  final Video video;
  // In the constructor, require a VideoPlay of the VideoPlays details
  VideoPlay({Key key, @required this.video}) : super(key: key);
  VideoPlayState createState() => new VideoPlayState(video: video);
}

// SingleTickerProviderStateMixin is used for animation
class VideoPlayState extends State<VideoPlay> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final Video video;
  var likes;
  VideoPlayState({Key key, @required this.video});

  @override
  Widget build(BuildContext context) {
    addViews();

    final playVideo = FlutterYoutube.playYoutubeVideoByUrl(
      apiKey: "<API_KEY>",
      videoUrl: video.videoLink,
      autoPlay: true, //default falase
      fullScreen: true,
      //default false
    );

    return new Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        appBar: new AppBar(
          backgroundColor: const Color(0xFFad1f52),
          title: Text(video.name),
          centerTitle: true,
        ),
        body: Center(child: playVideo),
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
