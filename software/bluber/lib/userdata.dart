// import 'package:cloud_firestore/cloud_firestore.dart';

//class UserData {
// final databaseReference = Firestore.instance;
import 'package:google_maps_flutter/google_maps_flutter.dart';

String name = null;
String email = null;
String wallet = null;
String bike = null;
String imageUrl = null;
String photoName = null;
String bikeAlugada = null;
String userRate = "5";
String ativada = null;
String bikeEmTrip = null;
LatLng localizacao = LatLng(-25.439477, -49.268963);

//Variáveis de Transição do Bluetooth
String lock = 'L'; //Fechar a trava da Bike
String unlock = 'U'; //Abrir a trava
String waitRent = 'R'; //Quando alguém ler o QRCode esse sinal deve ser enviado
String endTrip = 'E'; //Encerra a viagem
String canceled = 'C'; //Quando a viagem é recusada

class Viagem {
  String bike_id;
  String cliente;
  String data_e_hora_fim;
  String data_e_hora_inicio;
  String preco;
  String photoName;

  Viagem(this.bike_id, this.cliente, this.data_e_hora_fim,
      this.data_e_hora_inicio, this.preco, this.photoName);
}

List<Viagem> lista_historico_corridas = new List<Viagem>();

List<Viagem> lista_historico_meu_bluber = new List<Viagem>();

//   UserData(this.name, this.email, this.bike) {
//     _createDocument('user', this.email, {name: this.name});
//   }

// // Funções utilizadas para enviar dados ao DB
// //Função para enviar dados ao Real time database
//   void _createDocument(
//       String collection, String document, Map<String, dynamic> data) async {
//     await databaseReference
//         .collection(collection)
//         .document(document)
//         .setData(data);
//   }

//   String getName() {
//     return name;
//   }
//}
