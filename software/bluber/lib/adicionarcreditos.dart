import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class AddCreditosPage extends StatefulWidget {
  @override
  _AddCreditosPageState createState() => _AddCreditosPageState();
}

class _AddCreditosPageState extends State<AddCreditosPage> {
  int _pressed = 0;
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Adicionar créditos"),
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
                width: 200,
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
                        "1,00 BTC",
                        
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
                width: 200,
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
                        "2,00 BTC",
                        
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
                width: 200,
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
                        "3,00 BTC",
                        
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
                width: 200,
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
                        "4,00 BTC",
                        
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
                width: 200,
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
                        "5,00 BTC",
                        
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
                width: 200,
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
                        "6,00 BTC",
                        
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
              "Adicionar bitcoins",
            ),
            onPressed: () {
              _neverSatisfied();
              // adicionarCredito(_pressed);
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
              Text('Créditos adicionados!'),
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
  Future adicionarCredito() async {
    String function = "Litecoin_Transaction";
    String ammount = "ammount=0.001";
    String walletTo = "wallet_to=2NEUV4DsSKPYemN6GmXsFPviBZv8aKceHKD";
    String walletFrom = "wallet_from=2N5mHpm29QqFouGiJ4eLMhMFwyNrYLyPhij";

    var url = 'https://us-central1-bluberstg.cloudfunctions.net/'+function + '?' + ammount + '&'  + walletTo + '&' + walletFrom;

    var data = await http.get(url);
        //'https://us-central1-bluberstg.cloudfunctions.net/Litecoin_Transaction?ammount=0.001&wallet_to=2NEUV4DsSKPYemN6GmXsFPviBZv8aKceHKD&wallet_from=2N5mHpm29QqFouGiJ4eLMhMFwyNrYLyPhij');
  }
}
