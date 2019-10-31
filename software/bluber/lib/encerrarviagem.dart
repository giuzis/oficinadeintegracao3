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

  double rating;

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
                      widget.time,
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
                      widget.price.toString() + ' BTC',
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
              initialRating: 3,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                rating = rating;
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
          getImage(context);
          encerrarCorrida(email, bikeAlugada, valorCorrida.toString());
          // Navigator.of(context).pushReplacementNamed('/homepage');
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  //Transações com o Banco
  //Google functions - Adicionar créditos na carteira
  Future encerrarCorrida(String _email, String _bike, String _valor) async {
    String function = "encerrarCorrida";
    String email = "email=" + _email;
    String bike_id = "bike_id=" + _bike;
    String valor = "valor=" + _valor;

    var url = 'https://us-central1-bluberstg.cloudfunctions.net/' +
        function +
        '?' +
        bike_id +
        '&' +
        email +
        '&' +
        valor;
    print("Encerrando Corrida");
    var response = await http.get(url);

    if (response.statusCode == 200) {
      print("Resposta ok");
      print("zerando o valor da bike");
      bikeAlugada = null;

      // Map<String, dynamic> hist = jsonDecode(response.body);
      // String _photoName = hist['name'] as String;
      // debugPrint("$hist['name']");
      // print(_photoName);

      // photoName = _photoName;

    } else {
      msgErro();
    }
  }

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
                Text('Erro ao iniciar corrida!'),
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
