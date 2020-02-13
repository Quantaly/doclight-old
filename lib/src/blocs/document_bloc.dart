import 'dart:html' as html;

import 'package:bloc/bloc.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';

import '../models/document.dart';
import '../services/storage_service.dart';
import '../services/worker_service.dart';

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
  StorageService _storage;
  RenderingService _rendering;
  ImageManipulationService _imageManipulation;

  DocumentBloc(this._storage, this._rendering, this._imageManipulation);

  @override
  DocumentState get initialState => DocumentState((b) => b
    ..thinking = true
    ..workingId = -1);

  @override
  Stream<DocumentState> mapEventToState(DocumentEvent event) async* {
    var previousState = state;
    if (event is InitEvent) {
      var id = await _storage.createDocument();
      var document = await _storage.retrieveDocument(id);
      var imageUrls = await _storage.loadImageUrls(document.imageIds);
      yield DocumentState((b) => b
        ..thinking = false
        ..workingId = id
        ..workingDoc.replace(document)
        ..imageUrls.replace(imageUrls));
      // -------------------- //
    } else if (event is AddImage) {
      yield previousState.rebuild((b) => b..thinking = true);
      var id = await _storage.storeImage(event.image);
      var newDocument =
          previousState.workingDoc.rebuild((b) => b..imageIds.add(id));
      await _storage.updateDocument(previousState.workingId, newDocument);
      var imageUrl = html.Url.createObjectUrlFromBlob(event.image);
      yield previousState.rebuild((b) => b
        ..workingDoc.replace(newDocument)
        ..imageUrls.add(imageUrl));
      // -------------------- //
    } else if (event is RotateImage) {
      yield previousState.rebuild((b) => b..thinking = true);
      await _imageManipulation
          .rotateImageClockwise(previousState.workingDoc.imageIds[event.index]);
      var imageUrls =
          await _storage.loadImageUrls(previousState.workingDoc.imageIds);
      yield previousState.rebuild((b) => b..imageUrls.replace(imageUrls));
      // -------------------- //
    } else if (event is DeleteImage) {
      yield previousState.rebuild((b) => b..thinking = true);
      var newDocument = previousState.workingDoc
          .rebuild((b) => b..imageIds.removeAt(event.index));
      await _storage.deleteImageAndUpdateDocument(
          event.index, previousState.workingId, newDocument);
      yield previousState.rebuild((b) => b
        ..workingDoc.replace(newDocument)
        ..imageUrls.removeAt(event.index));
      // -------------------- //
    } else if (event is ExportPdf) {
      var toExport = await _storage.retrieveDocument(event.id);
      unawaited(_rendering.renderAndDownload(event.id, '${toExport.name}.pdf'));
      // -------------------- //
    } else if (event is ChangeDocument) {
      yield previousState.rebuild((b) => b..thinking = true);
      var newDocument = await _storage.retrieveDocument(event.id);
      var imageUrls = await _storage.loadImageUrls(newDocument.imageIds);
      yield DocumentState((b) => b
        ..thinking = false
        ..workingId = event.id
        ..workingDoc.replace(newDocument)
        ..imageUrls.replace(imageUrls));
      // -------------------- //
    }
  }
}

// Importing pedantic is for suckers.
void unawaited(Future f) {}
