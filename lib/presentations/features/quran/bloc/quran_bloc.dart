import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:juz_amma_kids/core/model/lesson.dart';
import 'package:juz_amma_kids/core/model/surah_word.dart';
import 'package:juz_amma_kids/core/services/database_service.dart';

part 'quran_event.dart';
part 'quran_state.dart';

class QuranBloc extends Bloc<QuranEvent, QuranState> {
  final Surah surah;
  DatabaseService databaseService = DatabaseService();
  bool isRepeating = false;
  bool isPlaying = false;
  int selectedAyahIndex = 0;
  int _currentIndex = 0;
  int totalLine = 0;
  int maxAya = 0;
  List<SurahWord> surahWords = [];
  List<SurahWord> disabledWords = [];
  List<int> ayahs = [];
  List<int> wordPerLines = [];

  QuranBloc(this.surah) : super(QuranInitial()) {
    on<PlaySequential>(_onPlaySequential);
    on<PlayNext>(_onPlayNext);
    on<PlayPrev>(_onPlayPrev);
    on<PlayRepeating>(_onPlayRepeating);
    on<PauseQuran>(_onPauseQuran);
    on<ResumeQuran>(_onResumeQuran);
    on<StopRepeating>(_onStopRepeating);
    on<LoadQuran>(_onLoadQuran);
    on<IdleQuran>(_onIdleQuran);
  }

  Future<void> _onPlaySequential(PlaySequential event, Emitter<QuranState> emit) async {
    print("QuranBloc: onPlaySequential");
    isPlaying = true;
    isRepeating = false;
    selectedAyahIndex = event.startAya;
    _currentIndex = ayahs.indexOf(selectedAyahIndex);
    emit(QuranPlaying(startAya: event.startAya));
  }

  Future<void> _onPlayRepeating(PlayRepeating event, Emitter<QuranState> emit) async {
    print("QuranBloc: onPlayRepeating");
    isRepeating = true;
    isPlaying = true;
    selectedAyahIndex = event.startAya;
    _currentIndex = ayahs.indexOf(selectedAyahIndex);
    emit(QuranPlaying(startAya: event.startAya, endAya: event.endAya, repeatCount: event.repeatingCount));
  }

  Future<void> _onPauseQuran(PauseQuran event, Emitter<QuranState> emit) async {
    isPlaying = false;
    emit(QuranPaused(isRepeating: isRepeating));
  }

  Future<void> _onStopRepeating(StopRepeating event, Emitter<QuranState> emit) async {
    isRepeating = false;
    isPlaying = false;
    emit(QuranStopped(currentAya: selectedAyahIndex));
  }

  Future<void> _onLoadQuran(LoadQuran event, Emitter<QuranState> emit) async {
    emit(QuranLoading());

    surahWords = (await databaseService.getSurah(event.surahIndex)).words ?? [];
    disabledWords = await databaseService.getDisabledWords(event.surahIndex);
    totalLine = _getTotalLine();
    maxAya = _getMaxAya();

    for (var i = 1; i <= totalLine; i++) {
      wordPerLines.add(surahWords.where((e)=>e.line == i).length);
    }

    ayahs = surahWords.map((e) => e.aya).toSet().toList();
    ayahs.insert(0, 0);

    emit(QuranIdle());
  }

  Future<void> _onIdleQuran(IdleQuran event, Emitter<QuranState> emit) async {
    emit(QuranIdle());
  }

  double findLineOfAyah(int ayahIndex){
    if(surahWords.isEmpty) return 0;
    
    final lastWord = surahWords.lastWhere((e)=>e.aya == ayahIndex);
    final firstWord = surahWords.firstWhere((e)=>e.aya == ayahIndex);
    return (lastWord.line + firstWord.line) / 2;
  }

  int _getTotalLine(){
    if(surahWords.isEmpty) return 0;
    return surahWords.fold(0, (prev, element) => max(prev, element.line));
  }
  int _getMaxAya(){
    if(surahWords.isEmpty) return 0;
    return surahWords.fold(0, (prev, element) => max(prev, element.aya));
  }

  Future<void> _onPlayNext(PlayNext event, Emitter<QuranState> emit) async {
    isPlaying = true;
    if(_currentIndex != ayahs.length - 1){
      selectedAyahIndex = ayahs[++_currentIndex];
      emit(QuranPlaying(startAya: selectedAyahIndex));
    }else{
      emit(QuranIdle());
    }
  }

  Future<void> _onPlayPrev(PlayPrev event, Emitter<QuranState> emit) async {
    isPlaying = true;
    if(_currentIndex > 0){
      selectedAyahIndex = ayahs[--_currentIndex];
      emit(QuranPlaying(startAya: selectedAyahIndex));
    }
  }

  Future<void> _onResumeQuran(ResumeQuran event, Emitter<QuranState> emit) async {
    isPlaying = true;
    emit(QuranPlaying());
  }
}
