import 'package:angular/angular.dart';
import 'package:angular_bloc/angular_bloc.dart';
import 'package:angular_components/angular_components.dart';

import 'src/blocs/document_bloc.dart';
import 'src/components/document_list/document_list_component.dart';
import 'src/components/form/form_component.dart';
import 'src/components/pwa_prompt/pwa_prompt.dart';
import 'src/services/pwa_prompt_service.dart';
import 'src/services/storage_service.dart';
import 'src/services/worker_service.dart';

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
    PwaPrompt,
  ],
  providers: [
    ClassProvider(DocumentBloc),
    ClassProvider(StorageService),
    ClassProvider(WorkerService),
    ClassProvider(RenderingService),
    ClassProvider(ImageManipulationService),
    ClassProvider(PwaPromptService),
  ],
  pipes: [
    BlocPipe,
  ],
)
class AppComponent implements OnInit {
  final DocumentBloc bloc;

  AppComponent(this.bloc);

  @override
  void ngOnInit() {
    bloc.add(InitEvent());
  }

  void openDocument(int id) {
    bloc.add(ChangeDocument()..id = id);
  }
}
