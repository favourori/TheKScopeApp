import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Terms extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        // 1
        appBar: new AppBar(
          title: new Text("Terms & Conditions"),
          // screen title
        ),
        body: new Center(
          child: new Container(
            child: new Text("Terms and Conditions Page"),
          ),
        ));
  }
}
