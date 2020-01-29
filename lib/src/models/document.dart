import 'package:json_annotation/json_annotation.dart';

part 'document.g.dart';

@JsonSerializable()
class Document {
  String name;
  DateTime lastModified;
  List<int> imageIds;

  Document();
  factory Document.empty() {
    var now = DateTime.now();
    return Document()
      ..name = 'Scan from ${now.month}-${now.day}-${now.year} '
          '${now.hour}:${now.minute.toString().padLeft(2, '0')}'
      ..lastModified = now
      ..imageIds = [];
  }

  factory Document.fromJson(Map<String, dynamic> json) =>
      _$DocumentFromJson(json);

  Map<String, dynamic> toJson() => _$DocumentToJson(this);
}
