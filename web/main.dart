import 'dart:html';
import 'dart:indexed_db';

import 'package:angular/angular.dart';
import 'package:doclight/app_component.template.dart' as ng;

import 'main.template.dart' as self;

@GenerateInjector([FactoryProvider(IdbFactory, provideIndexedDb)])
final InjectorFactory injector = self.injector$Injector;

void main() {
  runApp(ng.AppComponentNgFactory, createInjector: injector);
}

IdbFactory provideIndexedDb() => window.indexedDB;
