import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter_launcher_icons/android.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'dart:async';
import 'dart:convert' show jsonDecode, utf8;
import 'signinsignout.dart';
// import 'dart:math';

//Chamando Login para pegar dados
import 'userdata.dart';
import 'package:http/http.dart' as http;
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';

//Importando página de histórico para chamar a função
import 'package:bluber/userdata.dart';

//Bibliotecas usadas para notificar
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_database/firebase_database.dart';

// essa classe nunca é modificada
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

typedef Marker MarkerUpdateAction(Marker marker);

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  //Variáveis usadas para o Google maps
  GoogleMapController mapController;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  MarkerId selectedMarker;
  Location location = Location();

  // var myLocation = new Location();
  // int _markerIdCounter = 1;
  static final LatLng center = const LatLng(-25.438376, -49.263781);
  BitmapDescriptor myIcon;
  BitmapDescriptor myBikeIcon;
  BitmapDescriptor inactiveBikeIcon;
  BitmapDescriptor bikeAlugadaIcon;
  bool bikesUpdated = false;
  bool pegouHistorico = false;

  //Variável que pega a leitura do QRCode
  String _barcode = "";
  bool getInformationFlag = false;

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

//Variáveis usadas para notificar
  String textValue = 'Hello World !';
  FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();

    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(48, 48)), 'images/MybikeIcon.png')
        .then((onValue) {
      myIcon = onValue;
    });

    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(48, 48)), 'images/myBike3.png')
        .then((onValue) {
      myBikeIcon = onValue;
    });

    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(48, 48)), 'images/inactive-bike.png')
        .then((onValue) {
      inactiveBikeIcon = onValue;
    });

    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(48, 48)), 'images/Bike_alugada.png')
        .then((onValue) {
      bikeAlugadaIcon = onValue;
    });

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

    if (!getInformationFlag) {
      //Esta função pega a rating e o bike ID
      getInformation(email);
    }

    if (!bikesUpdated) {
      //Pega as bicicletas ativas
      adicicionaBikes(email);
    }

    // clearList().then((value){
    if (!pegouHistorico) {
      pegaHistoPessoais(email);
      pegaHistoMeuBluber(email);
    }
    // });
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
  }

  @override
  void dispose() {
    bts.setPairingRequestHandler(null);
    //_connection.close();
    //_discoverableTimeoutTimer?.cancel();
    //_streamSubscription?.cancel();
    super.dispose();
  }

  // aqui no build que tudo acontece
  @override
  Widget build(BuildContext context) {
    // if (!getInformationFlag) {
    //   //Esta função pega a rating e o bike ID
      getInformation(email);
    // }

    // if (!bikesUpdated) {
    //   //Pega as bicicletas ativas
      adicicionaBikes(email);
    // }

    // // clearList().then((value){
    // if (!pegouHistorico) {
    //   pegaHistoPessoais(email);
    //   pegaHistoMeuBluber(email);
    // }
    // // });

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
              //padding: EdgeInsets.only(top: 150),
              padding: EdgeInsets.only(top: 370),
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
          getBluetoothState();
          print('fora ' + _bluetoothState.toString());
          if (_bluetoothState.toString().contains('STATE_ON')) {
            //bluetoothDiscovery();
            bluetoothConection();
          } else {
            bluetoothRequest().then((value) {
              getBluetoothState();
              print('DENTRO ' + _bluetoothState.toString());
              if (_bluetoothState.toString().contains('STATE_ON')) {
                bluetoothConection();
                // bluetoothDiscovery();
              } else {
                showAlertDialog(context, 'Bluetooth desligado!',
                    'Ligue o bluetooth para começar a pedalar');
              }
            });
          }
          //scan();
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
              style: TextStyle(
                fontSize: 15.0,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 100.0, left: 85.0),
            // nota do usuário
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.star,
                  color: Colors.yellow,
                  size: 20,
                ),
                Container(
                  width: 5,
                ),
                Text(
                  userRate,
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.white,
                  ),
                ),
              ],
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
            // pegaHisto(email, "viagens_pessoais");
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
            //pegaHistoMeuBluber(email).then((value) {
            Navigator.of(context).pushNamed('/meubluber');
            //});
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

    await http.get(url);
  }

  // modificar essas duas funções para incluir o mapa
  // tutorial que pode ajudar https://www.youtube.com/watch?v=lNqEfnnmoHk&t=347s
  Widget _googleMap1(BuildContext context) {
    Set<Circle> circles = new Set<Circle>();
    circles.add(
      Circle(
          circleId: CircleId('Geofencing'),
          fillColor: Colors.black26,
          center: localizacao,
          radius: 1000,
          strokeColor: Colors.black38,
          strokeWidth: 3),
    );
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: CameraPosition(
        target: LatLng(-25.4391239, -49.2688287),
        zoom: 15,
      ),
      onMapCreated: _onMapCreated,
      myLocationEnabled: true,
      onCameraMove: (position) {
        // adicicionaBikes();
      },
      // trackCameraPosition: true,
      // myLocationEnabled: true,
      compassEnabled: true,
      // markers: { marcelle },
      markers: Set<Marker>.of(markers.values),
      circles: circles,
    );
  }

  Future<void> msgErroBikes() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          //title: Text('Rewind and remember'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Erro ao pegar as Bicicletas!'),
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

  void adicicionaBikes(String email) {
    String function = "retornaBikes";
    String _email = "email=" + email;

    var url = 'https://us-central1-bluberstg.cloudfunctions.net/' + function + '?' + _email;

    http.get(url).then((response) {
      Map<String, dynamic> bikes = jsonDecode(response.body);
      if (response.statusCode == 200) {
        print("Resposta ok");

        String len = bikes.keys.toString();
        len = len.replaceAll("(", "");
        len = len.replaceAll(")", "");
        List<String> name = len.split(", ");

        markers.clear();

        debugPrint("$bikes");
        bikesUpdated = true;
        // debugPrint("Testes: " + bikes[name[0]]['lat']);

        final int markerCount = name.length;
        print(markerCount);
        // print("|" + name[0] + "|");

        //Se a resposta é maior que zero ele coloca as bikes, se não, não entra
        if (name[0] != "") {
          for (int i = 0; i < markerCount; i++) {
            // print("Estou aqui i = " + i.toString());
            final String markerIdVal = name[i].toString();
            print("markerIdVal = " + markerIdVal);

            final MarkerId markerId = MarkerId(markerIdVal);

            double latitude = double.parse(bikes[name[i]]['lat']);
            print("lat " + latitude.toString());
            double longitude = double.parse(bikes[name[i]]['lon']);
            print("lon" + longitude.toString());

            final LatLng localizacao = LatLng(latitude, longitude);

            if (name[i] == bike) {
              print("true: " + name[i] + bike);
            }

            Marker marker = Marker(
              markerId: markerId,
              position: LatLng(localizacao.latitude, localizacao.longitude),
              infoWindow: InfoWindow(title: markerIdVal, snippet: ''),
              icon: (name[i] == bike) ? ((ativada == 'false') ? inactiveBikeIcon : (bikeEmTrip == 'true') ? bikeAlugadaIcon : myBikeIcon) : myIcon,
              // BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
              // icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet)
            );

            setState(() {
              markers[markerId] = marker;
            });
          }
        }
      }
    });
  }

  _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  void _animateToUser() async {
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
        _sendMessage(waitRent).then((onValue) {
          iniciaCorrida(email, _barcode).then((value) {
            print("Corrida iniciada");
            Navigator.of(context).pushReplacementNamed('/emviagem');
          });
        });
        // iniciaCorrida(email, _barcode).then((value) {
        //   print("Corrida iniciada");
        // });
      }).catchError((onError) {});
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
    return bts.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });

      // if (bluetoothState.toString().contains('ON')) {
      //   bluetoothStateBool = true;
      // } else {
      //   bluetoothStateBool = false;
      // }
    });
  }

  //Descobre os dispositivos de Bluetooth
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
          'Tente novamente mais tarde.1');
    }
  }

  //Pede para ligar o bluetooth
  Future bluetoothRequest() async {
    // async lambda seems to not working
    await bts.requestEnable().then((value) {
      getBluetoothState();
    });
  }

  //Conecta ao dispositivo
  Future bluetoothConection() async {
    // Some simplest connection :F
    try {
      _connection = await BluetoothConnection.toAddress(_hc05Adress);
      scan();
    } catch (exception) {
      showAlertDialog(context, 'Não foi possível conectar no Bluber!',
          'Tente novamente mais tarde.');
      print('Nada funciona');
    }

    // try {
    //   BluetoothConnection.toAddress(_hc05Adress).then((connection) {
    //     print('Connected to the device');

    //     _connection = connection;
    //     isConnected = true;
    //     scan();
    //   }).catchError((onError) {
    //     isConnected = false;
    //     // showAlertDialog(context, 'Não foi possível conectar no Bluber!',
    //     //     'Tente novamente mais tarde.');
    //   });

    //   // connection.input.listen((Uint8List data) {
    //   // }).onDone(() {
    //   //   print('Disconnected by remote request');
    //   // });
    // } catch (exception) {
    //   isConnected = false;
    //   showAlertDialog(context, 'Não foi possível conectar no Bluber!',
    //       'Tente novamente mais tarde.2');
    //   print('Cannot connect, exception occured');
    // }
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

  //Transações com o Banco
  //Google functions - Adicionar créditos na carteira
  Future iniciaCorrida(String _email, String _bike) async {
    String function = "iniciaCorrida";
    String email = "email=" + _email;
    String bike_id = "bike_id=" + _bike;

    var url = 'https://us-central1-bluberstg.cloudfunctions.net/' +
        function +
        '?' +
        bike_id +
        '&' +
        email;

    print(url.toString());
    print("Iniciando Corrida");

    await http.get(url).then((response) {
      if (response.statusCode == 200) {
        Map<String, dynamic> hist = jsonDecode(response.body);
        String _photoName = hist['codigo_da_viagem'] as String;
        // debugPrint("$hist");
        print(_photoName);

        photoName = _photoName;
        _sendMessage(unlock).then((onValue) {
          _connection.close();
        });
      } else {
        _sendMessage(canceled);
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

  //Get Rate e BikeID
  Future getInformation(String _email) async {
    String function = "retornaBikeRating";
    String email = "email=" + _email;

    var url = 'https://us-central1-bluberstg.cloudfunctions.net/' +
        function +
        '?' +
        email;

    await http.get(url).then((response) {
      if (response.statusCode == 200) {
        print("Resposta ok");

        Map<String, dynamic> information = jsonDecode(response.body);
        String _rating = information['rating'] as String;
        String _bikeID = information['bike_id'] as String;
        String _ativada = information['ativada'] as String;
        String _emTrip = information['in_trip'] as String;

        debugPrint("$information");
        // print(_rating);

        userRate = _rating;
        bike = _bikeID;
        ativada = _ativada;
        bikeEmTrip = _emTrip;

        getInformationFlag = true;
      } else {
        // msgErro();
        userRate = "5,0";
        bike = null;
        ativada = null;
        bikeEmTrip = null;
        //   showAlertDialog(
        //       context, 'Erro ao pegar as informações', 'Tentaremos novamente mais');
      }
    });
  }

  //Funções para pegar a corrida
  Future<void> msgErroViagem() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          //title: Text('Rewind and remember'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Erro ao receber o Histório de Corridas!'),
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

  void pegaHistoPessoais(String _email) {
    String function = "retornaHistorico";
    String email = "email=" + _email;
    String pref = "historico=" + "viagens_pessoais";

    var url = 'https://us-central1-bluberstg.cloudfunctions.net/' +
        function +
        '?' +
        email +
        '&' +
        pref;

    http.get(url).then((response) {
      if (response.statusCode == 200) {
        print("Resposta ok");

        Map<String, dynamic> corridas = jsonDecode(response.body);

        String len = corridas.keys.toString();
        len = len.replaceAll("(", "");
        len = len.replaceAll(")", "");
        len = len.replaceAll(" ", "");
        List<String> _corrida = len.split(",");

        debugPrint("$corridas");

        final int numCorridas = _corrida.length;
        print(numCorridas);

        lista_historico_corridas.clear();
        if (numCorridas < 1) {
          for (int i = 0; i < numCorridas; i++) {
            String corridaAtual = _corrida[i].toString().replaceAll(" ", "");
            print(corridaAtual.toString());
            String bike_id = corridas[corridaAtual]['bike_id'] as String;
            String cliente = corridas[_corrida[i]]['cliente'] as String;
            String data_e_hora_fim =
                corridas[_corrida[i]]['data_e_hora_fim'] as String;
            String data_e_hora_inicio =
                corridas[_corrida[i]]['data_e_hora_inicio'] as String;
            String preco = corridas[_corrida[i]]['preco'] as String;
            String photoName = _corrida[i].toString();

            Viagem viagemNova = new Viagem(bike_id, cliente, data_e_hora_fim,
                data_e_hora_inicio, preco, photoName);

            // if(!lista_historico_corridas.contains(viagemNova)){
            lista_historico_corridas.add(viagemNova);
            // }
          }

          print(lista_historico_corridas.length.toString());
        } else {
          if (response.statusCode == 201) {
            // print("Histórico vazio");
          } else {
            // msgErroViagem();
          }
        }
      }
    });
  }

  Future pegaHistoMeuBluber(String _email) async {
    String function = "retornaHistorico";
    String email = "email=" + _email;
    String pref = "historico=" + "viagens_com_sua_bike";

    var url = 'https://us-central1-bluberstg.cloudfunctions.net/' +
        function +
        '?' +
        email +
        '&' +
        pref;

    http.get(url).then((response) {
      if (response.statusCode == 200) {
        print("Resposta ok");

        Map<String, dynamic> corridas = jsonDecode(response.body);

        String len = corridas.keys.toString();
        len = len.replaceAll("(", "");
        len = len.replaceAll(")", "");
        len = len.replaceAll(" ", "");
        List<String> _corrida = len.split(",");

        debugPrint("$corridas");

        final int numCorridas = _corrida.length;
        print(numCorridas);

        lista_historico_meu_bluber.clear();
        for (int i = 0; i < numCorridas; i++) {
          String corridaAtual = _corrida[i].toString().replaceAll(" ", "");
          print('pega corridas meu bluber ' + corridaAtual.toString());
          String bike_id = corridas[_corrida[i]]['bike_id'].toString();
          print(bike_id);
          String cliente = corridas[_corrida[i]]['cliente'] as String;
          String data_e_hora_fim =
              corridas[_corrida[i]]['data_e_hora_fim'] as String;
          String data_e_hora_inicio =
              corridas[_corrida[i]]['data_e_hora_inicio'] as String;
          String preco = corridas[_corrida[i]]['preco'] as String;
          String photoName = _corrida[i].toString();

          Viagem viagemNova = new Viagem(bike_id, cliente, data_e_hora_fim,
              data_e_hora_inicio, preco, photoName);

          // print(lista_historico_meu_bluber.contains(viagemNova).toString());
          // if(!lista_historico_meu_bluber.contains(viagemNova)){
          lista_historico_meu_bluber.add(viagemNova);
          // }

        }

        print(lista_historico_meu_bluber.length.toString());
      }
      pegouHistorico = true;
    });
  }

  Future clearList() async {
    print("antes " + lista_historico_meu_bluber.length.toString());
    lista_historico_corridas.clear();
    lista_historico_meu_bluber.clear();

    print("depois + " + lista_historico_meu_bluber.length.toString());

    // lista_historico_corridas.removeRange(0, (lista_historico_corridas.length-1));
    // lista_historico_meu_bluber.removeRange(0, (lista_historico_meu_bluber.length-1));

    // print("antes "+ lista_historico_corridas.length.toString());
    // for (var i = 0; i < lista_historico_corridas.length - 1; i++) {
    //   lista_historico_corridas.removeAt(i);
    // }
    // print("depois + " + lista_historico_corridas.length.toString());

    // for (var i = 0; i < lista_historico_meu_bluber.length - 1; i++) {
    //   lista_historico_meu_bluber.removeAt(i);
    // }
  }

  // //Get Rate e BikeID
  // Future getInformation(String _email) async {
  //   String function = "retornaBikeRating";
  //   String email = "email=" + _email;

  //   var url = 'https://us-central1-bluberstg.cloudfunctions.net/' +
  //       function +
  //       '?' +
  //       email;

  //   await http.get(url).then((response) {
  //     if (response.statusCode == 200) {
  //       print("Resposta ok");

  //       Map<String, dynamic> information = jsonDecode(response.body);
  //       String _rating = information['rating'] as String;
  //       String _bikeID = information['bike_id'] as String;

  //       debugPrint("$information");
  //       // print(_rating);

  //       userRate = _rating;
  //       bike = _bikeID;
  //     } else {
  //       // msgErro();
  //       userRate = "5";
  //       bike = null;
  //     }
  //   });
  // }
}
