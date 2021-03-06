// import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'userdata.dart';

class MinhaCarteiraPage extends StatefulWidget {
  @override
  _MinhaCarteiraPageState createState() => _MinhaCarteiraPageState();
}

class Wallet {
  final double credit;
  final String wallet_id;

  Wallet({this.credit, this.wallet_id});

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
        credit: json['credit'] as double,
        wallet_id: json['wallet_id'] as String);
  }
}

class _MinhaCarteiraPageState extends State<MinhaCarteiraPage> {
  final Future<Wallet> wallet;

  _MinhaCarteiraPageState({Key key, this.wallet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minha Carteira'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 300,
          ),
          Center(child: Text('Seu saldo', style: TextStyle(fontSize: 25))),
          FutureBuilder<Wallet>(
              future: fetchWallet(email),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(snapshot.data.credit.toStringAsFixed(6),
                        style: TextStyle(fontSize: 40)),
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                } else {
                  return CircularProgressIndicator();
                }
              }),
          // Container(
          //   height: 50,
          // ),
          Container(
            height: 270,
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: new Text(
                      "Adicionar créditos",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    color: Colors.blue,
                    onPressed: () {
                      Navigator.of(context).pushNamed('/addcreditos');
                    }),
                FlatButton(
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    child: new Text(
                      "Resgatar créditos",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed('/retcreditos');
                    }),
              ]),
        ],
      ),
    );
  }

//Google functions - função que retorna a carteira do usuário
  Future<String> pegaCarteira(String _email) async {
    String function = "getUserWallet";
    String email = "email=projectbluber@gmail.com";

    var url = 'https://us-central1-bluberstg.cloudfunctions.net/' +
        function +
        '?' +
        email;

    var response = await http.get(url);

    setState(() {
      var data = json.decode(response.body)['results'];
    });
  }

  Future<Wallet> fetchWallet(String _email) async {
    String function = "getUserWallet";
    String email = "email=" + _email;

    var url = 'https://us-central1-bluberstg.cloudfunctions.net/' +
        function +
        '?' +
        email;

    final response = await http.get(url);

    if (response.statusCode == 200) {
      print('pegaCarteira - 200 OK');
      pegaDadosCarteira(response);
      // se o servidor retornar um response OK, vamos fazer o parse no JSON
      return Wallet.fromJson(json.decode(response.body));
    } else {
      // se a responsta não for OK , lançamos um erro
      throw Exception('Failed to load post');
    }
  }

  void pegaDadosCarteira(http.Response response) {
    print("Estou preenchendo os dados");
    Map<String, dynamic> walletJson = jsonDecode(response.body);
    String id_wallet = walletJson['wallet_id'] as String;
  }

  // void pegaWallet() async {
  //   String function = "getUserWallet";
  //   String email = "email=projectbluber@gmail.com";

  //   var url = 'https://us-central1-bluberstg.cloudfunctions.net/' +
  //       function +
  //       '?' +
  //       email;
  //   // var url = 'https://us-central1-bluberstg.cloudfunctions.net/getUserWallet?email=projectbluber@gmail.com';

  //   final response = await http.get(url);

  //   if (response.statusCode == 200) {
  //     print('Passei aqui');
  //     // se o servidor retornar um response OK, vamos fazer o parse no JSON
  //     //return Wallet.fromJson(json.decode(response.body));

  //     Map<String, dynamic> wallet = jsonDecode(response.body);
  //     var walletID = wallet['wallet_id'];
  //     var credit = wallet['credit'];

  //     print ('walletID: ' + walletID + 'credit' + credit.toString());
  //   } else {
  //     // se a responsta não for OK , lançamos um erro
  //     throw Exception('Failed to load post');
  //   }
  // }

// // Função que retorna o saldo da carteira do usuário
//   Future<String> saldoCarteira() async {
//     String function = "Litecoin_Transaction";
//     String ammount = "ammount=0.001";
//     String walletTo = "wallet_to=2NEUV4DsSKPYemN6GmXsFPviBZv8aKceHKD";
//     String walletFrom = "wallet_from=2N5mHpm29QqFouGiJ4eLMhMFwyNrYLyPhij";

//     var url = 'https://us-central1-bluberstg.cloudfunctions.net/' +
//         function +
//         '?' +
//         ammount +
//         '&' +
//         walletTo +
//         '&' +
//         walletFrom;

//     await http.get(url);
//   }
}
