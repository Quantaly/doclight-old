import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

import '../../services/storage_service.dart';

@Component(
  selector: 'dl-document-list',
  templateUrl: 'document_list_component.html',
  styleUrls: ['document_list_component.css'],
  directives: [
    NgIf,
    NgFor,
    MaterialListComponent,
    MaterialListItemComponent,
    MaterialButtonComponent,
    MaterialIconComponent,
  ],
  pipes: [
    AsyncPipe,
  ],
)
class DocumentListComponent implements OnInit {
  final StorageService _storage;

  @Output()
  final Stream<int> open;
  final StreamController<int> _openController;

  DocumentListComponent._(this._storage, this.open, this._openController);
  factory DocumentListComponent(StorageService storage) {
    var controller = StreamController<int>();
    return DocumentListComponent._(storage, controller.stream, controller);
  }

  Future<List<DocumentWithId>> docListFuture = Future.value([]);

  @override
  void ngOnInit() {
    docListFuture = _storage.listDocuments();
  }

  void openDocument(int id) {
    _openController.add(id);
  }

  Future<void> deleteDocument(int id) async {
    await _storage.deleteDocumentAndImages(id);
    docListFuture = _storage.listDocuments();
  }

  Future<void> renderDocument(int id) async {
    print('render $id');
  }
}
