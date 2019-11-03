import 'package:flutter/material.dart';
import 'signinsignout.dart';
import 'userdata.dart';
import 'package:http/http.dart';
import 'dart:convert' show jsonDecode, utf8;


class CadastroWallet extends StatefulWidget {
  @override
  _CadastroWalletState createState() => _CadastroWalletState();
}

class _CadastroWalletState extends State<CadastroWallet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        width: 600,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Insira o ID da sua criptocarteira',
              style: TextStyle(fontSize: 20),
            ),
            TextFormField(
              keyboardType: TextInputType.text,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "ID da criptocarteira",
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                ),
              ),
              style: TextStyle(fontSize: 20),
              onFieldSubmitted: (value) {
                wallet = value;
                //inserir aqui função para enviar wallet id para o banco de dados
                print(name + " " + email + " " + wallet);
                cadastro(name, email, wallet).then((value){
                  getInformation(email);
                });
                Navigator.of(context).pushReplacementNamed('/homepage');
              },
            ),
            Container(
              height: 20,
              alignment: Alignment.centerRight,
              child: FlatButton(
                child: Text(
                  'Sair da conta',
                  textAlign: TextAlign.right,
                ),
                onPressed: () {
                  signOutGoogle();
                  Navigator.of(context).pushReplacementNamed('/');
                },
              ),
            )
          ],
        ),
      ),
    );
  }

    //Chama  a função de cadastrar
  Future cadastro(String _name, String _email, String _wallet) async {
    String function = "createUser";
    // String name = "name="+ _name;
    String email = "email=" + _email;
    String wallet = "wallet_id=" + _wallet;

    print("Cadastrando -  name: " +
        _name +
        "email: " +
        _email +
        "wallet" +
        _wallet);

    String url = 'https://us-central1-bluberstg.cloudfunctions.net/' +
        function +
        '?' +
        email +
        '&' +
        wallet;
    print(url);
    return await get(url);
  }

  //Get Rate e BikeID
  Future getInformation(String _email) async {
    String function = "retornaBikeRating";
    String email = "email=" + _email;

    var url = 'https://us-central1-bluberstg.cloudfunctions.net/' +
        function +
        '?' +
        email;

    await get(url).then((response) {
      if (response.statusCode == 200) {
        print("Resposta ok");

        Map<String, dynamic> information = jsonDecode(response.body);
        String _rating = information['rating'] as String;
        String _bikeID = information['bike_id'] as String;
        String _ativada = information['ativada'] as String;

        debugPrint("$information");
        // print(_rating);

        userRate = _rating;
        bike = _bikeID;
        ativada = _ativada;

        // getInformationFlag = true;
      } else {
        // msgErro();
        userRate = "5,0";
        bike = null;
        ativada = null;
      //   showAlertDialog(
      //       context, 'Erro ao pegar as informações', 'Tentaremos novamente mais');
      }
    });
  }
}
