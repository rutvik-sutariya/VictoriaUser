import 'package:audioplayers/audioplayers.dart';

class AudioService {
  final player = AudioPlayer();

  Future<void> playClick() async {
    await player.play(AssetSource('audio/notification.mp3'));
  }
}
