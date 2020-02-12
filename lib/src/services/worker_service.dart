import 'dart:async';
import 'dart:html' as html;

import 'package:json_rpc_2/json_rpc_2.dart';

import '../injected_channel.dart';
import '../models/rpc.dart';

part 'image_manipulation_service.dart';
part 'rendering_service.dart';

class WorkerService {
  final Client _client = _openClient();

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
}