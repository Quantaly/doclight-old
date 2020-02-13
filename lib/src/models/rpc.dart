import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'rpc.g.dart';

abstract class RenderRequest
    implements Built<RenderRequest, RenderRequestBuilder> {
  static Serializer<RenderRequest> get serializer => _$renderRequestSerializer;

  int get id;

  RenderRequest._();
  factory RenderRequest([void Function(RenderRequestBuilder) updates]) =
      _$RenderRequest;
}

abstract class RenderResponse
    implements Built<RenderResponse, RenderResponseBuilder> {
  static Serializer<RenderResponse> get serializer =>
      _$renderResponseSerializer;

  String get url;

  RenderResponse._();
  factory RenderResponse([void Function(RenderResponseBuilder) updates]) =
      _$RenderResponse;
}

abstract class RotateRequest
    implements Built<RotateRequest, RotateRequestBuilder> {
  static Serializer<RotateRequest> get serializer => _$rotateRequestSerializer;

  int get id;

  RotateRequest._();
  factory RotateRequest([void Function(RotateRequestBuilder) updates]) =
      _$RotateRequest;
}
