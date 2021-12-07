import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
// import 'package:red_egresados/ui/pages/content/music/widgets/song_card.dart';
import 'package:audioplayers/audioplayers.dart';

class MusicController extends GetxController {
  // Observables
  RxString _currentSong = "".obs;
  RxString _currentImg = "".obs;
  RxString _currentTime = "".obs;

  final AudioPlayer _audioPlayer = AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);
  Rx<Duration> _duration = const Duration().obs;
  Rx<Duration> _position = const Duration().obs;

  RxBool _isPlaying = false.obs;
  Rx<IconData> _iconData = Icons.play_arrow.obs;

  // Setters
  set currentImg(String value) {
    _currentImg.value = value;
  }

  set currentSong(String value) {
    _currentSong.value = value;
  }

  set currentTime(String value) {
    _currentTime.value = value;
  }

  set isPlaying(bool value) {
    _isPlaying.value = value;
  }

  set iconData(IconData value) {
    _iconData.value = value;
  }

  // Getters
  bool get isPlaying => _isPlaying.value;
  IconData get iconData => _iconData.value;
  Duration get durantion => _duration.value;
  Duration get position => _position.value;
  String get currentImg => _currentImg.value;
  String get currentTime => _currentTime.value;
  String get currentSong => _currentSong.value;

  play(String url) async {
    if (_isPlaying.value && (_currentSong.value != url)) {
      _audioPlayer.pause();
      int result = await _audioPlayer.play(url);

      if (result == 1) {
        currentSong = url;
      }
    } else if (!_isPlaying.value) {
      int result = await _audioPlayer.play(url);

      if (result == 1) {
        isPlaying = true;
      }
    }
    _audioPlayer.onDurationChanged.listen((event) {
      _duration.value = event;
    });

    _audioPlayer.onAudioPositionChanged.listen((event) {
      _position.value = event;
    });
  }

  playerManagement() {
    if (currentSong != "") {
      if (isPlaying) {
        _audioPlayer.pause();
        iconData = Icons.play_arrow;
        isPlaying = false;
      } else if (!isPlaying && isPlaying == false) {
        _audioPlayer.resume();
        iconData = Icons.pause;
        isPlaying = true;
      }
    }
  }
}
