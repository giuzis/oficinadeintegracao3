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
          height: 60,
          width: 400,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: SizedBox.expand(
            child: FlatButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Login com Google",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  Container(
                    child: SizedBox(
                      child: Image.asset("images/google-icon-1.png"),
                      height: 28,
                      width: 28,
                    ),
                  )
                ],
              ),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/homepage');
              },
            ),
          ),
        ),
      ),
    );
  }
}
