import 'package:cloud_firestore/cloud_firestore.dart';

class Blog {
  String img;
  String title;
  String content;
  double views;
  double likes;

  final DocumentReference reference;

  Blog(this.img, this.title, this.content, this.views, this.likes,
      this.reference);

  Blog.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['title'] != null),
       assert(map['img'] != null),
        title = map['title'],
        img = map['img'],
        content = map['content'],
        views = map['views'],
        likes = map['likes'];

  Blog.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
}
