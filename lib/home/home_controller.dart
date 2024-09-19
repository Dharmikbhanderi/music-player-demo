import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

class HomeController extends GetxController {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  final AudioPlayer audioPlayer = AudioPlayer();
  RxBool hasPermission = false.obs;
  var playIndex = 0.obs;
  var isPlaying = false.obs;
  final duration = "".obs;
  final position = "".obs;
  final max = 0.0.obs;
  final value = 0.0.obs;

  var connectionType = ConnectivityResult.none.obs;
  var hasConnection = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkAndRequestPermissions();
    checkConnectivity();
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      connectionType.value = result;
      hasConnection.value = result != ConnectivityResult.none;
      showSnackbar(result);
    });
  }

  void checkConnectivity() async {
    final result = await Connectivity().checkConnectivity();
    connectionType.value = result;
    hasConnection.value = result != ConnectivityResult.none;
    showSnackbar(result);
  }

  void showSnackbar(ConnectivityResult result) {
    String message;
    if (result == ConnectivityResult.none) {
      message = 'Internet connection lost!';
    } else {
      message = 'Internet connection restored!';
    }
    Get.snackbar('Connectivity', message, duration: Duration(seconds: 2));
  }

  changeDurationToSeconds(seconds) {
    var duration = Duration(seconds: seconds);
    audioPlayer.seek(duration);
  }

  updatePosition() {
    audioPlayer.durationStream.listen((d) {
      duration.value = d.toString().split(".")[0];
      max.value = d!.inSeconds.toDouble();
    });
    audioPlayer.positionStream.listen((p) {
      position.value = p.toString().split(".")[0];
      value.value = p.inSeconds.toDouble();
    });
  }

  playSong(String? uri, index) {
    playIndex.value = index;
    try {
      audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(uri!)));
      audioPlayer.play();
      isPlaying.value = true;
      updatePosition();
    } on Exception catch (e) {
      print('Error is ====>>>>${e.toString()}');
    }
  }

  checkAndRequestPermissions({bool retry = false}) async {
    hasPermission.value = await _audioQuery.checkAndRequest(
      retryRequest: retry,
    );
  }

  Future<List<SongModel>> getSongs() {
    return _audioQuery.querySongs(
      sortType: null,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );
  }
}
