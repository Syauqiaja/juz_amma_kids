part of 'localization_bloc.dart';

sealed class LocalizationEvent extends Equatable {
  const LocalizationEvent();

  @override
  List<Object> get props => [];
}

final class LoadLocalization extends LocalizationEvent{}

final class SaveLocalization extends LocalizationEvent{
  final LanguageEntity language;

  SaveLocalization({required this.language});
}