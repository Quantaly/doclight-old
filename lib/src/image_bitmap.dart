@JS()
library image_bitmap;

import 'dart:html' as html;

import 'package:js/js.dart';
import 'package:js/js_util.dart';

@JS('createImageBitmap')
external dynamic _createImageBitmap(html.Blob blob);

Future<html.ImageBitmap> createImageBitmap(html.Blob blob) {
  var promise = _createImageBitmap(blob);
  return promiseToFuture(promise);
}
