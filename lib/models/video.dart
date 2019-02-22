import 'package:cloud_firestore/cloud_firestore.dart';

class Video {
  String name;
  String img;
  String content;
  String videoLink;
  double views;
  double likes;
  final DocumentReference reference;

  Video(this.name, this.img, this.views, this.likes, this.videoLink, this.content, this.reference);

  Video.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['img'] != null),
        assert(map['name'] != null),
        assert(map['videoLink'] != null),
        name = map['name'],
        views = map['views'],
        img = map['img'],
        content = map['content'],
        videoLink = map['videoLink'],
        likes = map['likes'];

  Video.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
}