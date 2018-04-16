import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Center(
        child: new Text(
            'Welcome to our church!!\n We are in Boston, MA.  Come visit us.',
            style: new TextStyle(fontSize: 24.0),
            textAlign: TextAlign.center));
  }
}
