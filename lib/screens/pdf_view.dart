import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

class PdfView extends StatefulWidget {
  final String title;
  final String url;

  const PdfView({super.key, required this.title, required this.url});

  @override
  State<PdfView> createState() => _PdfViewState();
}

class _PdfViewState extends State<PdfView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: const PDF().cachedFromUrl(widget.url, placeholder: (progress) {
          return LinearProgressIndicator(value: progress);
        }));
  }
}
