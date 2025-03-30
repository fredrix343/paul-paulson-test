import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import '../methods/google_tts_methods.dart';

class TTSController extends GetxController {
  final ttsService = TTSService();
  final audioPlayer = AudioPlayer();
  final textController = TextEditingController();
  RxBool isAudio = false.obs;
  var isPlaying = false.obs;
  var isTTS = true.obs;
  var duration = Duration.zero.obs;
  var position = Duration.zero.obs;
  var currentText = "".obs;
  @override
  void onInit() {
    super.onInit();
    ttsService.initTTS(apiKey: "AIzaSyAFUrdqh73freOpxK5rZewS97ODdfAaQzc");

    audioPlayer.onDurationChanged.listen((d) => duration.value = d);
    audioPlayer.onPositionChanged.listen((p) => position.value = p);
    audioPlayer.onPlayerComplete.listen((_) => isPlaying.value = false);
  }

  Future<void> speak({String? textInput}) async {
    final newText = textInput?.trim() ?? '';
    if (newText.isEmpty) return;

    // Stop previous audio
    await audioPlayer.stop();
    isPlaying.value = false;

    currentText.value = newText;

    final file = await ttsService.textToSpeech(newText);
    await audioPlayer.play(DeviceFileSource(file.path));
    isPlaying.value = true;
  }

  void togglePlay() async {
    if (isPlaying.value) {
      await audioPlayer.pause();
    } else {
      await audioPlayer.resume();
    }
    isPlaying.toggle();
  }

  void rewind() {
    final newPos = position.value - Duration(seconds: 15);
    audioPlayer.seek(newPos < Duration.zero ? Duration.zero : newPos);
  }

  void forward() {
    final newPos = position.value + Duration(seconds: 15);
    if (newPos < duration.value) audioPlayer.seek(newPos);
  }

  String formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(d.inMinutes)}:${twoDigits(d.inSeconds % 60)}";
  }

  @override
  void onClose() {
    audioPlayer.dispose();
    textController.dispose();
    super.onClose();
  }
}
