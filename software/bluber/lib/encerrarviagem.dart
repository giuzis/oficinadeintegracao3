import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'userdata.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show jsonDecode, utf8;

// QR Code page
class ViagemEncerradaPage extends StatefulWidget {
  final double valorCorrida;
  final String tempoCorrida;
  ViagemEncerradaPage(
      {Key key, @required this.valorCorrida, @required this.tempoCorrida})
      : super(key: key);
  @override
  _ViagemEncerradaPageState createState() => _ViagemEncerradaPageState();
}

class _ViagemEncerradaPageState extends State<ViagemEncerradaPage> {
  String _uploadedFileURL;
  File _image;

  double rating = 3;

  //Image Picker
  Future getImage(context) async {
    await (ImagePicker.pickImage(source: ImageSource.camera)).then((image) {
      setState(() {
        _image = image;
      });

      uploadFile();
    });

    Navigator.of(context).pushReplacementNamed('/homepage');
  }

  Future uploadFile() async {
    // final String fileName = "test";

    StorageReference storageReference =
        FirebaseStorage.instance.ref().child(photoName);
    StorageUploadTask uploadTask = storageReference.putFile(_image);

    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        _uploadedFileURL = fileURL;
      });

      photoName = "";
    });

    print(_uploadedFileURL);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Viagem encerrada")),
      ),
      body: Column(
        children: <Widget>[
          Container(
            color: Colors.blue,
            height: 80.0,
            width: 500.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Icon(
                      Icons.timer,
                      color: Colors.white,
                      size: 30,
                    ),
                    Text(
                      widget.tempoCorrida,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 40.0,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      widget.valorCorrida.toStringAsFixed(5) + ' BTC',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25.0,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '0,00001 BTC/min',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.only(top: 230.0, start: 00.0),
            child: Text(
              "Por favor, avalie a bicicleta",
              style: TextStyle(fontSize: 30.0),
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.only(top: 20.0, start: 00.0),
            child: RatingBar(
              initialRating: rating,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (_rating) {
                rating = _rating;
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blueGrey,
        icon: Icon(Icons.directions_bike),
        label: Text('Finalizar avaliação'),
        onPressed: () {
          getImage(context).then((value) {
            print(rating.toString());
            print(widget.valorCorrida.toString());
            encerrarCorrida(photoName, rating.toString(),
                    widget.valorCorrida.toString())
                .then((value) {
              Navigator.of(context).pushReplacementNamed('/homepage');
            });
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  //Transações com o Banco
  //Google functions - Adicionar créditos na carteira
  Future encerrarCorrida(
      String _photoName, String _rating, String _valor) async {
    String function = "finalizaCorrida";
    String photoName = "history=" + _photoName;
    String rating = "rating=" + _rating;
    String valor = "amount=" + _valor;

    var url = 'https://us-central1-bluberstg.cloudfunctions.net/' +
        function +
        '?' +
        photoName +
        '&' +
        rating +
        '&' +
        valor;

    print(url.toString());

    print("Encerrando Corrida");
    await http.get(url).then((response) {
      if (response.statusCode == 200) {
        print("Resposta ok");
        print("zerando o valor da bike");
        bikeAlugada = null;

        Map<String, dynamic> rate = jsonDecode(response.body);
        String _rating = rate['rating'] as String;
        debugPrint("$rate");
        // print(_rating);

        userRate = _rating;
        // _sendMessage(endTrip);

      } else {
        msgErro();
      }
    });
  }

  //   //Envia mensagem
  // void _sendMessage(String text) async {
  //   text = text.trim();

  //   if (text.length > 0) {
  //     try {
  //       print('Enviando texto: ' + text);
  //       _connection.output.add(utf8.encode(text + "\r\n"));
  //       await _connection.output.allSent;
  //     } catch (e) {
  //       // Ignore error, but notify state
  //     }
  //   }
  // }

  Future<void> msgErro() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          //title: Text('Rewind and remember'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Erro ao encerrar corrida!'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
