import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';

class MeuBluberPage extends StatefulWidget {
  @override
  _MeuBluberPageState createState() => _MeuBluberPageState();
}

class _MeuBluberPageState extends State<MeuBluberPage> {
  String _barcode = "";
  bool _disponivel = false;
  bool _trava_aberta = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meu Bluber'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.grey,
        label: Text('Adicionar novo Bluber'),
        onPressed: () {
          // scan();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: _preferenciasList(),
    );
  }

  Widget _preferenciasList() {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        SwitchListTile(
          title: Text('Disponibilizar meu Bluber para locação'),
          value: _disponivel,
          onChanged: (bool disponivel) {
            setState(() {
              _disponivel = disponivel;
              if (disponivel) {
                _trava_aberta = false;
              }
              print(_disponivel);
            });
          },
          secondary: Icon(Icons.directions_bike),
        ),
        SwitchListTile(
          title: Text('Abrir trava'),
          value: _trava_aberta,
          onChanged: (bool trava) {
            setState(() {
              _trava_aberta = trava;
              if (_trava_aberta) _disponivel = false;
            });
          },
          secondary: Icon(Icons.lock_open),
        ),
        Card(
          child: ListTile(
            leading: Icon(Icons.history),
            title: Text('Histórico de corridas'),
            trailing: Icon(Icons.arrow_right),
            onTap: () {
              Navigator.of(context).pushNamed('/historicobluber');
            },
          ),
        ),
      ],
    );
  }

  Future scan() async {
    try {
      await BarcodeScanner.scan().then((barcode) {
        setState(() {
          this._barcode = barcode;
        });
        print(this._barcode);
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
