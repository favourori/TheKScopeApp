import 'package:cloud_firestore/cloud_firestore.dart';

class Events {
  String title;
  String image;
  String details;
  String organizer;
  String venue;
  DateTime timestamp;
  final DocumentReference reference;

  Events(this.title,  this.timestamp, this.details, this.organizer, this.venue,  this.reference);

  Events.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['dateTime'] != null),
        assert(map['event'] != null),
        title = map['event'],
         image = map['image'],
         details = map['details'],
          organizer = map['organizer'],
           venue = map['venue'],
        timestamp = map['dateTime'];

  Events.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
}