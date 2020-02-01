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

  server.listen();
}
