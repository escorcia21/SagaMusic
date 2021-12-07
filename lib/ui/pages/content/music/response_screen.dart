import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:red_egresados/data/services/track_pool.dart';
import 'package:red_egresados/domain/models/track_model.dart';
import 'package:red_egresados/domain/use_cases/controllers/music_controller.dart';
import 'package:red_egresados/ui/pages/content/music/widgets/song_card.dart';

class ResponseScreen extends StatefulWidget {
  const ResponseScreen({Key? key}) : super(key: key);
  @override
  _CustomResponseScreen createState() => _CustomResponseScreen();
}

class _CustomResponseScreen extends State<ResponseScreen> {
  MusicController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    TrackPoolService service = TrackPoolService();
    Future<List<TrackModel>> futureJobs = service.fecthData();
    return FutureBuilder<List<TrackModel>>(
      future: futureJobs,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final items = snapshot.data!;
          return Column(
            //body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    TrackModel track = items[index];
                    return SongCard(
                      songName: track.name,
                      artistName: track.artistName,
                      playbackSeconds: track.playbackSeconds,
                      albumName: track.albumName,
                      preview: track.preview,
                      albumImg: track.albumImg,
                    );
                  },
                ),
              ),
              Column(
                children: [
                  Obx(() => Slider.adaptive(
                      value: controller.position.inSeconds.toDouble(),
                      min: 0.0,
                      max: controller.durantion.inSeconds.toDouble(),
                      onChanged: (value) {})),
                  Padding(
                      padding: const EdgeInsets.only(left: 12.0, right: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Obx(
                            () => Container(
                              width: 60.0,
                              height: 60.0,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image:
                                          NetworkImage(controller.currentImg))),
                            ),
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          Expanded(
                            child: Obx(() => Text(controller.currentTime)),
                          ),
                          IconButton(
                              onPressed: () {
                                controller.playerManagement();
                              },
                              icon: Obx(() => Icon(controller.iconData)))
                        ],
                      ))
                ],
              )
            ],
            //),
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }

        // By default, show a loading spinner.
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
