import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Notify extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        // 1
        appBar: new AppBar(
          title: new Text("Notifications"),
          // screen title
        ),
        body: new Center(
          child: new Container(
            child: new Text("Your have no Notifications Currently"),
          ),
        ));
  }
}
