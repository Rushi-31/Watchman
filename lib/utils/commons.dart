import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';

Future<void> pdfGenerator(String name) async {
  final _pdf = pw.Document();
  final _assetImage = await imageFromAssetBundle('assets/images/account.png');

  _pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (context) => pw.Center(
        child: pw.Container(
          margin: pw.EdgeInsets.all(16),
          width: double.infinity,
          color: PdfColors.deepPurple50,
          child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.SizedBox(
                height: 50,
              ),
              pw.Container(
                width: 160,
                height: 160,
                decoration: pw.BoxDecoration(
                  shape: pw.BoxShape.circle,
                  color: PdfColors.deepPurple200,
                ),
                child: pw.Image(_assetImage),
              ),
              pw.SizedBox(
                height: 50,
              ),
              pw.Text(
                'certificate of completion',
                style: pw.TextStyle(
                  fontSize: 22,
                  color: PdfColors.grey700,
                ),
              ),
              pw.SizedBox(
                height: 20,
              ),
              pw.Text(
                'presented to:',
                style: pw.TextStyle(
                  color: PdfColors.grey600,
                ),
              ),
              pw.SizedBox(
                height: 30,
              ),
              pw.Text(
                name,
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.grey800,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  var path = await getApplicationDocumentsDirectory();
  File('${path.path}/$name.pdf').writeAsBytesSync(await _pdf.save());
}

Future<String> getApplicationDocumentsDirectoryPath() async {
  final Directory applicationDocumentsDirectory = await getApplicationDocumentsDirectory();
  return applicationDocumentsDirectory.path;
}
