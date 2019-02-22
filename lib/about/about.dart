import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        // 1
        appBar: new AppBar(
          title: new Text("About KScope"),
          // screen title
        ),
         body: new Center(
          child: new Container(
            child: new Text("About KScope Page"),
          ),
        ));

  }
}
