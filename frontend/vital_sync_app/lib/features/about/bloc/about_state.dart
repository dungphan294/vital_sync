abstract class AboutState {}

class AboutInitial extends AboutState {}

class AboutLoaded extends AboutState {
  final String version;
  AboutLoaded(this.version);
}
