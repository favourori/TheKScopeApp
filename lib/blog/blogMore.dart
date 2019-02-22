import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kscope/blog/blogDetails.dart';
import 'package:kscope/models/blog.dart';

class BlogMore extends StatefulWidget {
  @override
 BlogState createState() => new BlogState();
}

// SingleTickerProviderStateMixin is used for animation
class BlogState extends State<BlogMore> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    
   Widget _buildBlogListItem(BuildContext context, DocumentSnapshot data) {
      final blog = Blog.fromSnapshot(data);
      return new Container(
        width: 320.0,
        padding: const EdgeInsets.only(left: 5.0, bottom: 10),
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
            elevation: 13,
            color: Theme.of(context).primaryColor,
            shape: const RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(const Radius.circular(3.0)),
            ),
            child: new Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Stack(children: [
                  Card(child: SizedBox(width: 100.0, height: 110.0,)),
                  Positioned.fill(
                    child: new Image.network(
                      blog.img,
                      width: 90.0,
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
                            color: Colors.white, fontWeight: FontWeight.bold,),
                      ),
                      new SizedBox(
                        height: 7.0,
                      ),
                      new Text(
                        blog.content,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white54),
                      ),
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new InkWell(
                            onTap: (){},
                            child: new Container(
                                padding: new EdgeInsets.only(
                                    left: 5.0,
                                    top: 10.0,
                                    right: 10.0,
                                    bottom: 5.0),
                                child: new Text(
                                  'Read More',
                                  style: new TextStyle(
                                      color: Colors.white30, fontSize: 12.0),
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
                                      color: Colors.white,
                                    ),
                                    new Text(
                                      '${blog.views}k',
                                      style: const TextStyle(fontSize: 11.0, color: Colors.white),
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
                                      color: Colors.white,
                                    ),
                                    new Text(
                                      '${blog.likes}k',
                                      style: const TextStyle(fontSize: 11.0, color: Colors.white)
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
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.only(top: 20.0),
        children:
            snapshot.map((data) => _buildBlogListItem(context, data)).toList(),
      );
    }

    //BLOG  WIDGET TO CREATE BLOG LIST
    Widget blog = new Column(
      children: <Widget>[
        Flexible(
          child: new Container(
            margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection('blog').snapshots(),
              builder: (context, snap) {
                if (!snap.hasData) return LinearProgressIndicator();

                return _buildBlogList(context, snap.data.documents);
              },
            ),
          ),
        ),
      ],
    );


    return new Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        key: _scaffoldKey,
        appBar: new AppBar(
          backgroundColor: const Color(0xFFad1f52),
          title: const Text('Blog'),
          centerTitle: true,
        ),
        body:Center(child: blog));
  }

  
}
