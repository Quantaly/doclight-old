import 'dart:async';

import 'package:stream_channel/stream_channel.dart';

class InjectedChannel<T> extends StreamChannelMixin<T> {
  @override
  final Stream<T> stream;
  @override
  final StreamSink<T> sink;

  InjectedChannel(this.stream, this.sink);
}
