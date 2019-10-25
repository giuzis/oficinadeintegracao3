import 'package:flutter/material.dart';

class HistoricoBluberPage extends StatefulWidget {
  @override
  _HistoricoBluberPageState createState() => _HistoricoBluberPageState();
}

class _HistoricoBluberPageState extends State<HistoricoBluberPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Histórico'),
      ),
      body: _corridasList(),
    );
  }

  Widget _corridasList() {
    return ListView(
      shrinkWrap: true,
      children: const <Widget>[
        Card(
          child: ListTile(
            leading: Icon(Icons.directions_bike),
            title: Text('00/00/00'),
            subtitle: Text('0,00 BTC'),
            trailing: Icon(Icons.arrow_right),
          ),
        ),
        Card(
          child: ListTile(
            leading: Icon(Icons.directions_bike),
            title: Text('00/00/00'),
            subtitle: Text('0,00 BTC'),
            trailing: Icon(Icons.arrow_right),
          ),
        ),
        Card(
          child: ListTile(
            leading: Icon(Icons.directions_bike),
            title: Text('00/00/00'),
            subtitle: Text('0,00 BTC'),
            trailing: Icon(Icons.arrow_right),
          ),
        ),
        Card(
          child: ListTile(
            leading: Icon(Icons.directions_bike),
            title: Text('00/00/00'),
            subtitle: Text('0,00 BTC'),
            trailing: Icon(Icons.arrow_right),
          ),
        ),
        Card(
          child: ListTile(
            leading: Icon(Icons.directions_bike),
            title: Text('00/00/00'),
            subtitle: Text('0,00 BTC'),
            trailing: Icon(Icons.arrow_right),
          ),
        ),
        Card(
          child: ListTile(
            leading: Icon(Icons.directions_bike),
            title: Text('00/00/00'),
            subtitle: Text('0,00 BTC'),
            trailing: Icon(Icons.arrow_right),
          ),
        ),
      ],
    );
  }
}
