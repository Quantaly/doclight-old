import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

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
    MaterialButtonComponent,
    MaterialTemporaryDrawerComponent,
    MaterialIconComponent,
  ],
)
class AppComponent {}
