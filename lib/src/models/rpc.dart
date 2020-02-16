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

abstract class ConstrainRequest
    implements Built<ConstrainRequest, ConstrainRequestBuilder> {
  static Serializer<ConstrainRequest> get serializer =>
      _$constrainRequestSerializer;

  String get src;

  ConstrainRequest._();
  factory ConstrainRequest([void Function(ConstrainRequestBuilder) updates]) =
      _$ConstrainRequest;
}

abstract class ConstrainResponse
    implements Built<ConstrainResponse, ConstrainResponseBuilder> {
  static Serializer<ConstrainResponse> get serializer =>
      _$constrainResponseSerializer;

  String get newSrc;

  ConstrainResponse._();
  factory ConstrainResponse([void Function(ConstrainResponseBuilder) updates]) =
      _$ConstrainResponse;
}

abstract class RotateRequest
    implements Built<RotateRequest, RotateRequestBuilder> {
  static Serializer<RotateRequest> get serializer => _$rotateRequestSerializer;

  int get id;

  RotateRequest._();
  factory RotateRequest([void Function(RotateRequestBuilder) updates]) =
      _$RotateRequest;
}
