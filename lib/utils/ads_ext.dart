import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

extension InterstitialAdsExt on InterstitialAd{
  String getAdsId(){
    return Platform.isIOS ? "ca-app-pub-8447881626791136/7534507524" : "ca-app-pub-8447881626791136/5863732001";
  }
}