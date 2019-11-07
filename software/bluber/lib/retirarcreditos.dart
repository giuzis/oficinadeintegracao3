import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'userdata.dart';

class RetCreditosPage extends StatefulWidget {
  @override
  _RetCreditosPageState createState() => _RetCreditosPageState();
}

class _RetCreditosPageState extends State<RetCreditosPage> {
  int _pressed = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Resgatar créditos"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                height: 60,
                width: 150,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blue,
                    width: 2,
                  ),
                  color: _pressed == 1 ? Colors.blue : Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: SizedBox.expand(
                  child: FlatButton(
                    child: Center(
                      child: Text(
                        "0.0001 BTC",
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _pressed = 1;
                      });
                    },
                  ),
                ),
              ),
              Container(
                height: 60,
                width: 150,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blue,
                    width: 2,
                  ),
                  color: _pressed == 2 ? Colors.blue : Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: SizedBox.expand(
                  child: FlatButton(
                    child: Center(
                      child: Text(
                        "0.0002 BTC",
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _pressed = 2;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          Container(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                height: 60,
                width: 150,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blue,
                    width: 2,
                  ),
                  color: _pressed == 3 ? Colors.blue : Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: SizedBox.expand(
                  child: FlatButton(
                    child: Center(
                      child: Text(
                        "0.0003 BTC",
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _pressed = 3;
                      });
                    },
                  ),
                ),
              ),
              Container(
                height: 60,
                width: 150,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blue,
                    width: 2,
                  ),
                  color: _pressed == 4 ? Colors.blue : Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: SizedBox.expand(
                  child: FlatButton(
                    child: Center(
                      child: Text(
                        "0.0004 BTC",
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _pressed = 4;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          Container(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                height: 60,
                width: 150,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blue,
                    width: 2,
                  ),
                  color: _pressed == 5 ? Colors.blue : Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: SizedBox.expand(
                  child: FlatButton(
                    child: Center(
                      child: Text(
                        "0.0005 BTC",
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _pressed = 5;
                      });
                    },
                  ),
                ),
              ),
              Container(
                height: 60,
                width: 150,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blue,
                    width: 2,
                  ),
                  color: _pressed == 6 ? Colors.blue : Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: SizedBox.expand(
                  child: FlatButton(
                    child: Center(
                      child: Text(
                        "0.0006 BTC",
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _pressed = 6;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          Container(
            height: 300,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.grey,
        label: Text(
          "Resgatar bitcoins",
        ),
        onPressed: () {
          // _neverSatisfied();
          retirarCreditos(email, _pressed.toDouble() / 1000);
          // retirarCreditos(email, 0.0001);
          //Navigator.of(context).pushReplacementNamed('/minhacarteira');
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Future<void> _neverSatisfied() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          //title: Text('Rewind and remember'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Créditos retirados!'),
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
                Text('Erro na transação - Verifique sua conta'),
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

  //Google functions - Adicionar créditos na carteira
  Future retirarCreditos(String _email, double _amount) async {
    String function = "recoverBluberCredit";
    String email = "email=" + _email;
    String amount = "amount=" + _amount.toString();

    var url = 'https://us-central1-bluberstg.cloudfunctions.net/' +
        function +
        '?' +
        amount +
        '&' +
        email;
    print("retirando bitcoinds");
    var response = await http.get(url);

    if (response.statusCode == 200) {
      _neverSatisfied();
    } else {
      msgErro();
    }
  }
}
