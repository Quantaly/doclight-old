import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

@Component(
  selector: 'dl-form',
  templateUrl: 'form_component.html',
  styleUrls: ['form_component.css'],
)
class FormComponent {
  @Input()
  int working;
}
