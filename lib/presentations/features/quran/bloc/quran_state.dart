part of 'quran_bloc.dart';

sealed class QuranState extends Equatable {
  const QuranState();

  @override
  List<Object?> get props => [];
}

final class QuranInitial extends QuranState {}

final class QuranLoading extends QuranState {}

final class QuranIdle extends QuranState {}

final class QuranPlaying extends QuranState {
  final int? startAya;
  final int? endAya;
  final int? repeatCount;

  QuranPlaying({this.startAya, this.endAya, this.repeatCount});
  
  @override
  List<Object?> get props => [startAya];
}

final class QuranStopped extends QuranState{
  final int currentAya;

  QuranStopped({required this.currentAya});
}

final class QuranPaused extends QuranState {
  final bool isRepeating;

  QuranPaused({required this.isRepeating});

  @override
  List<Object> get props => [isRepeating];
}
