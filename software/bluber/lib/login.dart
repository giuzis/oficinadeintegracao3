import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: Center(
        child: Container(
          height: 100,
          width: 100,
          color: Colors.white,
          child: RaisedButton(
            color: Colors.grey,
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}
