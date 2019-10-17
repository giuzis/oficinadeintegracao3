import 'package:async/async.dart';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';

//Funcao utilizada para scannear o QrCode
Future scan(String page) async {
  String _barcode = "E";
  try {
    String barcode = await BarcodeScanner.scan();
    setState(() {
      this._barcode = barcode;
      // vai apra a outra página
      // aqui vai ter que ter alguma coisa para conectar o celular e a bike via bluetooth
      // para ver se ela está disponível e se o código confere
      Navigator.of(context).pushReplacementNamed(page);
    });
    print(_barcode);
  } on PlatformException catch (e) {
    if (e.code == BarcodeScanner.CameraAccessDenied) {
      setState(() {
        this._barcode = 'E';
      });
    } else {
      setState(() => this._barcode = 'E');
    }
  } on FormatException {
    setState(() => this._barcode = 'E');
  } catch (e) {
    setState(() => this._barcode = 'E');
  }
}
