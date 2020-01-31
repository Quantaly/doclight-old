import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular/security.dart';
import 'package:angular_components/angular_components.dart';

@Component(
  selector: 'dl-image-display',
  templateUrl: 'image_display_component.html',
  styleUrls: ['image_display_component.css'],
  directives: [
    MaterialFabComponent,
    MaterialIconComponent,
  ],
)
class ImageDisplayComponent {
  final DomSanitizationService _sanitizer;

  @Input()
  String src;

  @Output()
  final Stream<Object> delete;
  final StreamController<Object> _deleteController;

  ImageDisplayComponent._(this.delete, this._deleteController, this._sanitizer);
  factory ImageDisplayComponent(DomSanitizationService sanitizer) {
    var controller = StreamController<Object>();
    return ImageDisplayComponent._(controller.stream, controller, sanitizer);
  }

  SafeUrl get safeSrc => _sanitizer.bypassSecurityTrustUrl(src);

  void triggerDelete() => _deleteController.add(null);
}
