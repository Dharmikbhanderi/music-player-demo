import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musicplayer/constants/app_colors.dart';
import 'package:musicplayer/constants/app_text.dart';
import 'package:musicplayer/home/home_controller.dart';
import 'package:musicplayer/player/player_view.dart';
import 'package:on_audio_query/on_audio_query.dart';

class HomeScreen extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          centerTitle: true,
          title: Text('Music Player',
              style: AppText.textBold.copyWith(fontSize: 30))),
      body: Obx(
        () {
          return/* !controller.hasPermission.value
              ? noAccessToLibraryWidget()
              :*/ !controller.hasConnection.value?
               Center(child: Text('Please turn on internet',style: AppText.textRegular.copyWith(
               color: Colors.yellow, fontSize: 20),))
              : FutureBuilder<List<SongModel>>(
                  future: controller.getSongs(),
                  builder: (context, item) {
                    if (item.hasError) {
                      return Text(item.error.toString(),style: AppText.textRegular
                          .copyWith(color: Colors.white));
                    }
                    if (item.data == null) {
                      return const Center(child: CircularProgressIndicator(color: Colors.white,));
                    }
                    if (item.data!.isEmpty) {
                      return Center(
                        child: Text("No Data Found",style: AppText.textRegular
                            .copyWith(color: Colors.white),),
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.all(10),
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: item.data!.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15)),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 5),
                              color: Colors.teal.shade100,
                              child: ListTile(
                                title: Text(
                                  item.data![index].displayNameWOExt,
                                  style: AppText.textRegular.copyWith(
                                      color: primaryColor, fontSize: 20),
                                ),
                                subtitle: Text(
                                  '${index + 1} ${item.data![index].artist}',
                                  style: AppText.textRegular
                                      .copyWith(color: primaryColor),
                                ),
                                leading: QueryArtworkWidget(
                                  id: item.data![index].id,
                                  type: ArtworkType.AUDIO,
                                  nullArtworkWidget: const Icon(Icons.music_note,color: Colors.black),
                                ),
                                trailing: controller.playIndex.value == index && controller.isPlaying.value
                                    ? const Icon(Icons.pause,color: Colors.black)
                                    : const Icon(Icons.play_arrow,color: Colors.black),
                                onTap: () {
                                  Get.to(PlayerScreen(data: item.data!),
                                      transition: Transition.downToUp);
                                     controller.playSong(item.data![index].uri, index);
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
        },
      ),
    );
  }

  Widget noAccessToLibraryWidget() {
    return const Text("please allow permission");
    /* Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.redAccent.withOpacity(0.5),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Application doesn't have access to the library"),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => controller.checkAndRequestPermissions(retry: true),
            child: const Text("Allow"),
          ),
        ],
      ),
    );*/
  }
}
