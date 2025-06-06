import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vital_sync_app/app.dart';
import 'package:vital_sync_app/bloc_observer.dart';
import 'package:vital_sync_app/core/services/vital_sync_api_service.dart';
import 'package:vital_sync_app/data/repositories/user_repository.dart';
import 'package:vital_sync_app/data/repositories/phone_repository.dart';
import 'package:vital_sync_app/data/repositories/device_repository.dart';
import 'package:vital_sync_app/data/repositories/workout_repository.dart';
import 'package:vital_sync_app/data/repositories/data_repository.dart';

void main() {
  Bloc.observer = AppBlocObserver();

  final apiService = VitalSyncApiService();

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (_) => UserRepository(apiService: apiService),
        ),
        RepositoryProvider(
          create: (_) => PhoneRepository(apiService: apiService),
        ),
        RepositoryProvider(
          create: (_) => DeviceRepository(apiService: apiService),
        ),
        RepositoryProvider(
          create: (_) => WorkoutRepository(apiService: apiService),
        ),
        RepositoryProvider(
          create: (_) => DataRepository(apiService: apiService),
        ),
      ],
      child: const VitalSyncApp(),
    ),
  );
}
