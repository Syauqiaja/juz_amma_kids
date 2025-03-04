import 'package:flutter/services.dart';

class ResourceLoader {
  static Future<Uint8List> getRecitation(int soraIndex, int ayaIndex) async {
    if (ayaIndex == 0 && soraIndex != 1) {
      return (await rootBundle.load("assets/voice/Basmalah.mp3")).buffer.asUint8List();
    }

    String paddedAya = ayaIndex.toString().padLeft(3, '0');
    String paddedSora = soraIndex.toString().padLeft(3, '0');
    return (await rootBundle.load("assets/voice/recitation/$paddedSora/$paddedSora$paddedAya.mp3")).buffer.asUint8List();
  }

  static Future<Uint8List> getFromAsset(String asset) async {
    return (await rootBundle.load(asset)).buffer.asUint8List();
  }
}
