import 'package:json_annotation/json_annotation.dart';

part 'rpc.g.dart';

@JsonSerializable()
class RenderRequest {
  int id;

  RenderRequest();
  factory RenderRequest.fromJson(Map<String, dynamic> json) =>
      _$RenderRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RenderRequestToJson(this);
}

@JsonSerializable()
class RenderResponse {
  String url;

  RenderResponse();
  factory RenderResponse.fromJson(Map<String, dynamic> json) =>
      _$RenderResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RenderResponseToJson(this);
}

@JsonSerializable()
class RotateRequest {
  int id;

  RotateRequest();
  factory RotateRequest.fromJson(Map<String, dynamic> json) =>
      _$RotateRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RotateRequestToJson(this);
}

@JsonSerializable()
class RotateResponse {
  RotateResponse();
  factory RotateResponse.fromJson(Map<String, dynamic> json) =>
      _$RotateResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RotateResponseToJson(this);
}
