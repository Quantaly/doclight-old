import 'dart:html' as html;

import 'package:bloc/bloc.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';

import '../blob_loading.dart';
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

class ChangeName extends DocumentEvent {
  String newName;
}

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
  final StorageService _storage;
  final RenderingService _rendering;
  final ImageManipulationService _imageManipulation;

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
    } else if (event is ChangeName) {
      var newDocument = previousState.workingDoc.rebuild((b) => b
        ..name = event.newName
        ..lastModified = now);
      await _storage.updateDocument(previousState.workingId, newDocument);
      yield previousState.rebuild((b) => b..workingDoc.replace(newDocument));
      // -------------------- //
    } else if (event is AddImage) {
      yield previousState.rebuild((b) => b..thinking = true);
      var src = html.Url.createObjectUrlFromBlob(event.image);
      var newSrc = await _imageManipulation.constrainImageSize(src);
      var blob = await fetchBlob(newSrc);
      var id = await _storage.storeImage(blob);
      var newDocument = previousState.workingDoc.rebuild((b) => b
        ..imageIds.add(id)
        ..lastModified = now);
      await _storage.updateDocument(previousState.workingId, newDocument);
      yield previousState.rebuild((b) => b
        ..workingDoc.replace(newDocument)
        ..imageUrls.add(newSrc));
      // -------------------- //
    } else if (event is RotateImage) {
      yield previousState.rebuild((b) => b..thinking = true);
      await _imageManipulation
          .rotateImageClockwise(previousState.workingDoc.imageIds[event.index]);
      var newDocument =
          previousState.workingDoc.rebuild((b) => b.lastModified = now);
      await _storage.updateDocument(previousState.workingId, newDocument);
      var imageUrls =
          await _storage.loadImageUrls(previousState.workingDoc.imageIds);
      yield previousState.rebuild((b) => b..imageUrls.replace(imageUrls));
      // -------------------- //
    } else if (event is DeleteImage) {
      yield previousState.rebuild((b) => b..thinking = true);
      var newDocument = previousState.workingDoc.rebuild((b) => b
        ..imageIds.removeAt(event.index)
        ..lastModified = now);
      await _storage.deleteImageAndUpdateDocument(
          previousState.workingDoc.imageIds[event.index],
          previousState.workingId,
          newDocument);
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

DateTime get now => DateTime.now().toUtc();

// Importing pedantic is for suckers.
void unawaited(Future f) {}
