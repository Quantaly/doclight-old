import 'dart:async';
import 'dart:html' as html;

import 'package:json_rpc_2/json_rpc_2.dart';

import 'package:doclight/worker.dart';

void main() {
  var self = html.DedicatedWorkerGlobalScope.instance;

  var outputSink = StreamController<String>();
  outputSink.stream.listen((data) {
    self.postMessage(data);
  });
  var server = Server(InjectedChannel(
    self.onMessage.map((msg) => msg.data),
    outputSink,
  ));

  var storage = StorageService(self.indexedDB);

  // ignore: avoid_types_on_closure_parameters
  server.registerMethod('render', (Parameters params) async {
    var request = RenderRequest.fromJson(params.asMap.cast<String, dynamic>());
    var document = await storage.retrieveDocument(request.id);
    var images = await storage.loadImages(document.imageIds);
    var pdf = await renderPdfFromImages(images);
    return (RenderResponse()..url = html.Url.createObjectUrlFromBlob(pdf))
        .toJson();
  });

  // ignore: avoid_types_on_closure_parameters
  server.registerMethod('rotateImageClockwise', (Parameters params) async {
    print('1');
    var id = RotateRequest.fromJson(params.asMap.cast<String, dynamic>()).id;
    print('2');
    var image = await storage.loadImage(id);
    print('3');
    await storage.updateImage(id, await rotateImageClockwise(image));
    print('4');
    return RotateResponse().toJson();
  });

  server.listen();
}
