//Bibliotecas para o bluetooth
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'dart:async';
import 'dart:convert' show utf8;

//Variáveis de Transição do Bluetooth
String lock = 'L'; //Fechar a trava da Bike
String unlock = 'U'; //Abrir a trava
String waitRent = 'R'; //Quando alguém ler o QRCode esse sinal deve ser enviado
String endTrip = 'E'; //Encerra a viagem

class Bluetooth {
  //Funções do Bluetooth
  //Variáveis
  BluetoothState bluetoothState = BluetoothState.UNKNOWN;
  StreamSubscription<BluetoothDiscoveryResult> _streamSubscription;
  List<BluetoothDiscoveryResult> results = List<BluetoothDiscoveryResult>();
  bool Discovered = false;
  String HC05Adress = '20:16:07:25:05:13';

  //Variáveis de conexão
  BluetoothConnection _connection;
  bool isConnected = false;
  bool bluetoothStateBool = false;

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: Column(
  //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //       children: <Widget>[
  //         RaisedButton(
  //           child: Text('Request Bluetooth'),
  //           onPressed: (){
  //             BluetoothRequest();
  //           },
  //         ),
  //         RaisedButton(
  //           child: Discovered == true ? Text('Connect') : Text('Discovery'),
  //           onPressed: (){
  //             if(Discovered == true){
  //               bluetoothConection();
  //             }else{
  //               bluetoothDiscovery();
  //             }
  //           },
  //         ),
  //         RaisedButton(
  //           child: Text('Enviar U'),
  //           onPressed: () {
  //             _sendMessage('U');
  //           },
  //         ),
  //       ],
  //     )
  //   );
  // }

  //Pega o status do bluetooth
  Future getBluetoothState() async {
    FlutterBluetoothSerial.instance.state.then((state) {
      bluetoothState = state;
      if (bluetoothState.toString().contains('ON')) {
        bluetoothStateBool = true;
      } else {
        bluetoothStateBool = false;
      }
    });
  }

  //Descobre os dispositivos de Bluetooth
  void bluetoothDiscovery() {
    _streamSubscription =
        FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
      results.add(r);
    });

    print('Procurando HC-05');
    for (int i = 0; i < results.length; i++) {
      if (results[i].device.address == HC05Adress) {
        bluetoothConection();
        Discovered = true;
      }
    }
  }

  //Pede para ligar o bluetooth
  Future bluetoothRequest() async {
    // async lambda seems to not working
    await FlutterBluetoothSerial.instance.requestEnable();
    getBluetoothState();
  }

  //Conecta ao dispositivo
  Future bluetoothConection() async {
    // Some simplest connection :F
    try {
      await BluetoothConnection.toAddress(HC05Adress).then((connection) {
        print('Connected to the device');

        _connection = connection;
        isConnected = true;
      });

      // connection.input.listen((Uint8List data) {
      // }).onDone(() {
      //   print('Disconnected by remote request');
      // });
    } catch (exception) {
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

  //Interpreta as mensagens do servidor e envia msg
  void serverMessages() {}
}
