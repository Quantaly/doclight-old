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
    var request =
        serializers.deserializeWith(RenderRequest.serializer, params.value);
    var document = await storage.retrieveDocument(request.id);
    var images = await storage.loadImages(document.imageIds);
    var pdf = await renderPdfFromImages(images);
    return serializers.serializeWith(RenderResponse.serializer,
        RenderResponse((b) => b.url = html.Url.createObjectUrlFromBlob(pdf)));
  });

  // ignore: avoid_types_on_closure_parameters
  server.registerMethod('rotateImageClockwise', (Parameters params) async {
    var request =
        serializers.deserializeWith(RotateRequest.serializer, params.value);
    var id = request.id;
    var image = await storage.loadImage(id);
    await storage.updateImage(id, await rotateImageClockwise(image));
    return {};
  });

  server.listen();
}
