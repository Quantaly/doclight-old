import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

import 'src/components/document_list/document_list_component.dart';
import 'src/components/form/form_component.dart';
import 'src/services/storage_service.dart';

// AngularDart info: https://angulardart.dev
// Components info: https://angulardart.dev/components

@Component(
  selector: 'dl-app',
  templateUrl: 'app_component.html',
  styleUrls: [
    'app_component.css',
    'package:angular_components/app_layout/layout.scss.css',
  ],
  directives: [
    NgIf,
    MaterialButtonComponent,
    MaterialTemporaryDrawerComponent,
    MaterialIconComponent,
    MaterialSpinnerComponent,
    FormComponent,
    DeferredContentDirective,
    DocumentListComponent,
  ],
  providers: [
    ClassProvider(StorageService),
  ],
  exports: [print],
)
class AppComponent implements OnInit {
  final StorageService _storage;

  AppComponent(this._storage);

  bool ready = false;
  int workingDocumentId;

  @override
  void ngOnInit() {
    () async {
      workingDocumentId = await _storage.createDocument();
      ready = true;
    }();
  }
}
