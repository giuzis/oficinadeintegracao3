/*********** Página home page ***************/
/* Para adicionar os mapas, modifique as duas últimas funções:
    _googleMap1()
    _googleMap2()
*/
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:typed_data';

//Bibliotecas para o bluetooth
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'dart:async';

//import 'package:bluber/Bluetooth.dart';
//import 'package:qrcode_reader/qrcode_reader.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';

// essa classe nunca é modificada
class MyHomePage extends StatefulWidget {
  // MyHomePage({Key key, this.title}) : super(key: key);

  // final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  GoogleMapController mapController;
  Location location = Location();
  String _barcode = "";

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
            // nesse caso coloquei as funções _bannerDrawer e _bannerList que retornam os widgets
            children: <Widget>[
              _bannerDrawer(),
              _bannerList(),
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
            BluetoothRequest();
            getBluetoothState();
            //print(_bluetoothState);
            //scan();
          },),
      // com tabview definimos o que será mostrado em cada tab
      // é o botão que leva a outra página (nesse caso)
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  // widget que define o banner do drawer
  Widget _bannerDrawer() {
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
                top: 55.0, left: 10.0), // define as coordenadas do widget
            child: CircleAvatar(
              radius: 40.0,
              // para adicionar imagens é necessário modficar o pubspec.yaml (linha 45 em diante)
              backgroundImage: AssetImage("images/bebe2.jpeg"),
            ),
          ),

          // padding do nome do user
          Padding(
            padding: EdgeInsets.only(top: 75.0, left: 110.0),
            // nome do usuário
            child: Text(
              "Enrico Manfron",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25.0,
                color: Colors.white,
              ),
            ),
          ),

          // padding do e-mail do user
          Padding(
            padding: EdgeInsets.only(top: 105.0, left: 110.0),
            // e-mail do usuário
            child: Text(
              "enrico@gmail.com",
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 14.0,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
  //Funções do Bluetooth - To do 
  //Variáveis
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  StreamSubscription<BluetoothDiscoveryResult> _streamSubscription;
  List<BluetoothDiscoveryResult> results = List<BluetoothDiscoveryResult>();
  bool isDiscovering;

  //Pede para ligar o bluetooth
  Future BluetoothRequest() async { // async lambda seems to not working
    await FlutterBluetoothSerial.instance.requestEnable();
  }

  // Pega o status atual do bluetooth
  Future getBluetoothState() async {
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() { _bluetoothState = state; });
    });
    print(_bluetoothState);
    bluetoothDiscovery();
  }

  void bluetoothDiscovery() {

    int index = 0;
    
    _streamSubscription = FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
      setState(() { 
        results.add(r);
        index=index+1;
      });
    });

    if(results[index].device.address == '20:16:07:25:05:13'){
      print('Descobri o HC-05');
      bluetoothConection(results[index].device.address);
    }  

    // _streamSubscription.onDone(() {
    //   setState(() { isDiscovering = false; });
    // });
  }

  Future bluetoothConection(String address) async {
      // Some simplest connection :F
      try {
          BluetoothConnection connection = await BluetoothConnection.toAddress(address);
          print('Connected to the device');

          connection.input.listen((Uint8List data) {
              
              // connection.output.add(data); // Sending data

              // if (ascii.decode(data).contains('!')) {
              //     connection.finish(); // Closing connection
              //     print('Disconnecting by local host');
              // }
          }).onDone(() {
              print('Disconnected by remote request');
          });
      }
      catch (exception) {
          print('Cannot connect, exception occured');
      }
  }

  //Descobrindo Dispositivos
  // void DiscoveryDevices () {
  //   BluetoothDiscoveryResult result = results[];

  //     results[results.indexOf(result)] = BluetoothDiscoveryResult(
  //         device: BluetoothDevice(
  //           name: result.device.name ?? '',
  //           address: result.device.address,
  //           type: result.device.type
  //         ), 
  //       );
  // }

  // widget que define a lista do drawer
  Widget _bannerList() {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        ListTile(
          title: Text("Minhas corridas",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.normal)),
          onTap: () {},
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
      String barcode = await BarcodeScanner.scan().then((barcode) {
        setState(() {
          this._barcode = barcode;
        });
        print(this._barcode);
        Navigator.of(context).pushReplacementNamed('/emviagem');
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
}
