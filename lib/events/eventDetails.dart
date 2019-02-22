import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kscope/models/blog.dart';
import 'package:kscope/models/events.dart';

class EventDetail extends StatefulWidget {
  @override
  final Events event;
  // In the constructor, require a Event of the Events details
  EventDetail({Key key, @required this.event}) : super(key: key);
  EventState createState() => new EventState(event: event);
}

// SingleTickerProviderStateMixin is used for animation
class EventState extends State<EventDetail> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final Events event;
  var likes;
  EventState({Key key, @required this.event});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double imgHeight = screenHeight * 0.34;
    var hasImage = false;
    var images;

    const cardMargin =
        const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0);

    if (event.image.toLowerCase().contains("http")) {
      setState(() {
        hasImage = true;
        images = new Card(
            elevation: 3.0,
            margin: cardMargin,
            shape: new RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(1.0)),
            child: new Image.network(
              event.image,
              height: imgHeight,
              width: width,
              fit: BoxFit.cover,
            ));
      });
    }
    return new Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: new AppBar(
        backgroundColor: const Color(0xFFad1f52),
        title: const Text('Event'),
        centerTitle: true,
      ),
      body: new SingleChildScrollView(
        child: new Column(
          children: <Widget>[
            hasImage ? images : Container(),
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
                            new Row(children: <Widget>[
                              new Icon(
                                Icons.calendar_today,
                                size: 16.0,
                              ),
                              new Text(
                                  DateFormat("MMMM d")
                                          .format(event.timestamp)
                                          .toString() +
                                      " " +
                                      DateFormat("jm")
                                          .format(event.timestamp)
                                          .toString() +
                                      "  " +
                                      DateFormat("y")
                                          .format(event.timestamp)
                                          .toString(),
                                  style: const TextStyle(fontSize: 12.0)),
                            ])
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 26),
                    Text(
                      event.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    SizedBox(height: 26, child: Divider()),
                    Text(
                      "Details:",
                      textAlign: TextAlign.left,
                      style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    Text(
                      event.details,
                      textAlign: TextAlign.center,
                      style: const TextStyle(height: 2.2),
                    ),
                    SizedBox(height: 26, child: Divider()),
                    Text(
                      "Venue",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                    
                    ),
                    SizedBox(height: 16),
                    Text(
                      event.venue,
                      textAlign: TextAlign.center,
                      style: const TextStyle(height: 2.2),
                    ),
                    SizedBox(height: 26, child: Divider()),
                    Text(
                      "Organizer",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                    
                    ),
                    SizedBox(height: 16),
                    Text(
                      event.organizer,
                      textAlign: TextAlign.center,
                      style: const TextStyle(height: 2.2),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
