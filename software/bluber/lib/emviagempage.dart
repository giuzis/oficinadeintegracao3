import 'package:flutter/material.dart';
//import 'package:slider/slider_button.dart';

// QR Code page
class EmViagemPage extends StatefulWidget {
  @override
  _EmViagemPageState createState() => _EmViagemPageState();
}

class _EmViagemPageState extends State<EmViagemPage> {
  Widget _googleMap() {
    return Center(
      child: Text('Mapa aqui', style: TextStyle(fontSize: 30)),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Em viagem...")),
      ),
      body: Stack(
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
                      '00:00',
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
                      '0,00 BTC',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25.0,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '0,00 BTC/min',
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
          _googleMap(),
          Padding(
            padding: EdgeInsetsDirectional.only(top: 640.0, start: 130.0),
            child: RaisedButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/encerrarviagem');
              },
              child: Text('Encerrar viagem', style: TextStyle(fontSize: 20)),
            ),
          ),
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
    );
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
