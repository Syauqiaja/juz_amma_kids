import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

final class AdsHandler {
  InterstitialAd? _interstitialAd;
  bool isAdLoaded = false;

  int _numInterstitialLoadAttempts = 0;
  int maxFailedLoadAttempts = 3;

  Function(LoadAdError error)? onLoadError;
  Function(InterstitialAd ad)? onAdLoaded;

  void loadInterstitialAd(Function(InterstitialAd ad) onAdLoaded, Function(LoadAdError error) onLoadError){
    this.onAdLoaded = onAdLoaded;
    this.onLoadError = onLoadError;

    _createInterstitialAd();
  }

  String interstitialAdUnitId = Platform.isIOS
      ? "ca-app-pub-8447881626791136/7534507524"
      : "ca-app-pub-8447881626791136/5863732001";

  void showInterstitialAd(Function(InterstitialAd ad) onDismissed, Function() onNotReady){
    if(_interstitialAd == null){
      print("Trying to show interstitial ad before interstitial is loaded");
      onNotReady();
      return;
    }
    isAdLoaded = false;
    _interstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        _interstitialAd?.dispose();
        onDismissed(ad);
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        _interstitialAd?.dispose();
      },
    );

    _interstitialAd?.show();

    _interstitialAd = null;
  }

  void _createInterstitialAd() {
    isAdLoaded = false;

    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: _onAdLoaded,
        onAdFailedToLoad: _onAdFailedToLoad,
      ),
    );
  }

  void _onAdLoaded(InterstitialAd ad) {
    _interstitialAd = ad;
    _numInterstitialLoadAttempts = 0;
    isAdLoaded = true;

    onAdLoaded?.call(ad);
  }

  void _onAdFailedToLoad(LoadAdError error) {
    _numInterstitialLoadAttempts++;
    _interstitialAd = null;
    isAdLoaded = false;
    if(_numInterstitialLoadAttempts < maxFailedLoadAttempts){
      _createInterstitialAd();
    }else{
      onLoadError?.call(error);
    }
  }
}
