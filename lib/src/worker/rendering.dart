import 'dart:async';
import 'dart:html' as html;
import 'dart:typed_data';

import 'package:image/image.dart' as i;
import 'package:pdf/pdf.dart' as p;
import 'package:pdf/widgets.dart' as p;

import '../blob_loading.dart';

Future<html.Blob> renderPdfFromImages(List<html.Blob> images) async {
  var imageData = await Future.wait(images.map(readBlob));

  var pdf = p.Document();
  for (var image in imageData.map(i.decodeImage)) {
    var pdfImage = p.PdfImage(
      pdf.document,
      image: image.data.buffer.asUint8List(),
      width: image.width,
      height: image.height,
    );
    pdf.addPage(p.Page(
      pageFormat: p.PdfPageFormat(
        image.width.toDouble(),
        image.height.toDouble(),
      ),
      build: (context) => p.Image(pdfImage),
    ));
  }

  return html.Blob([Uint8List.fromList(pdf.save())], 'application/pdf');
}
