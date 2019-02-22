import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kscope/category/category_details.dart';
import 'package:kscope/discounts/discount_card.dart';
import 'package:kscope/models/category.dart';
import 'package:kscope/my_strings.dart';

class CategoryUI extends StatefulWidget {
  final Category category;
  CategoryUI({@required this.category});

  @override
  _CategoryUIState createState() => new _CategoryUIState();
}

class _CategoryUIState extends State<CategoryUI> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  

  @override
  Widget build(BuildContext context) {
    double cardHeight = MediaQuery.of(context).size.height * 0.30;
     double screenHeight = MediaQuery.of(context).size.height * 0.832;
    //double screenWidth = MediaQuery.of(context).size.height * 0.952;

    Widget _buildBlogListItem(BuildContext context, DocumentSnapshot data) {
      final subCat = SubCat.fromSnapshot(data);
      return new Container(
        width: 400,
        padding: const EdgeInsets.only(left: 5.0),
        child: new CatCard(
          subCat: subCat,
          height: cardHeight,
          radius: 30.0,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CategoryDetails(
                    text: subCat.brandContent, img: subCat.brandImage),
              ),
            );
          },
        ),
      );
    }

    //MAPING BLOGS TO LIST AND PASSING CONTEXT
    Widget _buildBlogList(
        BuildContext context, List<DocumentSnapshot> snapshot) {
      return ListView(
        children:
            snapshot.map((data) => _buildBlogListItem(context, data)).toList(),
      );
    }

    //BLOG  WIDGET TO CREATE BLOG LIST
    Widget blog = new Column(
      children: <Widget>[
        new Container(
          height: screenHeight,
          margin: EdgeInsets.symmetric(vertical: 10.0),
          child: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
                .collection("categories")
                .document(widget.category.reference.documentID)
                .collection("subCat")
                .snapshots(),
            builder: (context, snap) {
              if (!snap.hasData) return LinearProgressIndicator();

              return _buildBlogList(context, snap.data.documents);
            },
          ),
        ),
      ],
    );

    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        backgroundColor: const Color(0xFFad1f52),
        title:  Text(widget.category.catTitle),
        centerTitle: true,
      ),
      body: blog,
    );
  }

}
