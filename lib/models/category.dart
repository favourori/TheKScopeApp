import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  String catTitle;
  String imageUrl;
  final DocumentReference reference;

  Category({this.catTitle, this.imageUrl, this.reference});

  Category.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['catTitle'] != null),
        catTitle = map['catTitle'],
        imageUrl = map['imageUrl'];
        
  Category.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
}

class SubCat {
  String brandContent;
  String brandTitle;
  String brandImage;
  final DocumentReference reference;

  SubCat({this.brandContent, this.brandTitle, this.brandImage, this.reference});

  SubCat.fromMap(Map<dynamic, dynamic> map,  {this.reference})
      : assert(map['brandTitle'] != null),
        brandContent = map['brandContent'],
        brandTitle = map['brandTitle'],
        brandImage = map['brandImg'];

        SubCat.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
}
