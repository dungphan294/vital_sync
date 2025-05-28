import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vital_sync_app/features/about/bloc/about_event.dart';
import '../../../core/services/app_info_service.dart';
import 'package:vital_sync_app/features/about/bloc/about_state.dart';

class AboutBloc extends Bloc<AboutEvent, AboutState> {
  AboutBloc() : super(AboutInitial()) {
    on<LoadAppInfo>((event, emit) async {
      final version = await AppInfoService.getVersion();
      emit(AboutLoaded(version));
    });
  }
}
