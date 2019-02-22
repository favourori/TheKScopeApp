import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kscope/models/video.dart';
import 'package:kscope/video/videoDetails.dart';

class VideoMore extends StatefulWidget {
  @override
  VideoState createState() => new VideoState();
}

// SingleTickerProviderStateMixin is used for animation
class VideoState extends State<VideoMore> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
 
  @override
  Widget build(BuildContext context) {
     double screenHeight = MediaQuery.of(context).size.height * 0.84;

    Widget _buildVideoListItem(BuildContext context, DocumentSnapshot data) {
      final video = Video.fromSnapshot(data);

      return InkWell(
        onTap: (){
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
          padding: const EdgeInsets.only(left: 5.0, bottom: 5),
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

    Widget _buildVideoList(
        BuildContext context, List<DocumentSnapshot> snapshot) {
      return new GridView(
        //itemCount: data.length
        gridDelegate:
            new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        children:
            snapshot.map((data) => _buildVideoListItem(context, data)).toList(),
      );
    }

    //VIDEO WIDGET TO CREATE VIDEO LIST
    Widget videos = new Column(

      children: <Widget>[
        new Container(
            height: screenHeight,
            margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 10.0),
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection('videos').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return LinearProgressIndicator();

                return _buildVideoList(context, snapshot.data.documents);
              },
            )),
      ],
    );

    return new Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        key: _scaffoldKey,
        appBar: new AppBar(
          backgroundColor: const Color(0xFFad1f52),
          title: const Text("Video"),
          centerTitle: true,
        ),
        body: Center(child: videos));
  }
}
