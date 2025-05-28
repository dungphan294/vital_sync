import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:vital_sync_app/app.dart';
import 'package:vital_sync_app/bloc_observer.dart';

void main() {
  Bloc.observer = AppBlocObserver();
  runApp(const VitalSyncApp());
}
