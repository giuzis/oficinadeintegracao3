/*********** Página home page ***************/
/* Para adicionar os mapas, modifique as duas últimas funções:
    _googleMap1()
    _googleMap2()
*/

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'dart:async';
import 'dart:convert' show jsonDecode, utf8;
import 'signinsignout.dart';

//Chamando Login para pegar dados
import 'userdata.dart';
import 'package:http/http.dart' as http;
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';


//Bibliotecas usadas para notificar
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_database/firebase_database.dart';

//Variáveis de Transição do Bluetooth
String lock = 'L'; //Fechar a trava da Bike
String unlock = 'U'; //Abrir a trava
String waitRent = 'R'; //Quando alguém ler o QRCode esse sinal deve ser enviado
String endTrip = 'E'; //Encerra a viagem

// essa classe nunca é modificada
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  GoogleMapController mapController;
  Location location = Location();
  String _barcode = "";
  //Funções do Bluetooth
  StreamSubscription<BluetoothDiscoveryResult> _streamSubscription;
  List<BluetoothDiscoveryResult> results = List<BluetoothDiscoveryResult>();
  bool discovered = false;
  String _hc05Adress = '20:16:07:25:05:13';

  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;

  String _address = "...";
  String _name = "...";

  Timer _discoverableTimeoutTimer;

  //Variáveis de conexão
  BluetoothConnection _connection;
  bool isConnected = false;
  bool bluetoothStateBool = false;

//Variáveis usadas para notificar
  String textValue = 'Hello World !';
  FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();

    // Get current state
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
    });

    FlutterBluetoothSerial.instance.name.then((name) {
      setState(() {
        _name = name;
      });
    });

    // Listen for futher state changes
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;
      });
    });

    //Setup das configurações
    var android = new AndroidInitializationSettings('mipmap/ic_launcher');
    var ios = new IOSInitializationSettings();
    var platform = new InitializationSettings(android, ios);
    flutterLocalNotificationsPlugin.initialize(platform);

    firebaseMessaging.configure(
      onLaunch: (Map<String, dynamic> msg) {
        print(" onLaunch called ${(msg)}");
      },
      onResume: (Map<String, dynamic> msg) {
        print(" onResume called ${(msg)}");
      },
      onMessage: (Map<String, dynamic> msg) {
        showNotification(msg);
        print(" onMessage called ${(msg)}");
      },
    );
    firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, alert: true, badge: true));
    firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings setting) {
      print('IOS Setting Registed');
    });
    firebaseMessaging.getToken().then((token) {
      update(token);
    });
  }

  showNotification(Map<String, dynamic> msg) async {
    var android = new AndroidNotificationDetails(
      'sdffds dsffds',
      "CHANNLE NAME",
      "channelDescription",
    );
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);
    // await flutterLocalNotificationsPlugin.show(
    //     0, "Bluber", "this is demo", platform);
  }

  update(String token) {
    print(token);
    DatabaseReference databaseReference = new FirebaseDatabase().reference();
    databaseReference.child('fcm-token/${token}').set({"token": token});
    textValue = token;
    setState(() {});
  }

  @override
  void dispose() {
    FlutterBluetoothSerial.instance.setPairingRequestHandler(null);
    _discoverableTimeoutTimer?.cancel();
    super.dispose();
  }

  // aqui no build que tudo acontece
  @override
  Widget build(BuildContext context) {
    // nossa página inicial será um definida por um controle de abas
    return Scaffold(
      // característica do scaffold é a appbar já pronta (parte de cima da aplicação)
      appBar: AppBar(
        title: Text("Bluber"), //título da app
      ),

      // drawer é o "menu" onde tem o perfil do usuário e outras coisinhas
      drawer: Drawer(
        // o widget "column" permite colocar vários widgets um em cima do outro (ou embaixo dependendo do ponto de vista)
        child: Column(
          // nesse caso coloquei as funções _drawerBanner e _drawerList que retornam os widgets
          children: <Widget>[
            _drawerBanner(),
            _drawerList(),
            Padding(
              padding: EdgeInsets.only(top: 150),
              child: _signOutButton(),
            )
          ],
        ),
      ),
      // com tabview definimos o que será mostrado em cada tab
      body: _googleMap1(context),

      // é o botão que leva a outra página (nesse caso)
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blueGrey,
        icon: Icon(Icons.directions_bike),
        label: Text('Quero pedalar!'),
        onPressed: () {
          print('fora ' + _bluetoothState.toString());
          if (_bluetoothState.toString().contains('STATE_ON')) {
            bluetoothDiscovery();
          } else {
            bluetoothRequest().then((value) {
              print('DENTRO ' + _bluetoothState.toString());
              if (_bluetoothState.toString().contains('STATE_ON')) {
                bluetoothDiscovery();
              } else {
                showAlertDialog(context, 'Bluetooth desligado!',
                    'Ligue o bluetooth para começar a pedalar');
              }
            });
          }
          scan();
        },
      ),

      // com tabview definimos o que será mostrado em cada tab
      // é o botão que leva a outra página (nesse caso)
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
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

  // widget que define o banner do drawer
  Widget _drawerBanner() {
    // container para mostrar dados do perfil do usuário
    // (container é um bloco onde vc pode colocar vários widgets dentro)
    return Container(
      color: Colors.blue, // cor de fundo do container
      width: 310.0, // definição da largura
      height: 170.0, // definição da altura

      // stack para ajeitar os widgets dentro do container (funciona como uma pilha onde vc vai colocando um widget em cima do outro)
      child: Stack(
        children: <Widget>[
          // padding ajuda a alocar os widgets no lugar que queremos

          // padding da imagem do user
          Padding(
            padding: EdgeInsets.only(
                top: 70.0, left: 10.0), // define as coordenadas do widget
            child: CircleAvatar(
              radius: 30.0,
              // para adicionar imagens é necessário modficar o pubspec.yaml (linha 45 em diante)
              backgroundImage: NetworkImage(
                imageUrl,
              ),
              backgroundColor: Colors.transparent,
            ),
          ),

          // padding do nome do user
          Padding(
            padding: EdgeInsets.only(top: 75.0, left: 85.0),
            // nome do usuário
            child: Text(
              name,
              //UserData.getName(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25.0,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 105.0, left: 85.0),
            // nome do usuário
            child: Text(
              email,
              //UserData.getName(),
              style: TextStyle(
                fontSize: 15.0,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // widget que define a lista do drawer
  Widget _drawerList() {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        ListTile(
          title: Text("Minhas corridas",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.normal)),
          onTap: () {
            Navigator.of(context).pushNamed('/corridas');
          },
        ),
        ListTile(
          title: Text("Minha carteira",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.normal)),
          onTap: () {
            Navigator.of(context).pushNamed('/minhacarteira');
          },
        ),
        ListTile(
          title: Text("Meu Bluber",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.normal)),
          onTap: () {
            Navigator.of(context).pushNamed('/meubluber');
          },
        )
      ],
    );
  }

  //Google functions
  Future transacao() async {
    String function = "Litecoin_Transaction";
    String ammount = "ammount=0.001";
    String walletTo = "wallet_to=2NEUV4DsSKPYemN6GmXsFPviBZv8aKceHKD";
    String walletFrom = "wallet_from=2N5mHpm29QqFouGiJ4eLMhMFwyNrYLyPhij";

    var url = 'https://us-central1-bluberstg.cloudfunctions.net/' +
        function +
        '?' +
        ammount +
        '&' +
        walletTo +
        '&' +
        walletFrom;

    var data = await http.get(url);
  }

  // modificar essas duas funções para incluir o mapa
  // tutorial que pode ajudar https://www.youtube.com/watch?v=lNqEfnnmoHk&t=347s
  Widget _googleMap1(BuildContext context) {
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

  _animateToUser() async {
    var pos = await location.getLocation();
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(pos.latitude, pos.longitude),
          zoom: 17,
        ),
      ),
    );
  }

  Future scan() async {
    try {
      await BarcodeScanner.scan().then((barcode) {
        setState(() {
          this._barcode = barcode;
          bikeAlugada = barcode;
        });
        print(this._barcode);
        iniciaCorrida(email, _barcode).then((value){
            print("Corrida iniciada");
        });
        // Navigator.of(context).pushReplacementNamed('/emviagem');
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

  Widget _signOutButton() {
    return ListTile(
      leading: Icon(Icons.power_settings_new),
      title: Text("Sair da conta",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.normal, color: Colors.grey)),
      onTap: () {
        signOutGoogle();
        Navigator.of(context).pushReplacementNamed('/');
      },
    );
  }

  //Bluetooth
  //Pega o status do bluetooth
  Future getBluetoothState() async {
    return FlutterBluetoothSerial.instance.state; //.then((state) {
    // setState(() {
    //   bluetoothState = state;
    // });

    // if (bluetoothState.toString().contains('ON')) {
    //   bluetoothStateBool = true;
    // } else {
    //   bluetoothStateBool = false;
    // }
    //});
  }

  //Descobre os dispositivos de Bluetooth
  void bluetoothDiscovery() {
    _streamSubscription =
        FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
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

  //Pede para ligar o bluetooth
  Future bluetoothRequest() async {
    // async lambda seems to not working
    await FlutterBluetoothSerial.instance.requestEnable().then((value) {
      getBluetoothState();
    });
  }

  //Conecta ao dispositivo
  Future bluetoothConection() async {
    // Some simplest connection :F
    try {
      await BluetoothConnection.toAddress(_hc05Adress).then((connection) {
        print('Connected to the device');

        _connection = connection;
        isConnected = true;
        scan();
      }).catchError((onError) {
        isConnected = false;
        // showAlertDialog(context, 'Não foi possível conectar no Bluber!',
        //     'Tente novamente mais tarde.');
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

  //Envia mensagem
  void _sendMessage(String text) async {
    text = text.trim();

    if (text.length > 0) {
      try {
        print('Enviando texto: ' + text);
        _connection.output.add(utf8.encode(text + "\r\n"));
        await _connection.output.allSent;
      } catch (e) {
        // Ignore error, but notify state
      }
    }
  }

  //Transações com o Banco
   //Google functions - Adicionar créditos na carteira
  Future iniciaCorrida(String _email, String _bike) async {
    String function = "iniciaCorrida";
    String email = "email="+ _email;
    String bike_id = "bike_id=" + _bike;

    var url = 'https://us-central1-bluberstg.cloudfunctions.net/'+function + '?' + bike_id + '&'  + email;
    
    print(url.toString());
    print("Iniciando Corrida");
    
    await http.get(url).then((response){
          if(response.statusCode == 200){
            Map<String, dynamic> hist = jsonDecode(response.body);
            String _photoName = hist['codigo_da_viagem'] as String;
            // debugPrint("$hist");
            print(_photoName);

            photoName = _photoName;
            
          }else{
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