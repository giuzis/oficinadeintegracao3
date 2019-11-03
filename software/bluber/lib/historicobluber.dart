import 'package:flutter/material.dart';
import 'displayimage.dart';
import 'package:http/http.dart';
import 'userdata.dart';
import 'dart:convert' show jsonDecode;

// class Viagem 
// {
//   String bike_id;
//   String cliente;
//   String data_e_hora_fim;
//   String data_e_hora_inicio;
//   String preco;
//   String photoName;
  
//   Viagem(this.bike_id, this.cliente, this.data_e_hora_fim, this.data_e_hora_inicio, this.preco, this.photoName);
// }


class HistoricoBluberPage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HistoricoBluberPage>{

  @override
  Widget build(BuildContext context) {
    
    // if(!pegouHistorico){
      // pegaHisto(email, "viagens_comsuabike");  
    // }
    
    return Scaffold(
        appBar: AppBar(
          title: Text('Histórico'),
        ),
        body: ListView.builder(
            itemCount: lista_historico_meu_bluber.length,
            itemBuilder: (BuildContext ctxt, int index) {
              return new Card(
                child: ListTile(
                  leading: Icon(Icons.directions_bike),
                  title: Text(lista_historico_meu_bluber[index].cliente),
                  subtitle: Text(lista_historico_meu_bluber[index].data_e_hora_inicio),
                  trailing: Icon(Icons.arrow_right),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DisplayImage(
                            imageName: lista_historico_meu_bluber[index].photoName,
                          ),
                        ));
                  },
                ),
              );
            }));
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