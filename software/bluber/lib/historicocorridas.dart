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
      'giuliana.martins23@gmail.com_jamelabike_31_10_2019_20_18'
    ],
    [
      '00:00:01',
      '0,01',
      'giuliana.martins23@gmail.com_jamelabike_31_10_2019_20_18'
    ],
    [
      '00:00:02',
      '0,02',
      'giuliana.martins23@gmail.com_jamelabike_31_10_2019_20_18'
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
                            imageName: lista_historico[index][2],
                          ),
                        ));
                  },
                ),
              );
            })
        //_corridasList(),
        );
  }
}
