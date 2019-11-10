import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:async';
import 'encerrarviagem.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'dart:convert' show jsonDecode, utf8;
import 'userdata.dart';

//import 'package:slider/slider_button.dart';
class EmViagemPage extends StatefulWidget {
  @override
  _EmViagemPageState createState() => _EmViagemPageState();
}

class _EmViagemPageState extends State<EmViagemPage> {
  GoogleMapController mapController;
  Location location = Location();

  bool isRunning = true;
  String timetext = '00:00:00';
  String pricetext = '0,00002';
  double price = 0.00002;
  var stopwatch = Stopwatch();
  final duration = Duration(seconds: 1);

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

    stopwatch.start();
    startTimer();

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
    stopwatch.reset();
    isRunning = false;
    super.dispose();
  }

  void startTimer() {
    Timer(duration, keepRunning);
  }

  keepRunning() {
    if (isRunning) {
      startTimer();

      setState(() {
        timetext = stopwatch.elapsed.inHours.toString().padLeft(2, '0') +
            ':' +
            (stopwatch.elapsed.inMinutes % 60).toString().padLeft(2, '0') +
            ':' +
            (stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, '0');
        price = (stopwatch.elapsed.inMinutes * 0.00001) + 0.00002;
        pricetext = price.toStringAsFixed(5);
      });
    }
  }

  Widget _googleMap(BuildContext context) {
    Set<Circle> circles = new Set<Circle>();
    circles.add(
      Circle(
        circleId: CircleId('Geofencing'),
        fillColor: Colors.black26,
        center: localizacao,
        radius: 1000,
        strokeColor: Colors.black38,
        strokeWidth: 3,
      ),
    );
    GoogleMap map = new GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: CameraPosition(
        target: localizacao,
        zoom: 15,
      ),
      onMapCreated: _onMapCreated,
      myLocationEnabled: true,
      compassEnabled: true,
      circles: circles,
    );

    return map;
  }

  _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Em viagem...")),
      ),
      body: Stack(
        children: <Widget>[
          _googleMap(context),
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
                      timetext,
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
                      pricetext + ' BTC',
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
          // Padding(
          //   padding: EdgeInsetsDirectional.only(top: 640.0, start: 130.0),
          //   child: RaisedButton(
          //     onPressed: () {
          //       Navigator.of(context).pushReplacementNamed('/encerrarviagem');
          //     },
          //     child: Text('Encerrar viagem', style: TextStyle(fontSize: 20)),
          //   ),
          // ),
          //para usar com a biblioteca "slider_button" instalada
          // Padding(
          //   padding: EdgeInsetsDirectional.only(top: 640.0, start: 70.0),
          // child: SliderButton(
          //   buttonColor: Colors.blue,
          //   backgroundColor: Colors.grey,
          //   highlightedColor: Colors.white,
          //   baseColor: Colors.white,
          //   width: 300,
          //   icon: Center(
          //     child: Icon(
          //       Icons.arrow_forward,
          //       color: Colors.white,
          //     ),
          //   ),
          //   action: () {
          //     Navigator.of(context).pushReplacementNamed('/');
          //   },
          //   label: Text(
          //     "Deslize para terminar a corrida",
          //     style: TextStyle(
          //         color: Colors.white,
          //         fontWeight: FontWeight.w500,
          //         fontSize: 17),
          //   ),
          // ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blueGrey,
        icon: Icon(Icons.directions_bike),
        label: Text('Encerrar viagem!'),
        onPressed: () {
          if (bluetooth_ativado) {
            if (_bluetoothState.toString().contains('STATE_ON')) {
              //bluetoothDiscovery();
              bluetoothConection();
              //stopwatch.stop();

              showAlertDialogEncerrar(
                  context,
                  "Certifique-se de estacionar a bicicleta dentro da área permitida.",
                  "A área permitida está delimitada em cinza no mapa.");
            } else {
              bluetoothRequest().then((value) {
                if (_bluetoothState.toString().contains('STATE_ON')) {
                  //bluetoothDiscovery();
                  bluetoothConection();
                  //stopwatch.stop();

                  showAlertDialogEncerrar(
                      context,
                      "Certifique-se de estacionar a bicicleta dentro da área permitida.",
                      "A área permitida está delimitada em cinza no mapa.");
                } else {
                  showAlertDialog(context, 'Bluetooth desligado!',
                      'Ligue o bluetooth para terminar');
                }
              });
            }
          } else {
            showAlertDialogEncerrar(
                context,
                "Certifique-se de estacionar a bicicleta dentro da área permitida.",
                "A área permitida está delimitada em cinza no mapa.");
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  //Pede para ligar o bluetooth
  Future bluetoothRequest() async {
    // async lambda seems to not working
    await bts.requestEnable();
  }

  void bluetoothDiscovery() {
    _streamSubscription = bts.startDiscovery().listen((r) {
      results.add(r);
    });

    print('Procurando HC-05');
    for (int i = 0; i < results.length; i++) {
      if (results[i].device.address == _hc05Adress) {
        discovered = true;
      }
    }

    if (discovered) {
      bluetoothConection();
    } else {
      isConnected = false;
      showAlertDialog(context, 'Não foi possível conectar no Bluber!',
          'Tente novamente mais tarde.');
    }
  }

  //Conecta ao dispositivo
  Future bluetoothConection() async {
    // Some simplest connection :F
    try {
      await BluetoothConnection.toAddress(_hc05Adress).then((connection) {
        print('Connected to the device');

        _connection = connection;
        isConnected = true;
        //
        //mandar mensagem de lock bike e end trip
        //sendMessage(lock);
        _sendMessage(endTrip).then((onValue) {
          showAlertDialogEncerrar(
              context,
              "Certifique-se de estacionar a bicicleta dentro da área permitida.",
              "A área permitida está delimitada em cinza no mapa.");
        });
        //
      }).catchError((onError) {
        isConnected = false;
        showAlertDialog(context, 'Não foi possível conectar no Bluber!',
            'Tente novamente mais tarde.');
      });

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

  showAlertDialogEncerrar(BuildContext context, String title, String content) {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        FlatButton(
          child: Text('Ok!'),
          onPressed: () {
            stopwatch.stop();
            if (bluetooth_ativado) _connection.close();
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViagemEncerradaPage(
                    valorCorrida: price,
                    tempoCorrida: timetext,
                  ),
                ));
          },
        )
      ],
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
