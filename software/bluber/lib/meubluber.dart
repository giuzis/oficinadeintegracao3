import 'package:flutter/material.dart';

class MeuBluberPage extends StatefulWidget {
  @override
  _MeuBluberPageState createState() => _MeuBluberPageState();
}

class _MeuBluberPageState extends State<MeuBluberPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meu Bluber'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.grey,
        label: Text('Adicionar novo Bluber'),
        onPressed: (){

        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: 
              _corridasList(),
    );
  }

   Widget _corridasList() {
    return ListView(
      shrinkWrap: true,
      children: const <Widget>[
    Card(
      child: ListTile(
        title: Text('00/00/00'),
        trailing: Text('0,00 BTC'),
      ),
    ),
    Card(
      child: ListTile(
        title: Text('00/00/00'),
        trailing: Text('0,00 BTC'),
      ),
    ),
    Card(
      child: ListTile(
        title: Text('00/00/00'),
        trailing: Text('0,00 BTC'),
      ),
    ),
    Card(
      child: ListTile(
        title: Text('00/00/00'),
        trailing: Text('0,00 BTC'),
      ),
    ),
    Card(
      child: ListTile(
        title: Text('00/00/00'),
        trailing: Text('0,00 BTC'),
      ),
    ),
    Card(
      child: ListTile(
        title: Text('00/00/00'),
        trailing: Text('0,00 BTC'),
      ),
    ),
  ],
    );
   }
}

