import 'package:equatable/equatable.dart';

abstract class AboutState extends Equatable {
  const AboutState();

  @override
  List<Object?> get props => [];
}

class AboutInitial extends AboutState {
  const AboutInitial();

  @override
  List<Object?> get props => [];
}

class AboutLoading extends AboutState {}

class AboutLoaded extends AboutState {
  final String version;
  const AboutLoaded(this.version);
  @override
  List<Object?> get props => [version];
}

class AboutError extends AboutState {
  final String? message;
  const AboutError(String s, {this.message});
}
