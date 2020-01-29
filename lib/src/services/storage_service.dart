import 'dart:async';
import 'dart:html' as html;
import 'dart:indexed_db';

import '../models/document.dart';

const dbVersion = 1;

class StorageService {
  final Future<Database> _dbFuture = _openDatabase();

  Future<Transaction> getTransaction(dynamic storeNames, String mode) async {
    var db = await _dbFuture;
    return db.transaction(storeNames, mode);
  }

  Future<int> createDocument() async {
    var txn = await getTransaction('documents', 'readwrite');
    var documentStore = txn.objectStore('documents');
    var ret = await documentStore.add(Document.empty().toJson());
    await txn.completed;
    return ret;
  }

  Future<List<DocumentWithId>> listDocuments() async {
    var txn = await getTransaction('documents', 'readonly');
    var documentStore = txn.objectStore('documents');
    var documents = <DocumentWithId>[];
    await for (var cursor in documentStore.openCursor()) {
      documents.add(DocumentWithId()
        ..id = cursor.key
        ..document =
            Document.fromJson((cursor.value as Map).cast<String, dynamic>()));
      cursor.next();
    }
    documents.sort((a, b) => b.document.lastModified
        .difference(a.document.lastModified)
        .inMilliseconds);
    return documents;
  }

  Future<Document> retrieveDocument(int id) async {
    var txn = await getTransaction('documents', 'readonly');
    var documentStore = txn.objectStore('documents');
    return Document.fromJson(
        (await documentStore.getObject(id) as Map).cast<String, dynamic>());
  }

  Future<void> updateDocument(int id, Document document) async {
    var txn = await getTransaction('documents', 'readwrite');
    var documentStore = txn.objectStore('documents');
    await documentStore.put(document.toJson(), id);
    await txn.completed;
  }

  Future<void> deleteDocument(int id) async {
    var txn = await getTransaction('documents', 'readwrite');
    var documentStore = txn.objectStore('documents');
    await documentStore.delete(id);
    await txn.completed;
  }

  Future<void> deleteDocumentAndImages(int id) async {
    var txn = await getTransaction(['documents', 'images'], 'readwrite');
    var documentStore = txn.objectStore('documents');
    var imageStore = txn.objectStore('images');
    var document = Document.fromJson(
        (await documentStore.getObject(id) as Map).cast<String, dynamic>());
    await Future.wait([
      documentStore.delete(id),
      for (var id in document.imageIds) imageStore.delete(id),
      txn.completed,
    ]);
  }

  Future<int> storeImage(html.Blob image) async {
    var txn = await getTransaction('images', 'readwrite');
    var imageStore = txn.objectStore('images');
    var ret = await imageStore.add(image);
    await txn.completed;
    return ret;
  }

  Future<List<html.Blob>> loadImages(List<int> ids) async {
    var txn = await getTransaction('images', 'readonly');
    var imageStore = txn.objectStore('images');
    return Future.wait(ids.map((id) async {
      var ret = await imageStore.getObject(id);
      return ret;
    }));
  }

  Future<List<String>> loadImageUrls(List<int> ids) async =>
      (await loadImages(ids)).map(html.Url.createObjectUrlFromBlob).toList();

  Future<void> deleteImage(int id) async {
    var txn = await getTransaction('images', 'readwrite');
    var imageStore = txn.objectStore('images');
    await imageStore.delete(id);
    await txn.completed;
  }

  Future<void> deleteImageAndUpdateDocument(
      int imageId, int documentId, Document document) async {
    var txn = await getTransaction(['documents', 'images'], 'readwrite');
    var documentStore = txn.objectStore('documents');
    var imageStore = txn.objectStore('images');
    await Future.wait([
      documentStore.put(document, documentId),
      imageStore.delete(imageId),
      txn.completed,
    ]);
  }

  Future<void> deleteImages(List<int> ids) async {
    var txn = await getTransaction('images', 'readwrite');
    var imageStore = txn.objectStore('images');
    await Future.wait([
      for (var id in ids) imageStore.delete(id),
      txn.completed,
    ]);
  }

  static Future<Database> _openDatabase() => html.window.indexedDB
          .open('doclight', version: dbVersion, onUpgradeNeeded: (e) {
        Database db = e.target.result;
        for (var currentVersion = e.oldVersion;
            currentVersion < e.newVersion;
            currentVersion++) {
          switch (currentVersion) {
            case 0:
              db.createObjectStore('documents', autoIncrement: true);
              db.createObjectStore('images', autoIncrement: true);
              break;
          }
        }
      });
}

Future<T> requestToFuture<T>(Request request) {
  var completer = Completer<T>();
  request.onSuccess.first.then((_) => completer.complete(request.result));
  request.onError.first.then((_) => completer.completeError(request.error));
  return completer.future;
}

class DocumentWithId {
  int id;
  Document document;
}
