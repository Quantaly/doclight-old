import 'dart:html' as html;
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:image/image.dart' as i;

import '../blob_loading.dart';

Future<String> constrainImageSize(String imageSrc) async {
  print('it def gets here');
  var imageData = await fetchBytes(imageSrc);
  print('but does it get here');
  var decoded = i.decodeImage(imageData);
  print('or here');
  if (decoded.width <= 800 && decoded.height <= 800) {
    return imageSrc;
  } else {
    try {
      var newWidth =
          decoded.width ~/ (math.max(decoded.width, decoded.height) / 800);
      print(newWidth);
      print('1');
      var smaller = i.copyResize(decoded, width: newWidth);
      print('2');
      var blob =
          html.Blob([Uint8List.fromList(i.encodeJpg(smaller))], 'image/jpeg');
      print('3');
      return html.Url.createObjectUrlFromBlob(blob);
    } catch (e) {
      print(e);
      throw 'fuck';
    }
  }
}

Future<html.Blob> rotateImageClockwise(html.Blob image) async {
  var imageData = await readBlob(image);
  var decoded = i.decodeImage(imageData);
  var rotated = i.copyRotate(decoded, 90);
  return html.Blob([Uint8List.fromList(i.encodeJpg(rotated))], 'image/jpeg');
}
