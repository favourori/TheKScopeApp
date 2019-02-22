import 'package:flutter/material.dart';

class CategoryDetails extends StatefulWidget {
  final String text;
  final String img;

  CategoryDetails({this.text, this.img});

  @override
  State<StatefulWidget> createState() => new _CategoryDetailsState();
}

class _CategoryDetailsState extends State<CategoryDetails> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    
    const cardMargin =
        const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0);

    return new Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: new AppBar(
        backgroundColor: const Color(0xFFad1f52),
        title:  Text(widget.text),
        centerTitle: true,
      ),
      body: new SingleChildScrollView(
        child: new Column(
          children: <Widget>[
            new Card(
              elevation: 3.0,
              margin: cardMargin,
              shape: new RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(1.0)),
              child: new Image.asset(
                'assets/images/${widget.img}',
                height: 400.0,
                fit: BoxFit.cover,
              ),
            ),
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
                child: Text(
                  widget.text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(height: 1.2),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
