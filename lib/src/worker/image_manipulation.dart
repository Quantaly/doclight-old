import 'dart:html' as html;
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:image/image.dart' as i;

import '../blob_loading.dart';
import '../image_bitmap.dart';

Future<String> constrainImageSize(String imageSrc) async {
  var blob = await fetchBlob(imageSrc);
  var bitmap = await createImageBitmap(blob);
  if (bitmap.width <= 800 && bitmap.height <= 800) {
    return imageSrc;
  } else {
    var scaleFactor = 800 / math.max(bitmap.width, bitmap.height);
    var newWidth = (bitmap.width * scaleFactor).truncate();
    var newHeight = (bitmap.height * scaleFactor).truncate();
    var canvas = html.OffscreenCanvas(newWidth, newHeight);
    html.OffscreenCanvasRenderingContext2D context = canvas.getContext('2d');

    context.drawImage(bitmap, 0, 0, newWidth, newHeight);
    var blob = await canvas.convertToBlob({'type': 'image/jpeg'});
    return html.Url.createObjectUrlFromBlob(blob);
  }
}

Future<html.Blob> rotateImageClockwise(html.Blob image) async {
  var imageData = await readBlob(image);
  var decoded = i.decodeImage(imageData);
  var rotated = i.copyRotate(decoded, 90);
  return html.Blob([Uint8List.fromList(i.encodeJpg(rotated))], 'image/jpeg');
}
