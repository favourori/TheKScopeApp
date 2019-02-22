import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:kscope/events/eventDetails.dart';
import 'package:kscope/events/flutter_calendar.dart';
import 'package:kscope/models/events.dart';

class EventsCalender extends StatefulWidget {
  @override
  _EventsCalenderState createState() => _EventsCalenderState();
}

class _EventsCalenderState extends State<EventsCalender> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  DateTime selectDate = new DateTime.now();
  var dataX = true;

  @override
  Widget build(BuildContext context) {
    const grey = const Color(0xFF252a40);

    Widget _buildEventsListItem(BuildContext context, DocumentSnapshot data) {
      dataX = true;

      final events = Events.fromSnapshot(data);

      String currentTime =
          DateFormat("jm").format(events.timestamp).toString();

      //CHECKING IF CLICKED DATES ARE EQUAL TO FIRBASE DATE AND DISPLAYING ITEM ACCORDINGLY
      String dateDay = DateFormat("MMMM d").format(selectDate).toString();
      String firebaseDay = DateFormat("MMMM d").format(events.timestamp).toString();

      // print("Current Date " +selectedDate2);

      var imgSize = 79.0;
      var lineText = new TextStyle(color: Colors.lime[700], fontSize: 13.0);

      var event = SizedBox(
        height: imgSize,
        child: new Card(
          elevation: 2.0,
          child: new Container(
            // padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              height: imgSize,
              child: InkWell(
                onTap: (){
                  Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EventDetail( event: events),
                        ),
                      );
                },
                child: new Row(
                  children: <Widget>[
                    new Image.asset(
                      'assets/images/fashion.jpg',
                      width: imgSize,
                      height: imgSize,
                      fit: BoxFit.cover,
                    ),
                    new SizedBox(
                      width: 10.0,
                    ),
                    new Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        new Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            new Text(
                             DateFormat("MMMM").format(events.timestamp).toString(),
                              maxLines: 1,
                              style: lineText,
                            ),
                            new Text(
                             DateFormat("d").format(events.timestamp).toString(),
                              maxLines: 1,
                              style: lineText,
                            )
                          ],
                        ),
                        new SizedBox(
                          width: 20.0,
                        ),
                        new Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              width:130,
                              child: new Text(
                                events.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            new Text(currentTime)
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      if (dateDay == firebaseDay) {
        dataX = true;
      } else {
        dataX = false;
      }
      return dataX ? event : Container();
    }

    //MAPING Events TO LIST AND PASSING C4ONTEXT
    Widget _buildEventsList(
        BuildContext context, List<DocumentSnapshot> snapshot) {
      return ListView(
        padding: const EdgeInsets.only(top: 20.0),
        children: snapshot
            .map((data) => _buildEventsListItem(context, data))
            .toList(),
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        backgroundColor: grey,
        title: const Text('Events Calender'),
        centerTitle: true,
      ),
      body: new Container(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          child: new SingleChildScrollView(
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Calendar(
                  showCalendarPickerIcon: false,
                  initialCalendarDateOverride: selectDate,
                  onDateSelected: (date) {
                    setState(() {
                      selectDate = date;
                     // print("selectDate: " + selectDate.toString());
                    });
                    // events;
                  },
                ),
                new SizedBox(
                  height: 15.0,
                ),
                new Container(
                  decoration: new BoxDecoration(
                      color: grey,
                      borderRadius: new BorderRadius.circular(100.0)),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  child: new Text(
                    'All Events',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                new Container(
                    height: 240.0,
                    child: StreamBuilder<QuerySnapshot>(
                      stream:
                          Firestore.instance.collection('events').snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) return LinearProgressIndicator();

                        return _buildEventsList(
                            context, snapshot.data.documents);
                      },
                    ))
              ],
            ),
          )),
    );
  }
}
