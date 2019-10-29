import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'userdata.dart';
import 'signinsignout.dart';
// import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

// Variáveis usadas para enviar dados ao DB
final databaseReference = FirebaseDatabase.instance.reference();

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    signInWithGoogle().whenComplete(() {
      // createRecord();
      wallet = '2NEUV4DsSKPYemN6GmXsFPviBZv8aKceHKD';
      print('AAAAAAAAAAAAAAAAAAAAAAAAAAAAAQUI');

      print(name);
      print(email);
      print(wallet);

      cadastro(name, email, wallet);
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
            //_signInButton()
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
          // verificar se a pessoa já tem uma wallet cadastrada em seu nome
          String wallet = '2NEUV4DsSKPYemN6GmXsFPviBZv8aKceHKD';
          cadastro(name, email, wallet);
          Navigator.of(context).pushReplacementNamed('/cadastrowallet');
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
        ", email: " +
        _email +
        ", wallet: " +
        _wallet);

    String http = 'https://us-central1-bluberstg.cloudfunctions.net/' +
        function +
        '?' +
        email +
        '&' +
        wallet;

    return await get(http);
    //'https://us-central1-bluberstg.cloudfunctions.net/Litecoin_Transaction?ammount=0.001&wallet_to=2NEUV4DsSKPYemN6GmXsFPviBZv8aKceHKD&wallet_from=2N5mHpm29QqFouGiJ4eLMhMFwyNrYLyPhij');
  }
}
