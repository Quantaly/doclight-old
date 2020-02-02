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

  @Output()
  final Stream<Object> rotate;
  final StreamController<Object> _rotateController;

  ImageDisplayComponent._(this.delete, this._deleteController, this.rotate,
      this._rotateController, this._sanitizer);
  factory ImageDisplayComponent(DomSanitizationService sanitizer) {
    var delete = StreamController<Object>();
    var rotate = StreamController<Object>();
    return ImageDisplayComponent._(
        delete.stream, delete, rotate.stream, rotate, sanitizer);
  }

  SafeUrl get safeSrc => _sanitizer.bypassSecurityTrustUrl(src);

  void triggerDelete() => _deleteController.add(null);
  void triggerRotate() => _rotateController.add(null);
}
