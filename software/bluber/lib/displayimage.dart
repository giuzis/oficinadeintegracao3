import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DisplayImage extends StatefulWidget {
  final String imageName;
  DisplayImage({Key key, @required this.imageName}) : super(key: key);

  @override
  _DisplayImageState createState() => _DisplayImageState();
}

class _DisplayImageState extends State<DisplayImage> {
  String imageUrl;
  var ref;

  void initState() {
    super.initState();
    ref = FirebaseStorage.instance.ref().child(widget.imageName);
    ref.getDownloadURL().then((loc) {
      setState(() => imageUrl = loc);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: imageUrl == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Image.network(imageUrl),
    );
  }
}
