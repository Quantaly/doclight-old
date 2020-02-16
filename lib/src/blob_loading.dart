import 'dart:async';
import 'dart:html' as html;
import 'dart:typed_data';

import 'package:http/http.dart' as http;

Future<Uint8List> readBlob(html.Blob blob) {
  var completer = Completer<Uint8List>();
  var reader = html.FileReader()..readAsArrayBuffer(blob);
  reader.onLoadEnd.first.then((_) => completer.complete(reader.result));
  reader.onError.first.then((_) => completer.completeError(reader.error));
  return completer.future;
}

Future<Uint8List> fetchBytes(String url) async {
  var response = await http.get(url);
  return response.bodyBytes;
}

Future<html.Blob> fetchBlob(String url) async {
  var response = await http.get(url);
  return html.Blob([response.bodyBytes], response.headers['content-type']);
}
