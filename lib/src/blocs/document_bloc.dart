import 'dart:html' as html;

import 'package:bloc/bloc.dart';

import '../models/document.dart';

class DocumentState {
  bool thinking;
  int workingId;
  Document workingDoc;
  List<String> imageUrls;
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
  DocumentState get initialState => DocumentState()
    ..thinking = false
    ..workingId = -1
    ..imageUrls = [];

  @override
  Stream<DocumentState> mapEventToState(DocumentEvent event) async* {
    var previousState = state;
    if (event is InitEvent) {
      
    } else if (event is AddImage) {

    } else if (event is RotateImage) {
      
    } else if (event is DeleteImage) {

    } else if (event is ExportPdf) {

    } else if (event is ChangeDocument) {
      
    }
  }
}
