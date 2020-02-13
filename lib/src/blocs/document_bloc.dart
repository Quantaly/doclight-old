import 'dart:html' as html;

import 'package:bloc/bloc.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';

import '../models/document.dart';

part 'document_bloc.g.dart';

abstract class DocumentState
    implements Built<DocumentState, DocumentStateBuilder> {
  bool get thinking;
  int get workingId;
  @nullable
  Document get workingDoc;
  BuiltList<String> get imageUrls;

  DocumentState._();
  factory DocumentState([void Function(DocumentStateBuilder) updates]) =
      _$DocumentState;
}

class DocumentEvent {}

class InitEvent extends DocumentEvent {}

class AddImage extends DocumentEvent {
  html.File image;
}

class RotateImage extends DocumentEvent {
  int index;
}

class DeleteImage extends DocumentEvent {
  int index;
}

class ExportPdf extends DocumentEvent {
  int id;
}

class ChangeDocument extends DocumentEvent {
  int id;
}

class DocumentBloc extends Bloc<DocumentEvent, DocumentState> {
  @override
  DocumentState get initialState => DocumentState((b) => b
    ..thinking = true
    ..workingId = -1);

  @override
  Stream<DocumentState> mapEventToState(DocumentEvent event) async* {
    var previousState = state;
    if (event is InitEvent) {
    } else if (event is AddImage) {
    } else if (event is RotateImage) {
    } else if (event is DeleteImage) {
    } else if (event is ExportPdf) {
    } else if (event is ChangeDocument) {}
  }
}
