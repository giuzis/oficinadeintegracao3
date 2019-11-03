import 'package:flutter/material.dart';
import 'displayimage.dart';
import 'package:http/http.dart';
import 'userdata.dart';
import 'dart:convert' show jsonDecode;
import 'package:bluber/userdata.dart';


class HistoricoCorridasPage extends StatefulWidget {
  @override
  _HistoricoCorridasPageState createState() => _HistoricoCorridasPageState();
}

class _HistoricoCorridasPageState extends State<HistoricoCorridasPage> {
  //final ref = FirebaseStorage.instance.ref().child('testimage');
  // bool pegouHistorico = false;

  // [
  //   [
  //     '00:00:00',
  //     '0,00',
  //     'https://upload.wikimedia.org/wikipedia/commons/thumb/1/17/OK-button_-_Macro_photography_of_a_remote_control.jpg/220px-OK-button_-_Macro_photography_of_a_remote_control.jpg'
  //   ],
  //   [
  //     '00:00:01',
  //     '0,01',
  //     'https://ichef.bbci.co.uk/news/660/cpsprodpb/EF37/production/_108993216_ok-hand.jpg'
  //   ],
  //   [
  //     '00:00:02',
  //     '0,02',
  //     'https://images.theconversation.com/files/289953/original/file-20190828-184192-j9w2v2.jpg?ixlib=rb-1.1.0&q=45&auto=format&w=926&fit=clip'
  //   ]
  // ];

  @override
  Widget build(BuildContext context) {

    // if(!pegouHistorico){
    //   pegaHisto(email, "viagens_pessoais");
    // }

    return Scaffold(
    appBar: AppBar(
      title: Text('Histórico'),
    ),
    body: ListView.builder(
        itemCount: lista_historico_corridas.length,
        itemBuilder: (BuildContext ctxt, int index) {
          return new Card(
            child: ListTile(
              leading: Icon(Icons.directions_bike),
              title: Text(lista_historico_corridas[index].bike_id),
              subtitle: Text(lista_historico_corridas[index].data_e_hora_inicio),
              trailing: Icon(Icons.arrow_right),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => 
                      DisplayImage(
                        imageName: lista_historico_corridas[index].photoName
                      ),
                    )
                  );
              },
            ),
          );
        })
    //_corridasList(),
    );
  }

//   Future<void> msgErro() async {
//     return showDialog<void>(
//       context: context,
//       barrierDismissible: false, // user must tap button!
//       builder: (BuildContext context) {
//         return AlertDialog(
//           //title: Text('Rewind and remember'),
//           content: SingleChildScrollView(
//             child: ListBody(
//               children: <Widget>[
//                 Text('Erro ao receber o Histório de Corridas!'),
//               ],
//             ),
//           ),
//           actions: <Widget>[
//             FlatButton(
//               child: Text('Ok'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }


// Future pegaHisto(String _email, String _pref) {

//     String function = "retornaHistorico";
//     String email = "email="+_email;
//     String pref = "historico="+_pref;


//     var url = 'https://us-central1-bluberstg.cloudfunctions.net/' +
//         function + '?' + email + '&' + pref;

//     get(url).then((response){
//         if (response.statusCode == 200) {
//           print("Resposta ok");

//           Map<String, dynamic> corridas = jsonDecode(response.body);

//           String len = corridas.keys.toString();
//           len = len.replaceAll("(", "");
//           len = len.replaceAll(")", "");
//           len = len.replaceAll(" ", "");
//           List<String> _corrida = len.split(",");
          
//           debugPrint("$corridas");
          
//           final int numCorridas = _corrida.length;
//           // print(numCorridas);

//           for(int i=0;i<numCorridas;i++){
//             String corridaAtual = _corrida[i].toString().replaceAll(" ", "");
//             print(corridaAtual.toString());
//               String bike_id = corridas[corridaAtual]['bike_id'];
//               String cliente = corridas[_corrida[i]]['cliente'];
//               String data_e_hora_fim = corridas[_corrida[i]]['data_e_hora_fim'];
//               String data_e_hora_inicio = corridas[_corrida[i]]['data_e_hora_inicio'];
//               String preco = corridas[_corrida[i]]['preco'];
//               String photoName = _corrida[i].toString();
            
//             lista_historico_corridas.add(new Viagem(bike_id, 
//                                           cliente, 
//                                           data_e_hora_fim, 
//                                           data_e_hora_inicio, preco, photoName));

//           }

//         } else {
//           msgErro();
//       }
//     });
//   }

}
