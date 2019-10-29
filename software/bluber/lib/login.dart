import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'userdata.dart';
import 'signinsignout.dart';
import 'package:http/http.dart';

class ExistWallet {
  final bool exists;

  ExistWallet({this.exists});

  factory ExistWallet.fromJson(Map<String, dynamic> json) {
    return ExistWallet(exists: json['exists']);
  }
}

// Variáveis usadas para enviar dados ao DB
final databaseReference = FirebaseDatabase.instance.reference();

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final Future<ExistWallet> existWallet;
  _LoginPageState({Key key, this.existWallet});

  @override
  Widget build(BuildContext context) {
    signInWithGoogle().whenComplete(() {
      // createRecord();
      wallet = '2NEUV4DsSKPYemN6GmXsFPviBZv8aKceHKD';
      print(name + " " + email + " " + wallet);
      cadastro(name, email, wallet);
      var existWallet = fetchExistWallet(email);

      print(existWallet);

      Navigator.of(context).pushReplacementNamed('/cadastrowallet');
    });

    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlutterLogo(size: 150),
            SizedBox(height: 50),
            // _signInButton()
          ],

          // height: 60,
          // width: 400,
          // decoration: BoxDecoration(
          //   color: Colors.white,
          //   borderRadius: BorderRadius.all(
          //     Radius.circular(10),
          //   ),
          // ),
          // child: SizedBox.expand(
          //   child: FlatButton(
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: <Widget>[
          //         Text(
          //           "Login com Google",
          //           style: TextStyle(
          //             fontWeight: FontWeight.bold,
          //             color: Colors.black54,
          //             fontSize: 20,
          //           ),
          //           textAlign: TextAlign.left,
          //         ),
          //         Container(
          //           child: SizedBox(
          //             child: Image.asset("images/google-icon-1.png"),
          //             height: 28,
          //             width: 28,
          //           ),
          //         )
          //       ],
          //     ),
          //     onPressed: () {
          //       Navigator.of(context).pushReplacementNamed('/homepage');
          //     },
          //   ),
          // ),
        ),
      ),
    );
  }

  Widget _signInButton() {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () {
        signInWithGoogle().whenComplete(() {
          // createRecord();
          print("estou aqui");
          String wallet = '2NEUV4DsSKPYemN6GmXsFPviBZv8aKceHKD';
          // print(name + " " + email + " " + wallet);
          // cadastro(name, email, wallet);
          Navigator.of(context).pushReplacementNamed('/homepage');
        });
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("images/google_logo.png"), height: 35.0),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Sign in with Google',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  //Chama  a função de cadastrar
  cadastro(String _name, String _email, String _wallet) async {
    String function = "createUser";
    // String name = "name="+ _name;
    String email = "email=" + _email;
    String wallet = "wallet_id=" + _wallet;

    print("Cadastrando -  name: " +
        _name +
        "email: " +
        _email +
        "wallet" +
        _wallet);

    String url = 'https://us-central1-bluberstg.cloudfunctions.net/' +
        function +
        '?' +
        email +
        '&' +
        wallet;
    print(url);
    return await get(url);
  }

  //Chama  a função de cadastrar
  Future<bool> fetchExistWallet(String _email) async {
    String function = "userWalletExists";
    String email = "email=" + _email;

    print("Exist wallet?");

    String url = 'https://us-central1-bluberstg.cloudfunctions.net/' +
        function +
        '?' +
        email +
        '&' +
        wallet;

    print(url);
    var response = await get(url);
    print(response.toString());
    return true;

    if (response.statusCode == 200) {
      // se o servidor retornar um response OK, vamos fazer o parse no JSON
      var data = ExistWallet.fromJson(json.decode(response.body));
      var status = data.exists;
    } else {
      // se a responsta não for OK , lançamos um erro
      throw Exception('Failed to load post');
    }
  }
}
