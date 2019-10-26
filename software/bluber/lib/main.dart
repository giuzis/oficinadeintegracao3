import 'package:flutter/material.dart';
import 'homepage.dart';
import 'emviagempage.dart';
import 'encerrarviagem.dart';
import 'minhacarteira.dart';
import 'adicionarcreditos.dart';
import 'login.dart';
import 'meubluber.dart';
import 'historicobluber.dart';
import 'cadastronovobluber.dart';
import 'historicocorridas.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  //Dados dos usuários
  String name;
  String email;
  String imageUrl;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bluber',
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/emviagem': (BuildContext context) => EmViagemPage(),
        '/login': (BuildContext context) => LoginPage(),
        '/novobluber': (BuildContext context) => NovoBluberPage(),
        '/historicobluber': (BuildContext context) => HistoricoBluberPage(),
        '/encerrarviagem': (BuildContext context) => ViagemEncerradaPage(),
        '/minhacarteira': (BuildContext context) => MinhaCarteiraPage(),
        '/homepage': (BuildContext context) => MyHomePage(),
        '/addcreditos': (BuildContext context) => AddCreditosPage(),
        '/meubluber': (BuildContext context) => MeuBluberPage(),
        '/corridas': (BuildContext context) => HistoricoCorridasPage(),
      },
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      // home: Bluetooth(),
      home: LoginPage(),
    );
  }
}
