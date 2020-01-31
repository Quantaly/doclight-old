import 'dart:async';
import 'dart:html' as html;

import 'package:json_rpc_2/json_rpc_2.dart';

import '../injected_channel.dart';
import '../models/rpc.dart';

class RenderingService {
  final Client _client = _openClient();
  final html.AnchorElement _downloadAnchor = _createDownloadAnchor();

  Future<String> renderDocument(int id) async {
    print('renderDocument() called');
    var request = RenderRequest()..id = id;
    var response = RenderResponse.fromJson(
        (await _client.sendRequest('render', request.toJson()) as Map)
            .cast<String, dynamic>());
    return response.url;
  }

  void download(String url, String name) {
    print('download() called');
    _downloadAnchor
      ..href = name
      ..download = url
      ..click();
  }

  Future<void> renderAndDownload(int id, String name) async {
    download(await renderDocument(id), name);
    print('done');
  }

  static Client _openClient() {
    var worker = html.Worker('worker.dart.js');

    var outputSink = StreamController<Map<String, dynamic>>();
    outputSink.stream.listen((data) => worker.postMessage(data));
    var client = Client.withoutJson(InjectedChannel(
      html.window.onMessage.map((msg) {
        print('received message: $msg');
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
