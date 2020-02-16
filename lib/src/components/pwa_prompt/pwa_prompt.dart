import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';

import '../../services/pwa_prompt_service.dart';

@Component(
  selector: 'dl-pwa-prompt',
  templateUrl: 'pwa_prompt.html',
  styleUrls: ['pwa_prompt.css'],
  directives: [coreDirectives],
)
class PwaPrompt implements OnInit, OnDestroy {
  final PwaPromptService _service;

  PwaPrompt(this._service);

  StreamSubscription<BeforeInstallPromptEvent> _subscription;
  BeforeInstallPromptEvent event;

  @override
  void ngOnInit() {
    _subscription = _service.prompt.listen((evt) {
      evt.preventDefault();
      if (!_service.dismissed) {
        event = evt;
        evt.userChoice.then((_) => event = null);
      }
    });
  }

  void yes() {
    if (event != null && !_service.dismissed) {
      event.prompt();
    }
  }

  void no() {
    _subscription?.cancel();
    _subscription = null;
    event = null;
    _service.dismissed = true;
  }

  @override
  void ngOnDestroy() {
    _subscription?.cancel();
    _subscription = null;
  }
}