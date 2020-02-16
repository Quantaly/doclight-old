import 'dart:html';
import 'dart:indexed_db';

import 'package:angular/angular.dart';
import 'package:service_worker/window.dart' as sw;

import 'package:doclight/app_component.template.dart' as ng;

import 'main.template.dart' as self;

@GenerateInjector([FactoryProvider(IdbFactory, provideIndexedDb)])
final InjectorFactory injector = self.injector$Injector;

void main() {
  // use 127.0.0.1 to locally test service worker
  if (sw.isSupported && !window.location.host.contains('localhost')) {
    sw.register('sw.dart.js');
  }
  runApp(ng.AppComponentNgFactory, createInjector: injector);
}

IdbFactory provideIndexedDb() => window.indexedDB;
