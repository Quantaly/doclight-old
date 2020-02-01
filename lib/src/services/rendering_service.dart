import 'dart:async';
import 'dart:html' as html;

import 'package:json_rpc_2/json_rpc_2.dart';

import '../injected_channel.dart';
import '../models/rpc.dart';

class RenderingService {
  final Client _client = _openClient();
  final html.AnchorElement _downloadAnchor = _createDownloadAnchor();

  Future<String> renderDocument(int id) async {
    var request = RenderRequest()..id = id;
    var responseF = _client.sendRequest('render', request.toJson());
    html.window.alert('Rendering has started. It may take a while, '
        'but please leave this tab open. '
        'The PDF will be automatically saved as soon as it is ready.');
    var response = RenderResponse.fromJson(
        (await responseF as Map).cast<String, dynamic>());
    return response.url;
  }

  void download(String url, String name) {
    _downloadAnchor
      ..href = url
      ..download = name
      ..click();
  }

  Future<void> renderAndDownload(int id, String name) async {
    download(await renderDocument(id), name);
  }

  static Client _openClient() {
    var worker = html.Worker('worker.dart.js');

    var outputSink = StreamController<String>();
    outputSink.stream.listen((data) => worker.postMessage(data));
    var client = Client(InjectedChannel(
      worker.onMessage.map((msg) {
        return msg.data;
      }),
      outputSink,
    ));

    client.listen();
    return client;
  }

  static html.AnchorElement _createDownloadAnchor() {
    var ret = html.AnchorElement()..style.display = 'none';
    html.window.document.querySelector('body').append(ret);
    return ret;
  }
}
