import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';

import 'document.dart';
import 'rpc.dart';

part 'serializers.g.dart';

@SerializersFor([
  Document,
  RenderRequest,
  RenderResponse,
  RotateRequest,
])
final Serializers serializers = _$serializers;
final standardSerializers =
    (serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
