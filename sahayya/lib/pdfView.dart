import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFView extends StatefulWidget {
  const PDFView({Key? key}) : super(key: key);

  @override
  _PDFViewState createState() => _PDFViewState();
}

class _PDFViewState extends State<PDFView> {
  @override
  Widget build(BuildContext context) {

    final arguments = ModalRoute.of(context)!.settings.arguments as Map;

    String link = arguments['link'];

    return Scaffold(
        body: Container(
            child: SfPdfViewer.network(link)
          ,),
    );
  }
}
