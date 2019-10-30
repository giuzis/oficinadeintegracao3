import 'package:flutter/material.dart';
import 'signinsignout.dart';
import 'userdata.dart';

class CadastroWallet extends StatefulWidget {
  @override
  _CadastroWalletState createState() => _CadastroWalletState();
}

class _CadastroWalletState extends State<CadastroWallet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        width: 600,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Insira o ID da sua criptocarteira',
              style: TextStyle(fontSize: 20),
            ),
            TextFormField(
              keyboardType: TextInputType.text,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "ID da criptocarteira",
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                ),
              ),
              style: TextStyle(fontSize: 20),
              onFieldSubmitted: (value) {
                //wallet = value;
                //inserir aqui função para enviar wallet id para o banco de dados
                Navigator.of(context).pushReplacementNamed('/homepage');
              },
            ),
            Container(
              height: 20,
              alignment: Alignment.centerRight,
              child: FlatButton(
                child: Text(
                  'Sair da conta',
                  textAlign: TextAlign.right,
                ),
                onPressed: () {
                  signOutGoogle();
                  Navigator.of(context).pushReplacementNamed('/');
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
