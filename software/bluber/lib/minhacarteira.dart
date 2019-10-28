import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:bluber/login.dart';


class MinhaCarteiraPage extends StatefulWidget {
  @override
  _MinhaCarteiraPageState createState() => _MinhaCarteiraPageState();
}

class Wallet {
  final Float saldo;
  final String walletID;

  Wallet({this.saldo, this.walletID});

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      saldo: json['userId'],
      walletID: json['wallet']
    );
  }
}

class _MinhaCarteiraPageState extends State<MinhaCarteiraPage> {
  Float saldo;
  String walletID;
  
  @override
  Widget build(BuildContext context) {
    pegaCarteira(email);
    return Scaffold(
      appBar: AppBar(
        title: Text('Minha Carteira'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsetsDirectional.only(top: 270.0, start: 0.0),
            child: Center(
                child: Text('Seu saldo', style: TextStyle(fontSize: 25))),
          ),
          Padding(
              padding: EdgeInsetsDirectional.only(top: 20.0),
              child: Text(saldo.toString(),
                  style: TextStyle(
                    fontSize: 40,
                  ))),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blueGrey,
        label: Text('Adicionar mais créditos'),
        onPressed: () {
          Navigator.of(context).pushNamed('/addcreditos');
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

//Google functions - função que retorna a carteira do usuário 
  Future pegaCarteira(String _email) async {
    String function = "getUserWallet";
    String email = "email=" + _email;

    print(_email);
    var url = 'https://us-central1-bluberstg.cloudfunctions.net/'+ function + '?' + email;

    var response = await http.get(url);

    Wallet wallet = Wallet.fromJson(json.decode(response.body));

    setState(() {
      saldo = wallet.saldo;
      walletID = wallet.walletID;
    });

    print(saldo);
    print(walletID);
    
  }

// Função que retorna o saldo da carteira do usuário
Future<String> saldoCarteira() async {
    String function = "Litecoin_Transaction";
    String ammount = "ammount=0.001";
    String walletTo = "wallet_to=2NEUV4DsSKPYemN6GmXsFPviBZv8aKceHKD";
    String walletFrom = "wallet_from=2N5mHpm29QqFouGiJ4eLMhMFwyNrYLyPhij";

    var url = 'https://us-central1-bluberstg.cloudfunctions.net/'+function + '?' + ammount + '&'  + walletTo + '&' + walletFrom;

      await http.get(url);
        //'https://us-central1-bluberstg.cloudfunctions.net/Litecoin_Transaction?ammount=0.001&wallet_to=2NEUV4DsSKPYemN6GmXsFPviBZv8aKceHKD&wallet_from=2N5mHpm29QqFouGiJ4eLMhMFwyNrYLyPhij');
  }

}
