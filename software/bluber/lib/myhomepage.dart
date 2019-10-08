/*********** Página home page ***************/
/* Para adicionar os mapas, modifique as duas últimas funções:
    _googleMap1()
    _googleMap2()
*/

import 'package:flutter/material.dart';
import 'package:bluber/cameraqrcodepage.dart';

// faz uma animaçãozinha para ir para outra página (faz a página subir)
Route _QRCodeRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => QRCodePage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.0, 1.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

// essa classe nunca é modificada
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  // aqui no build que tudo acontece
  @override
  Widget build(BuildContext context) {
    // nossa página inicial será um definida por um controle de abas
    return DefaultTabController(
      length: 2,

      // scaffold é o "esqueleto" padrão dos aplicativos material que deixa tudo mais fácil
      child: Scaffold(
        // característica do scaffold é a appbar já pronta (parte de cima da aplicação)
        appBar: AppBar(
          title: Text(widget.title), //título da app
          bottom: TabBar(
              controller: _tabController, tabs: _myTabs), // definição das abas
        ),

        // drawer é o "menu" onde tem o perfil do usuário e outras coisinhas
        drawer: Drawer(
          // o widget "column" permite colocar vários widgets um em cima do outro (ou embaixo dependendo do ponto de vista)
          child: Column(
            // nesse caso coloquei as funções _bannerDrawer e _bannerList que retornam os widgets
            children: <Widget>[
              _bannerDrawer(),
              _bannerList(),
            ],
          ),
        ),
        // com tabview definimos o que será mostrado em cada tab
        body: TabBarView(controller: _tabController, children: _myTabBarView()),

        // bottomNavgationBar é um enfeitezinho que tem na parte de baixo da tela
        bottomNavigationBar: BottomAppBar(
          color: Colors.blue,
          shape: CircularNotchedRectangle(),
          child: Container(
            height: 60.0,
          ),
        ),

        // é o botão que leva a outra página (nesse caso)
        floatingActionButton: _tabController.index == 0
            // n~ao sei explicar direito o que está acontecendo aqui,
            // mas serve para mudar o estilo do botão quando muda de aba
            ? FloatingActionButton(
                backgroundColor: Colors.blueGrey,
                child: Icon(Icons.apps),
                onPressed: () {
                  Navigator.of(context).push(_QRCodeRoute());
                },
              )
            : FloatingActionButton(
                backgroundColor: Colors.blueGrey,
                child: Icon(Icons.add),
                onPressed: () {
                  Navigator.of(context).push(_QRCodeRoute());
                },
              ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  // lista de tabs (para essa aplicação, só serão usadas duas)
  final List<Tab> _myTabs = <Tab>[
    Tab(text: 'Quero Pedalar', icon: Icon(Icons.directions_bike)),
    Tab(text: 'Meu Bluber', icon: Icon(Icons.location_on)),
  ];

  // colocar aqui os mapas do googlemaps
  List<Widget> _myTabBarView() {
    return <Widget>[
      // cada aba corresponde a um widget
      _googleMap1(context),
      _googleMap2(context),
    ];
  }

  // função necessária para trobar o floatingbutton de acordo com a aba
  // função que inicializa o tabcontroller
  @override // não sei para que serve
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _myTabs.length,
      vsync: this,
      initialIndex: 0,
    )..addListener(() {
        setState(() {});
      });
  }

  // função necessária para trobar o floatingbutton de acordo com a aba
  // não sei direito para que serve
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _scanQRCode() {
    // se não usar setState, a frase não se modifica
    setState(() {
      Navigator.of(context).push(_QRCodeRoute());
    });
  }

  // widget que define o banner do drawer
  Widget _bannerDrawer() {
    // container para mostrar dados do perfil do usuário
    // (container é um bloco onde vc pode colocar vários widgets dentro)
    return Container(
      color: Colors.blue, // cor de fundo do container
      width: 310.0, // definição da largura
      height: 170.0, // definição da altura

      // stack para ajeitar os widgets dentro do container (funciona como uma pilha onde vc vai colocando um widget em cima do outro)
      child: Stack(
        children: <Widget>[
          // padding ajuda a alocar os widgets no lugar que queremos

          // padding da imagem do user
          Padding(
            padding: EdgeInsets.only(
                top: 55.0, left: 10.0), // define as coordenadas do widget
            child: CircleAvatar(
              radius: 40.0,
              // para adicionar imagens é necessário modficar o pubspec.yaml (linha 45 em diante)
              backgroundImage: AssetImage("images/bebe2.jpeg"),
            ),
          ),

          // padding do nome do user
          Padding(
            padding: EdgeInsets.only(top: 75.0, left: 110.0),
            // nome do usuário
            child: Text(
              "Enrico Manfron",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25.0,
                color: Colors.white,
              ),
            ),
          ),

          // padding do e-mail do user
          Padding(
            padding: EdgeInsets.only(top: 105.0, left: 110.0),
            // e-mail do usuário
            child: Text(
              "enricobebe@gmail.com",
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 14.0,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // widget que define a lista do drawer
  Widget _bannerList() {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        ListTile(
          title: Text("Minhas corridas",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.normal)),
          onTap: () {},
        ),
        ListTile(
          title: Text("Minha carteira",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.normal)),
          onTap: () {},
        ),
        ListTile(
          title: Text("Meu Bluber corridas",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.normal)),
          onTap: () {},
        )
      ],
    );
  }

  // modificar essas duas funções para incluir o mapa
  // tutorial que pode ajudar https://www.youtube.com/watch?v=lNqEfnnmoHk&t=347s
  Widget _googleMap1(BuildContext context) {
    return Center(child: Text("Mapa1", style: TextStyle(fontSize: 30.0)));
  }

  Widget _googleMap2(BuildContext context) {
    return Center(child: Text("Mapa2", style: TextStyle(fontSize: 30.0)));
  }
}
