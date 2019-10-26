//Bibliotecas para o bluetooth
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:typed_data';



class Bluetooth extends StatefulWidget {
  @override
  _BlueetothState createState() => _BlueetothState();
}

class _BlueetothState extends State<Bluetooth> {
  //Funções do Bluetooth 
  //Variáveis
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  StreamSubscription<BluetoothDiscoveryResult> _streamSubscription;
  List<BluetoothDiscoveryResult> results = List<BluetoothDiscoveryResult>();
  bool Discovered = false;
  String HC05Adress = '20:16:07:25:05:13';

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          RaisedButton(
            child: Text('Request Bluetooth'),
            onPressed: (){
              BluetoothRequest();
            },
          ),
          RaisedButton(
            child: Discovered == true ? Text('Connect') : Text('Discovery'),
            onPressed: (){
              if(Discovered == true){
                bluetoothConection();
              }else{
                bluetoothDiscovery();
              }
            },
          ),
        ],
      )
    );
  }

   Future getBluetoothState() async {
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() { _bluetoothState = state; });
      print(_bluetoothState);
      bluetoothDiscovery();
    });
  }

  void bluetoothDiscovery() {
    
    _streamSubscription = FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
      setState(() { 
        results.add(r);
      });
    });

    print('Procurando HC-05');
    for(int i=0;i<results.length;i++){
      if(results[i].device.address == HC05Adress){
        print('Descobri o HC-05');
        
        _streamSubscription.onDone(() {
          setState(() { Discovered = true; });
        });
      }
    }
  }

  //Pede para ligar o bluetooth
  Future BluetoothRequest() async { // async lambda seems to not working
    await FlutterBluetoothSerial.instance.requestEnable().then((value){
    });
  }

  //Conecta ao dispositivo
  Future bluetoothConection() async {
      // Some simplest connection :F
      try {
          BluetoothConnection connection = await BluetoothConnection.toAddress(HC05Adress);
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
  }