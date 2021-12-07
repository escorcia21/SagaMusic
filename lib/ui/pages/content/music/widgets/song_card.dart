import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_egresados/domain/use_cases/controllers/music_controller.dart';

class SongCard extends StatelessWidget {
  final String songName,
      artistName,
      playbackSeconds,
      albumName,
      preview,
      albumImg;
  const SongCard({
    Key? key,
    required this.songName,
    required this.artistName,
    required this.playbackSeconds,
    required this.albumName,
    required this.preview,
    required this.albumImg,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MusicController controller = Get.find();
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Image.network(albumImg),
          Padding(
            padding: const EdgeInsets.all(4),
            child: ListTile(
                onTap: () {
                  controller.play(preview);
                  controller.currentSong = preview;
                  controller.currentImg = albumImg;
                  controller.currentTime = playbackSeconds;
                  controller.iconData = Icons.pause;
                },
                title: Text(
                  songName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(artistName),
                    Text(albumName),
                    Text(playbackSeconds)
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
