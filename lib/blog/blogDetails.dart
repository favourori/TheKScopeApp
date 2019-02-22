import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kscope/models/blog.dart';

class BlogDetail extends StatefulWidget {
  @override
  final Blog blog;
  // In the constructor, require a Blog of the Blogs details
  BlogDetail({Key key, @required this.blog}) : super(key: key);
  BlogState createState() => new BlogState(blog: blog);
}

// SingleTickerProviderStateMixin is used for animation
class BlogState extends State<BlogDetail> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final Blog blog;
  var likes;
  BlogState({Key key, @required this.blog});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double imgHeight = screenHeight * 0.34;
    addViews();

    const cardMargin =
        const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0);
    return new Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        appBar: new AppBar(
          backgroundColor: const Color(0xFFad1f52),
          title:  Text(blog.title, 
          overflow: TextOverflow.ellipsis),
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
                  blog.img,
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
                                '${blog.views}k',
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
                                '${blog.likes}',
                                style: const TextStyle(fontSize: 12.0),
                              )
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: 26),
                      
                      Text(
                        blog.title,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      SizedBox(height: 16),
                    Text(
                        blog.content,
                        textAlign: TextAlign.left,
                        style: const TextStyle(height: 1.2),
                      ),
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

  void addLikes() {
    likes = blog.likes;

    setState(() {
      likes = likes + 1;
    });

    setState(() {
      Firestore.instance.runTransaction((transaction) async {
        await transaction.update(blog.reference, {"likes": likes});
      }).then((onValue) {
        print("You Liked this article");
         _scaffoldKey.currentState.showSnackBar(new SnackBar(
          content: new Text("You Liked this article"),
        ));
      });
    });
  }

  void addViews() {}
}
