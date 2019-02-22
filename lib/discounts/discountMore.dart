import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kscope/category/category.dart';
import 'package:kscope/discounts/discount_card.dart';
import 'package:kscope/models/category.dart';

class DiscountMore extends StatefulWidget {
  @override
  DiscountState createState() => new DiscountState();
}

// SingleTickerProviderStateMixin is used for animation
class DiscountState extends State<DiscountMore> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height * 0.752;
    double cardHeight = MediaQuery.of(context).size.height * 0.34;

    var hasSubCategory = true;

    Widget _buildDiscountListItem(BuildContext context, DocumentSnapshot data) {
      final category = Category.fromSnapshot(data);

      return Column(
        children: <Widget>[
          DiscountCard(
            item: new DiscountItem(category.catTitle, category.imageUrl),
            height: 210,
            onTap: () async {
              print("categories" +
                  "/" +
                  category.reference.documentID +
                  "/" +
                  "subCat");

              QuerySnapshot querySnapshot = await Firestore.instance
                  .collection("categories")
                  .document(category.reference.documentID)
                  .collection("subCat")
                  .getDocuments();

              var list = querySnapshot.documents;
             // print(list.toString());

              if (list.length > 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoryUI(category: category),
                  ),
                );
              }
            },
          ),
        ],
      );
    }

    Widget _buildDiscountList(
        BuildContext context, List<DocumentSnapshot> snapshot) {
      return new ListView(
        //itemCount: data.length
        children: snapshot
            .map((data) => _buildDiscountListItem(context, data))
            .toList(),
      );
    }

    //VIDEO WIDGET TO CREATE VIDEO LIST
    
    return new Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          backgroundColor: const Color(0xFFad1f52),
          title: const Text("Discounts"),
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            new Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 35.0, vertical: 10.0),
              child: new Text(
                'Welcome to the discounts tab! Check out and get the kscope discount from your favourite businesses',
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(child: StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance.collection('categories').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return LinearProgressIndicator();

                  return _buildDiscountList(context, snapshot.data.documents);
                })),
          ],
        ));
  }
}
