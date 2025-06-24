part of 'localization_bloc.dart';

sealed class LocalizationState extends Equatable {
  final Locale locale;
  const LocalizationState(this.locale);
  
  @override
  List<Object> get props => [];
}

final class LocalizationInitial extends LocalizationState {
  const LocalizationInitial(super.locale);
}
final class LocalizationLoaded extends LocalizationState{
  const LocalizationLoaded(super.locale);
  
  @override
  List<Object> get props => [super.locale];
}