part of 'select_sora_cubit.dart';

sealed class SelectSoraState extends Equatable {
  const SelectSoraState();

  @override
  List<Object> get props => [];
}

final class SelectSoraInitial extends SelectSoraState {}
final class SelectSoraLoading extends SelectSoraState {}
final class SelectSoraError extends SelectSoraState{
  final String message;

  SelectSoraError({required this.message});
}
final class SelectSoraWithData extends SelectSoraState{
  final List<Surah> surahs;

  SelectSoraWithData({required this.surahs});
}
