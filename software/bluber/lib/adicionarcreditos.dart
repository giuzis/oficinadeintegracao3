import 'package:flutter/material.dart';

class AddCreditosPage extends StatefulWidget {
  @override
  _AddCreditosPageState createState() => _AddCreditosPageState();
}

class _AddCreditosPageState extends State<AddCreditosPage> {
  bool _pressed1 = true;
  bool _pressed2 = true;
  bool _pressed3 = true;
  bool _pressed4 = true;
  bool _pressed5 = true;
  bool _pressed6 = true;

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
                  color: _pressed1 ? Colors.white : Colors.blue,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: SizedBox.expand(
                  child: FlatButton(
                    child: Center(
                      child: Text(
                        "1,00 BTC",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _pressed1 = !_pressed1;
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
                  color: _pressed2 ? Colors.white : Colors.blue,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: SizedBox.expand(
                  child: FlatButton(
                    child: Center(
                      child: Text(
                        "1,00 BTC",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _pressed2 = !_pressed2;
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
                  color: _pressed3 ? Colors.white : Colors.blue,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: SizedBox.expand(
                  child: FlatButton(
                    child: Center(
                      child: Text(
                        "1,00 BTC",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _pressed3 = !_pressed3;
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
                  color: _pressed4 ? Colors.white : Colors.blue,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: SizedBox.expand(
                  child: FlatButton(
                    child: Center(
                      child: Text(
                        "1,00 BTC",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _pressed4 = !_pressed4;
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
                  color: _pressed5 ? Colors.white : Colors.blue,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: SizedBox.expand(
                  child: FlatButton(
                    child: Center(
                      child: Text(
                        "1,00 BTC",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _pressed5 = !_pressed5;
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
                  color: _pressed6 ? Colors.white : Colors.blue,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: SizedBox.expand(
                  child: FlatButton(
                    child: Center(
                      child: Text(
                        "1,00 BTC",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _pressed6 = !_pressed6;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          Container(
            height: 200,
          ),
          FloatingActionButton.extended(
            backgroundColor: Colors.grey,
            label: Text(
              "Adicionar bitcoins",
              style: TextStyle(fontSize: 20),
            ),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/minhacarteira');
            },
          ),
        ],
      ),
    );
  }
}
