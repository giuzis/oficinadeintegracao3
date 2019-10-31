import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DisplayImage extends StatelessWidget {
  final String imageUrl;
  DisplayImage({Key key, @required this.imageUrl}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Image.network(imageUrl),
    );
  }
}
