import 'package:flutter/material.dart';

class DisplayImage extends StatelessWidget {
  final String imageUrl;
  DisplayImage({Key key, @required this.imageUrl}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Expanded(
        child: Image.network(imageUrl),
      ),
    );
  }
}
