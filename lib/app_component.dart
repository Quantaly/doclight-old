import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

import 'src/components/form/form_component.dart';
import 'src/services/storage_service.dart';

// AngularDart info: https://angulardart.dev
// Components info: https://angulardart.dev/components

@Component(selector: 'dl-app', templateUrl: 'app_component.html', styleUrls: [
  'app_component.css',
  'package:angular_components/app_layout/layout.scss.css',
], directives: [
  MaterialButtonComponent,
  MaterialTemporaryDrawerComponent,
  MaterialIconComponent,
  FormComponent,
], providers: [
  ClassProvider(StorageService),
])
class AppComponent {}
