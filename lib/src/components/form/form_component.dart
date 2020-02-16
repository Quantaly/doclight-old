import 'dart:async';
import 'dart:html' as html;

import 'package:angular/angular.dart';
import 'package:angular_bloc/angular_bloc.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_forms/angular_forms.dart';

import '../../blocs/document_bloc.dart';
import '../image_display/image_display_component.dart';

@Component(
  selector: 'dl-form',
  templateUrl: 'form_component.html',
  styleUrls: ['form_component.css'],
  directives: [
    NgFor,
    materialInputDirectives,
    formDirectives,
    MaterialButtonComponent,
    MaterialIconComponent,
    ImageDisplayComponent,
  ],
  pipes: [
    BlocPipe,
  ],
)
class FormComponent implements OnInit, OnDestroy {
  final DocumentBloc bloc;

  FormComponent(this.bloc);

  @ViewChild('fileInput')
  html.FileUploadInputElement fileInput;

  Control<String> nameControl = Control('');
  StreamSubscription _nameSubscription;

  @override
  void ngOnInit() {
    _nameSubscription =
        bloc.listen((state) => nameControl.updateValue(state.workingDoc.name));
  }

  void updateName() {
    bloc.add(ChangeName()..newName = nameControl.value);
  }

  void getImage() {
    fileInput.click();
  }

  void addImage(html.Blob image) {
    bloc.add(AddImage()..image = image);
  }

  void rotateImage(int index) {
    bloc.add(RotateImage()..index = index);
  }

  void removeImage(int index) {
    bloc.add(DeleteImage()..index = index);
  }

  void render() {
    bloc.add(ExportPdf()..id = bloc.state.workingId);
  }

  @override
  void ngOnDestroy() {
    _nameSubscription.cancel();
  }
}
