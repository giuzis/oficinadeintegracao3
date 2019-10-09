import 'package:flutter/material.dart';


// QR Code page
class QRCodePage extends StatelessWidget {

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text('Alugando bike', style: TextStyle(fontSize: 30.0)),
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
