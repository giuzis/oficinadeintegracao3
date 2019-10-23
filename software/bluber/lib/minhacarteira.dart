import 'package:flutter/material.dart';

class MinhaCarteiraPage extends StatefulWidget {
  @override
  _MinhaCarteiraPageState createState() => _MinhaCarteiraPageState();
}

class _MinhaCarteiraPageState extends State<MinhaCarteiraPage> {
  @override
  Widget build(BuildContext context) {
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
              child: Text('0,00 BTC',
                  style: TextStyle(
                    fontSize: 40,
                  ))),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blueGrey,
        label: Text('Adicionar mais créditos'),
        onPressed: () {
          Navigator.of(context).pushReplacementNamed('/addcreditos');
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
