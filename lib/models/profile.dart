import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ProfileModel {
  String email;
  String gender;
  String location;
  String name;
  String imageUrl;
   String userId;
  String birthday;

  final DocumentReference reference;

  ProfileModel(this.email, this.gender, this.birthday, this.location, this.name,
      this.userId, this.imageUrl, this.reference);

  ProfileModel.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['email'] != null),
        gender = map['gender'],
        email = map['email'],
        name = map['name'],
       // birthday = DateFormat("MMMM d").format(map['local']).toString(),
        location = map['location'],
        userId = map['userId'],
        imageUrl = map['imageUrl'];

        

  ProfileModel.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
}
