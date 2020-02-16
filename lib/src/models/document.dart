import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'document.g.dart';

abstract class Document implements Built<Document, DocumentBuilder> {
  static Serializer<Document> get serializer => _$documentSerializer;

  String get name;
  DateTime get lastModified;
  BuiltList<int> get imageIds;

  Document._();
  factory Document([void Function(DocumentBuilder) updates]) = _$Document;

  factory Document.empty() {
    var now = DateTime.now();
    return Document((b) => b
      ..name = '${now.month}-${now.day}-${now.year} '
          '${now.hour}:${now.minute.toString().padLeft(2, '0')}'
      ..lastModified = now.toUtc());
  }
}
