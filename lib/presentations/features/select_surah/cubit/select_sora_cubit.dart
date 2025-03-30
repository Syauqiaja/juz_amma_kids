import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:juz_amma_kids/core/model/surah.dart';
import 'package:juz_amma_kids/core/model/memorization_model.dart';
import 'package:juz_amma_kids/core/services/database_service.dart';
import 'package:juz_amma_kids/utils/ads_handler.dart';

part 'select_sora_state.dart';

class SelectSoraCubit extends Cubit<SelectSoraState> {
  SelectSoraCubit() : super(SelectSoraInitial());

  final DatabaseService _databaseService = DatabaseService();
  final AdsHandler _adsHandler = AdsHandler();

  int openSoraAttempts = 0;
  int maxOpenSoraAttemptsBeforeShowingAds = 4;

  load() async {
    emit(SelectSoraLoading());
    try {
      loadAd();
      final result = await _databaseService.getSurahs();
      emit(SelectSoraWithData(surahs: result));
    } catch (e) {
      print(e);
      emit(SelectSoraError(message: e.toString()));
    }
  }

  update(int soraId) async {
    if (state is SelectSoraWithData) {
      final index = (state as SelectSoraWithData)
          .surahs
          .indexWhere((e) => e.soraIndex == soraId);

      final result = await _databaseService.getSurah(soraId);
      final copiedList = (state as SelectSoraWithData).surahs;
      copiedList[index] = result;

      emit(SelectSoraWithData(surahs: copiedList));
    }
  }

  refresh() {
    final copiedList = (state as SelectSoraWithData).surahs;
    emit(SelectSoraLoading());
    emit(SelectSoraWithData(surahs: copiedList));
  }

  isReadyToShowAd() => openSoraAttempts >= maxOpenSoraAttemptsBeforeShowingAds;

  incrementOpenSoraAttempts(){
    openSoraAttempts++;
    print("SelectSoraCubit: open sora attempts $openSoraAttempts");
  }

  tryShowInterstitial(Function onDismissed){
    if(openSoraAttempts < maxOpenSoraAttemptsBeforeShowingAds) return;
    
    openSoraAttempts = 0;
    _adsHandler.showInterstitialAd((ad){
      onDismissed();
      loadAd();
    }, (){
      onDismissed();
      loadAd();
    });
  }

  loadAd(){
    _adsHandler.loadInterstitialAd((ad){
        print("SelectSoraCubit: interstitial ad loaded");
      }, (error){
        print("SelectSoraCubit: Failed to load interstitial ads becasue ${error.message}");
      });
  }
}
