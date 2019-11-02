import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:async';
import 'encerrarviagem.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'dart:convert' show jsonDecode, utf8;

//Variáveis de Transição do Bluetooth
String lock = 'L'; //Fechar a trava da Bike
String unlock = 'U'; //Abrir a trava
String waitRent = 'R'; //Quando alguém ler o QRCode esse sinal deve ser enviado
String endTrip = 'E'; //Encerra a viagem

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
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: CameraPosition(
        target: LatLng(37.42796133580664, -122.085749655962),
        zoom: 15,
      ),
      onMapCreated: _onMapCreated,
      myLocationEnabled: true,
      compassEnabled: true,
    );
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
          if (_bluetoothState.toString().contains('STATE_ON')) {
            bluetoothDiscovery();
          } else {
            bluetoothRequest().then((value) {
              if (_bluetoothState.toString().contains('STATE_ON')) {
                bluetoothDiscovery();
              } else {
                showAlertDialog(context, 'Bluetooth desligado!',
                    'Ligue o bluetooth para terminar');
              }
            });
          }

          stopwatch.stop();
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ViagemEncerradaPage(
                  valorCorrida: price,
                  tempoCorrida: timetext,
                ),
              ));
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
        //sendMessage(endTrip);
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

  //Envia mensagem
  void _sendMessage(String text) async {
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

// class QrScan extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return QrScanState();
//   }
// }

// class QrScanState extends State<QrScan> {
//   String _barcode = "";
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text('Lector QR flutter'),
//         ),
//         body: Container(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: <Widget>[

//                       padding:
//                           EdgeInsets.symmetric(horizontal: 80, vertical: 10.0),
//                       child: RaisedButton(
//                         color: Colors.amber,
//                         textColor: Colors.black,
//                         splashColor: Colors.blueGrey,
//                         onPressed: scan,
//                         child: const Text('Scanear el código QR.'),
//                       ),
//                     ),
//                   Padding(
//                       padding:
//                           EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//                       child: Text(
//                         _barcode,
//                         textAlign: TextAlign.center,
//                         style: TextStyle(color: Colors.red),
//                       ),
//                     ),
//             ],
//           ),
//         ));
//   }
