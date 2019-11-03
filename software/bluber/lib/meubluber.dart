import 'package:flutter/material.dart';
import 'userdata.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:bluber/userdata.dart';
import 'package:http/http.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'dart:async';
import 'dart:convert' show jsonDecode, utf8;

class MeuBluberPage extends StatefulWidget {
  @override
  _MeuBluberPageState createState() => _MeuBluberPageState();
}

class _MeuBluberPageState extends State<MeuBluberPage> {
  String _barcode = ""; //Este barcode se refere ao ID da bike
  bool _disponivel = false;
  bool _trava_aberta = false;

//Funções do Bluetooth
  var bts = FlutterBluetoothSerial.instance;
  List<BluetoothDiscoveryResult> results = List<BluetoothDiscoveryResult>();
  bool discovered = false;
  String _hc05Adress = '20:16:07:25:05:13';

  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;

  String _address = "...";
  String _name = "...";

  Timer _discoverableTimeoutTimer;

  //Variáveis de conexão
  StreamSubscription<BluetoothDiscoveryResult> _streamSubscription;
  BluetoothConnection _connection;
  bool isConnected = false;
  bool bluetoothStateBool = false;

  @override
  void initState() {
    super.initState();

    // Get current state
    bts.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
    });

    bts.name.then((name) {
      setState(() {
        _name = name;
      });
    });

    // Listen for futher state changes
    bts.onStateChanged().listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;
      });
    });
  }

  @override
  void dispose() {
    bts.setPairingRequestHandler(null);
    //_connection.close();
    _discoverableTimeoutTimer?.cancel();
    _streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if(ativada == null || ativada == 'false'){
      _disponivel = false;
    }else{
      _disponivel = true;
    }

    if (bike != null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Meu Bluber'),
        ),
        body: _preferenciasList(),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('Meu Bluber'),
        ),
        body: Center(
          child: Text(
            'Adicione seu Bluber clicando no botão abaixo.',
            style: TextStyle(fontSize: 20),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.grey,
          label: Text('Adicionar novo Bluber'),
          onPressed: () {
            scan().then((value) {
              cadastroBike(email, _barcode);
            });
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      );
    }
  }

  Widget _preferenciasList() {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        SwitchListTile(
          title: Text('Disponibilizar meu Bluber para locação'),
          value: _disponivel,
          onChanged: (bool disponivel) {
            setState(() {
              _disponivel = disponivel;
              if (disponivel) {
                _trava_aberta = false;
              }
              print(_disponivel);
              ativaBike(email, _disponivel);
            });
          },
          secondary: Icon(Icons.directions_bike),
        ),
        SwitchListTile(
          title: Text('Abrir trava'),
          value: _trava_aberta,
          onChanged: (bool trava) {
            setState(() {
              if (_bluetoothState.toString().contains('STATE_ON')) {
                bluetoothConection(trava);
              } else {
                bluetoothRequest().then((value) {
                  if (_bluetoothState.toString().contains('STATE_ON')) {
                    print(_bluetoothState.toString());

                    bluetoothConection(trava);
                  } else {
                    showAlertDialog(context, 'Bluetooth desligado!',
                        'Ligue o bluetooth para terminar');
                  }
                });
              }

              _trava_aberta = trava;
              if (_trava_aberta) _disponivel = false;
            });
          },
          secondary: Icon(Icons.lock_open),
        ),
        Card(
          child: ListTile(
            leading: Icon(Icons.history),
            title: Text('Histórico de corridas'),
            trailing: Icon(Icons.arrow_right),
            onTap: () {
              Navigator.of(context).pushNamed('/historicobluber');
            },
          ),
        ),
      ],
    );
  }

  Future scan() async {
    try {
      await BarcodeScanner.scan().then((barcode) {
        setState(() {
          this._barcode = barcode;
        });
        print(this._barcode);
        bike = _barcode;
      }).catchError((onError) {
        print('Error.');
      });
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this._barcode = 'El usuario no dio permiso para el uso de la cámara!';
        });
      } else {
        setState(() => this._barcode = 'Error desconocido $e');
      }
    } on FormatException {
      setState(() => this._barcode =
          'nulo, el usuario presionó el botón de volver antes de escanear algo)');
    } catch (e) {
      setState(() => this._barcode = 'Error desconocido : $e');
    }
  }

  //Chama  a função de cadastrar
  cadastroBike(String _email, String _bike) async {
    String function = "cadBike";
    String email = "email=" + _email;
    String bike_id = "bike_id=" + _bike;

    print("Cadastro bike");
    String url = 'https://us-central1-bluberstg.cloudfunctions.net/' +
        function +
        '?' +
        email +
        '&' +
        bike_id;

    print(url);
    return await get(url);
  }

  //Get Rate e BikeID
  Future ativaBike(String _email, bool _status) async {
    String function = "ativaOuNaoBike";
    String email = "email=" + _email;
    String status = "liga=" + _status.toString();

    var url = 'https://us-central1-bluberstg.cloudfunctions.net/' +
        function +
        '?' +
        email +
        '&' +
        status;

    print("ativa/Desativa Bike");
    print(url.toString());
    await get(url).then((response) {
      if (response.statusCode == 200) {
        print("Resposta ok");
        ativada = _status.toString();
        // Map<String, dynamic> information = jsonDecode(response.body);
        // String _rating = information['rating'] as String;
        // String _bikeID = information['bike_id']  as String;

      } else {
        msgErro();
      }
    });
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
                Text('Erro ao ativar a sua bike!'),
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

  //Pede para ligar o bluetooth
  Future bluetoothRequest() async {
    // async lambda seems to not working
    await bts.requestEnable();
  }

  //Conecta ao dispositivo
  Future bluetoothConection(bool trava) async {
    // Some simplest connection :F
    String message;
    try {
      _connection = await BluetoothConnection.toAddress(_hc05Adress);
      isConnected = true;
      if (trava)
        message = unlock;
      else
        message = lock;
      _sendMessage(message).then((onValue) {
        setState(() {
          _trava_aberta = trava;
        });
        _connection.close();
      });
      //
      // }).catchError((onError) {
      //   isConnected = false;
      //   showAlertDialog(context, 'Não foi possível conectar no Bluber!',
      //       'Tente novamente mais tarde.');
      // });

      // connection.input.listen((Uint8List data) {
      // }).onDone(() {
      //   print('Disconnected by remote request');
      // });
    } catch (exception) {
      isConnected = false;
      showAlertDialog(context, 'Não foi possível conectar no Bluber!',
          'Tente novamente mais tarde.');
      print('Cannot connect, exception occured');
    }
  }

  showAlertDialog(BuildContext context, String title, String content) {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(content),
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  //Envia mensagem
  Future _sendMessage(String text) async {
    text = text.trim();

    if (text.length > 0) {
      try {
        _connection.output.add(utf8.encode(text + "\r\n"));
        print('Enviando texto: ' + text);
        await _connection.output.allSent;
      } catch (e) {
        // Ignore error, but notify state
      }
    }
  }
}
