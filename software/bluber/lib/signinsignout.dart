import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart';
import 'userdata.dart';
import 'dart:async';
import 'package:http/http.dart';

//Variáveis usadas no sign in + autenticação
final GoogleSignIn googleSignIn = GoogleSignIn();
final FirebaseAuth _auth = FirebaseAuth.instance;

//Funções da autenticação - sign in com o gmail
Future<String> signInWithGoogle() async {
  final GoogleSignInAccount googleSignInAccount =
      await googleSignIn.signIn().catchError((onError) {});
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication.catchError((onError) {});

  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;

  assert(user.email != null);
  assert(user.displayName != null);
  assert(user.photoUrl != null);

  name = user.displayName;
  email = user.email;
  imageUrl = user.photoUrl;

//Pega apenas o primeiro nome da pessoa
  if (name.contains(" ")) {
    name = name.substring(0, name.indexOf(" "));
  }

  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);

  final FirebaseUser currentUser = await _auth.currentUser();
  assert(user.uid == currentUser.uid);

  // UserData(name, email, null);
  // cadastro(name, email, wallet);

  return 'signInWithGoogle succeeded: $user';
}

void signOutGoogle() async {
  await googleSignIn.signOut();
  bike = null;
  wallet = null;
  name = null;
  email = null;
  print("User Sign Out");
}

//Chama  a função de cadastrar
// cadastro(String _name, String _email, String _wallet) async {
//   String function = "createUser";
//   // String name = "name="+ _name;
//   String email = "email=" + _email;
//   String wallet = "wallet_id=" + _wallet;

//   print("Cadastrando -  name: " +
//       _name +
//       "email: " +
//       _email +
//       "wallet" +
//       _wallet);

//   String url = 'https://us-central1-bluberstg.cloudfunctions.net/' +
//       function +
//       '?' +
//       email +
//       '&' +
//       wallet;
//   print(url);
//   return await get(url);
// }
