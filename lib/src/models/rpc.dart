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
