import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Support extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        // 1
        appBar: new AppBar(
          title: new Text("Contact & Support"),
          // screen title
        ),
        body: new Center(
          child: new Container(
            child: new Text("Contact & Support Page"),
          ),
        ));
  }
}
