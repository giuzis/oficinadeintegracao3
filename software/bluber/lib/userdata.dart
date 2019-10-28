// import 'package:cloud_firestore/cloud_firestore.dart';

//class UserData {
// final databaseReference = Firestore.instance;
String name;
String email;
String wallet;
String bike;
String imageUrl;

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
