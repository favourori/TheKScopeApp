import 'package:flutter/material.dart';
import 'package:kscope/models/category.dart';

class DiscountCard extends StatelessWidget {
  final DiscountItem item;
  final double height;
  final GestureTapCallback onTap;
  final double radius;

  DiscountCard({@required this.item, @required this.height, this.onTap, this.radius = 17.0});

  @override
  Widget build(BuildContext context) {
    return new Container(
      height: height,
      child: new InkWell(
        onTap: onTap,
        child: new Card(
          margin: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
          shape: new RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
          elevation: 8.0,
          child: new Stack(
            children: <Widget>[
              new Positioned.fill(
                  child: new Image.asset(
                'assets/images/${item.img}',
                fit: BoxFit.cover,
              )),
              new Positioned.fill(
                  child: new Container(
                color: Colors.black38,
              )),
              new Positioned.fill(
                  child: new Center(
                child: new Text(
                  item.title,
                  style: const TextStyle(color: Colors.white, fontSize: 20.0),
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}

class DiscountItem {
  final String title;
  final String img;

  DiscountItem(this.title, this.img);
}

class CatCard extends StatelessWidget {
  final SubCat subCat;
  final double height;
  final GestureTapCallback onTap;
  final double radius;

  CatCard({@required this.subCat, @required this.height, this.onTap, this.radius = 17.0});

  @override
  Widget build(BuildContext context) {
    return new Container(
      height: height,
      child: new InkWell(
        onTap: onTap,
        child: new Card(
          margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
          shape: new RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
          elevation: 8.0,
          child: new Stack(
            children: <Widget>[
              new Positioned.fill(
                  child: new Image.asset(
                'assets/images/${subCat.brandImage}',
                fit: BoxFit.cover,
              )),
              new Positioned.fill(
                  child: new Container(
                color: Colors.black38,
              )),
              new Positioned.fill(
                  child: new Center(
                child: new Text(
                  subCat.brandTitle,
                  style: const TextStyle(color: Colors.white, fontSize: 20.0),
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
