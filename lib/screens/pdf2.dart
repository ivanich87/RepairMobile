
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

class PDFViewerFromUrl extends StatelessWidget {
  const PDFViewerFromUrl({Key? key, required this.url}) : super(key: key);

  final String url;

  @override
  Widget build(BuildContext context) {
    print(url);
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF reader'),
      ),
      body: const PDF().fromUrl(
      url,
      placeholder: (double progress) => Center(child: Text('$progress %')),
      errorWidget: (dynamic error) => Center(child: Text(error.toString())
    ))
    );
  }
}