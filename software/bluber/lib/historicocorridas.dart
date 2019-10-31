import 'package:bluber/userdata.dart';
import 'package:flutter/material.dart';
import 'displayimage.dart';

class HistoricoCorridasPage extends StatefulWidget {
  @override
  _HistoricoCorridasPageState createState() => _HistoricoCorridasPageState();
}

class _HistoricoCorridasPageState extends State<HistoricoCorridasPage> {
  List<List<String>> lista_historico = [
    [
      '00:00:00',
      '0,00',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/1/17/OK-button_-_Macro_photography_of_a_remote_control.jpg/220px-OK-button_-_Macro_photography_of_a_remote_control.jpg'
    ],
    [
      '00:00:01',
      '0,01',
      'https://ichef.bbci.co.uk/news/660/cpsprodpb/EF37/production/_108993216_ok-hand.jpg'
    ],
    [
      '00:00:02',
      '0,02',
      'https://images.theconversation.com/files/289953/original/file-20190828-184192-j9w2v2.jpg?ixlib=rb-1.1.0&q=45&auto=format&w=926&fit=clip'
    ]
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Histórico'),
        ),
        body: ListView.builder(
            itemCount: lista_historico.length,
            itemBuilder: (BuildContext ctxt, int index) {
              return new Card(
                child: ListTile(
                  leading: Icon(Icons.directions_bike),
                  title: Text(lista_historico[index][0]),
                  subtitle: Text(lista_historico[index][1]),
                  trailing: Icon(Icons.arrow_right),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DisplayImage(
                            imageUrl: lista_historico[index][2],
                          ),
                        ));
                  },
                ),
              );
            })
        //_corridasList(),
        );
  }

  Widget corrida(String data, String preco, String imagem_url) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.directions_bike),
        title: Text('00/00/00'),
        subtitle: Text('0,00 BTC'),
        trailing: Icon(Icons.arrow_right),
        onTap: () {},
      ),
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
