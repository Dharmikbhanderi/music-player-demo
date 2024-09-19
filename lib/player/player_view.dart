import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musicplayer/constants/app_text.dart';
import 'package:musicplayer/home/home_controller.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlayerScreen extends StatelessWidget {
  final List<SongModel> data;
  final HomeController controller = Get.put(HomeController());

  PlayerScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text('Music Player',
              style: AppText.textBold.copyWith(fontSize: 30))),
      body: Obx(
        () => Column(
          children: [
            Expanded(
                child: Container(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              height: 300,
              width: 300,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.lightBlue),
              alignment: Alignment.center,
              child: QueryArtworkWidget(
                id: data[controller.playIndex.value].id,
                type: ArtworkType.AUDIO,
                artworkHeight: double.infinity,
                artworkWidth: double.infinity,
                nullArtworkWidget: const Icon(Icons.music_note, color: Colors.black),
              ),
            )),
            Expanded(
                child: Container(
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(16))),
              child: Column(
                children: [
                  Text(data[controller.playIndex.value].displayNameWOExt,
                      style: AppText.textBold
                          .copyWith(color: Colors.black, fontSize: 24),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2),
                  Text(data[controller.playIndex.value].artist.toString(),
                      style: AppText.textBold
                          .copyWith(color: Colors.black, fontSize: 20),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2),
                  Obx(
                    () => Row(
                      children: [
                        Text(controller.position.value),
                        Expanded(
                            child: Slider(
                                min: const Duration(seconds: 0).inSeconds.toDouble(),
                                max: controller.max.value,
                                value: controller.value.value,
                                onChanged: (newValue) {
                                  controller.changeDurationToSeconds(
                                      newValue.toInt());
                                  newValue = newValue;
                                })),
                        Text(controller.duration.value),
                      ],
                    ).marginOnly(bottom: 20),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                          onPressed: () {
                            controller.playSong(
                                data[controller.playIndex.value].uri,
                                controller.playIndex.value - 1);
                          },
                          icon: const Icon(Icons.skip_previous_rounded, size: 50)),
                      Obx(
                        () => CircleAvatar(
                            radius: 35,
                            backgroundColor: Colors.orange,
                            child: Transform.scale(
                                scale: 2.5,
                                child: IconButton(
                                    onPressed: () {
                                      if (controller.isPlaying.value) {
                                        controller.audioPlayer.pause();
                                        controller.isPlaying.value = false;
                                      } else {
                                        controller.audioPlayer.play();
                                        controller.isPlaying.value = true;
                                      }
                                    },
                                    icon: controller.isPlaying.value
                                        ? const Icon(Icons.pause)
                                        : const Icon(Icons.play_arrow_rounded)))),
                      ),
                      IconButton(
                          onPressed: () {
                            controller.playSong(
                                data[controller.playIndex.value].uri,
                                controller.playIndex.value + 1);
                          },
                          icon: const Icon(Icons.skip_next_rounded, size: 50)),
                    ],
                  )
                ],
              ),
            ))
          ],
        ).marginAll(10),
      ),
    );
  }
}
