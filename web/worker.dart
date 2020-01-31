import 'dart:async';
import 'dart:html' as html;

import 'package:json_rpc_2/json_rpc_2.dart';

import 'package:doclight/worker.dart';

void main() {
  var self = html.DedicatedWorkerGlobalScope.instance;

  var outputSink = StreamController<Map<String, dynamic>>();
  outputSink.stream.listen((data) {
    print('posting message: $data');
    self.postMessage(data);
  });
  var server = Server.withoutJson(InjectedChannel<Map<String, dynamic>>(
    self.onMessage.map((msg) => (msg.data as Map).cast<String, dynamic>()),
    outputSink,
  ));

  var storage = StorageService(self.indexedDB);

  // ignore: avoid_types_on_closure_parameters
  server.registerMethod('render', (Parameters params) async {
    print('1');
    var request = RenderRequest.fromJson(params.asMap.cast<String, dynamic>());
    print('2');
    var document = await storage.retrieveDocument(request.id);
    print('3');
    var images = await storage.loadImages(document.imageIds);
    print('4');
    var pdf = await renderPdfFromImages(images);
    print('5');
    return (RenderResponse()..url = html.Url.createObjectUrlFromBlob(pdf))
        .toJson();
  });

  server.listen();
}
