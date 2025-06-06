import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vital_sync_app/features/about/bloc/about_event.dart';
import '../../../core/services/app_info_service.dart';
import 'package:vital_sync_app/features/about/bloc/about_state.dart';

class AboutBloc extends Bloc<AboutEvent, AboutState> {
  AboutBloc() : super(AboutInitial()) {
    on<LoadAppInfo>(_onLoadAppInfo);
  }

  Future<void> _onLoadAppInfo(
    LoadAppInfo event,
    Emitter<AboutState> emit,
  ) async {
    emit(AboutInitial());
    try {
      final version = await AppInfoService.getAppVersion();
      emit(AboutLoaded(version));
    } catch (_) {
      emit(AboutError('Failed to load app info')); // Handle error appropriately
    }
  }
}
