// import 'dart:async';
//
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'package:http/http.dart' as http;
//
// class MyPDFView extends StatefulWidget {
//   final String? pdfUrl;
//   final String? pdfFile;
//
//   const MyPDFView.url({super.key, required this.pdfUrl}) : pdfFile = null;
//
//   const MyPDFView.file({super.key, required this.pdfFile}) : pdfUrl = null;
//
//   @override
//   State<StatefulWidget> createState() {
//     return MyPDFViewState();
//   }
// }
//
// class MyPDFViewState extends State<MyPDFView> {
//   final Completer<PDFViewController> _controller = Completer<PDFViewController>();
//   Uint8List? pdfData;
//   String? downloadPdfError;
//
//   void downloadPdf(String url) async {
//     final response = await http.get(Uri.parse(url));
//     if (response.statusCode == 200) {
//       setState(() {
//         pdfData = response.bodyBytes;
//       });
//     } else {
//       setState(() {
//         downloadPdfError = "Failed to download PDF";
//       });
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     var pdfUrl = widget.pdfUrl;
//     if (pdfUrl != null && pdfUrl.isNotEmpty) {
//       downloadPdf(pdfUrl);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (downloadPdfError != null) {
//       return Center(
//         child: Column(mainAxisSize: MainAxisSize.min, children: [
//           Text(downloadPdfError ?? ""),
//           TextButton(
//               onPressed: () {
//                 setState(() {
//                   downloadPdfError = null;
//                 });
//                 downloadPdf(widget.pdfUrl ?? "");
//               },
//               child: const Text("Try again"))
//         ]),
//       );
//     }
//     if (pdfData == null && widget.pdfFile == null) {
//       return const Center(
//         child: CircularProgressIndicator(),
//       );
//     }
//     return PDFView(
//       filePath: widget.pdfFile,
//       pdfData: pdfData,
//       onRender: (pages) {
//         // TODO
//       },
//       onError: (error) {
//         // TODO
//       },
//       onPageError: (page, error) {
//         // TODO
//       },
//       onViewCreated: (PDFViewController pdfViewController) {
//         _controller.complete(pdfViewController);
//       },
//       onPageChanged: (int? page, int? total) {
//         // TODO
//       },
//     );
//   }
// }