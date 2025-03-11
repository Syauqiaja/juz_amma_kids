import 'package:flutter_sound/flutter_sound.dart';
import 'package:juz_amma_kids/core/services/resource_loader.dart';
import 'package:juz_amma_kids/locator/assets.dart';

extension AudioPlayerExt on FlutterSoundPlayer {
  playButton() async {
    await this.startPlayer(
        fromDataBuffer:
            await ResourceLoader.getFromAsset(Assets.audioAssets.button));
  }
  playOpenPanel() async {
    await this.startPlayer(fromDataBuffer: await ResourceLoader.getFromAsset(Assets.audioAssets.openPanel));
  }
  playClosePanel() async {
    await this.startPlayer(fromDataBuffer: await ResourceLoader.getFromAsset(Assets.audioAssets.closePanel));
  }
  playError() async {
    await this.startPlayer(fromDataBuffer: await ResourceLoader.getFromAsset(Assets.audioAssets.negative));
  }
}
