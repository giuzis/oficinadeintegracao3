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
  bool retornoDaWallet;

  @override
  void initState() {
    entrarComGoogle();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: <Widget>[
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/login.png'), fit: BoxFit.fitWidth),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 500, left: 100),
          child: _signInButton(),
        ),
      ]),
    );
  }

  Widget _signInButton() {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () {
        entrarComGoogle();
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
  Future existWallet(String _email) async {
    String function = "userWalletExists";
    String email = "email=" + _email;

    String url = 'https://us-central1-bluberstg.cloudfunctions.net/' +
        function +
        '?' +
        email;

    print("Exist wallet?");

    await get(url).then((response) {
      if (response.statusCode == 200) {
        // se o servidor retornar um response OK, vamos fazer o parse no JSON
        print("Response 200");
        Map<String, dynamic> exist = jsonDecode(response.body);
        bool walletExists = exist['exists'];
        // debugPrint("$exist");
        // var data = ExistWallet.fromJson(json.decode(response.body));
        // var status = data.exists;
        print(walletExists.toString());
        if (walletExists.toString() == "true") {
          retornoDaWallet = true;
        } else {
          retornoDaWallet = false;
        }
      } else {
        print("Response not 200");
        // se a responsta não for OK , lançamos um erro
        // throw Exception('Failed to load post');
        print("Erro");
      }
    });
  }

  showAlertDialog(BuildContext context, String title, String content) {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(content),
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void entrarComGoogle() {
    signInWithGoogle().whenComplete(() {
      print("Antes da chamada");

      existWallet(email).then((value) {
        print(retornoDaWallet);

        if (retornoDaWallet) {
          print("Não preciso fazer cadastro");
          Navigator.of(context).pushReplacementNamed('/homepage');
        } else {
          print("Cadastrando");
          Navigator.of(context).pushReplacementNamed('/cadastrowallet');
          // wallet = '2NCuqAQyEtYb3oEpzZvF1KpE2rGLbCHMsnG';
          // print(name + " " + email + " " + wallet);
          // cadastro(name, email, wallet);
        }
      });
      print("Depois da chamada");
    }).catchError((onError) {
      showAlertDialog(context,
          'Você precisa se conectar a uma conta para usar o Bluber!', '');
    });
  }
}
