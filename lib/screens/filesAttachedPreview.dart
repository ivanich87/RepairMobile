

import 'package:flutter/material.dart';

class scrAttachPreviewScreen extends StatefulWidget {
  final String path;
  scrAttachPreviewScreen(this.path);

  @override
  State<scrAttachPreviewScreen> createState() => _scrAttachPreviewScreenState();
}

class _scrAttachPreviewScreenState extends State<scrAttachPreviewScreen> {

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      body: InteractiveViewer(
        panEnabled: true, // Set it to false
        boundaryMargin: EdgeInsets.all(100),
        minScale: 0.5,
        maxScale: 2,
        child: Image.network(
          widget.path,
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
          alignment: Alignment.center,
        ),
      ),
    );
  }
}
