import 'dart:html' as html;

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_forms/angular_forms.dart';

import '../../models/document.dart';
import '../../services/storage_service.dart';
import '../image_display/image_display_component.dart';

@Component(selector: 'dl-form', templateUrl: 'form_component.html', styleUrls: [
  'form_component.css'
], directives: [
  NgFor,
  materialInputDirectives,
  formDirectives,
  MaterialButtonComponent,
  MaterialIconComponent,
  ImageDisplayComponent,
], pipes: [
  AsyncPipe,
])
class FormComponent implements AfterChanges {
  final StorageService _storage;

  FormComponent(this._storage);

  @Input()
  int workingDocumentId;

  @ViewChild('fileInput')
  html.FileUploadInputElement fileInput;

  Future<bool> readyFuture = Future.value(false);
  Document workingDocument = Document.empty();

  Control<String> nameControl = Control('');
  List<String> imageUrls = [];

  @override
  void ngAfterChanges() {
    readyFuture = () async {
      workingDocument = await _storage.retrieveDocument(workingDocumentId);
      nameControl.updateValue(workingDocument.name);
      imageUrls = await _storage.loadImageUrls(workingDocument.imageIds);
    }()
        .then((_) => true);
  }

  Future<void> saveDocument() async {
    workingDocument.lastModified = DateTime.now();
    await _storage.updateDocument(workingDocumentId, workingDocument);
  }

  Future<void> updateName() async {
    workingDocument.name = nameControl.value;
    await saveDocument();
  }

  void getImage() {
    fileInput.click();
  }

  Future<void> addImage(html.Blob image) async {
    imageUrls.add(html.Url.createObjectUrlFromBlob(image));
    var imageId = await _storage.storeImage(image);
    workingDocument.imageIds.add(imageId);
    await saveDocument();
  }

  Future<void> removeImage(int index) async {
    imageUrls.removeAt(index);
    var imageId = workingDocument.imageIds.removeAt(index);
    workingDocument.lastModified = DateTime.now();
    await _storage.deleteImageAndUpdateDocument(
        imageId, workingDocumentId, workingDocument);
  }
}
