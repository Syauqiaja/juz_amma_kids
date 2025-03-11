part of 'quran_bloc.dart';

sealed class QuranEvent extends Equatable {
  const QuranEvent();

  @override
  List<Object> get props => [];
}

class PlaySequential extends QuranEvent{
  final int startAya;

  PlaySequential({required this.startAya});
}

class PlayNext extends QuranEvent{}
class PlayPrev extends QuranEvent{}

class PlayRepeating extends QuranEvent{
  final int startAya;
  final int endAya;
  final int repeatingCount;

  PlayRepeating({required this.startAya, required this.endAya, required this.repeatingCount});
}

class PauseQuran extends QuranEvent{}
class ResumeQuran extends QuranEvent{}
class StopRepeating extends QuranEvent{}

class LoadQuran extends QuranEvent{
  final int surahIndex;

  LoadQuran({required this.surahIndex});
}
class IdleQuran extends QuranEvent{}