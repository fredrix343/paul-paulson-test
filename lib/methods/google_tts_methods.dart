import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_text_to_speech/cloud_text_to_speech.dart';
import 'package:path_provider/path_provider.dart';

class TTSService {
  bool _isInitialized = false;
  late VoiceGoogle _selectedVoice;
  // api key: AIzaSyAFUrdqh73freOpxK5rZewS97ODdfAaQzc

  Future<void> initTTS({required String apiKey}) async {
    if (_isInitialized) return;

    // Initialize with API key
    TtsGoogle.init(params: InitParamsGoogle(apiKey: apiKey), withLogs: true);

    // Get voices
    final voicesResponse = await TtsGoogle.getVoices();
    final voices = voicesResponse.voices;

    // Pick first English voice
    _selectedVoice =
        voices.where((element) => element.locale.code.startsWith("en-")).first;

    _isInitialized = true;
  }

  Future<File> textToSpeech(String text) async {
    if (!_isInitialized) {
      throw Exception('TTS not initialized. Call initTTS() first.');
    }

    final ttsParams = TtsParamsGoogle(
      voice: _selectedVoice,
      audioFormat: AudioOutputFormatGoogle.mp3,
      text: text,
      rate: 'slow',
      pitch: 'default',
    );

    final ttsResponse = await TtsGoogle.convertTts(ttsParams);
    final audioBytes = ttsResponse.audio.buffer.asUint8List();

    final tempDir = await getTemporaryDirectory();
    final filePath = '${tempDir.path}/tts_output.mp3';
    final audioFile = File(filePath);
    await audioFile.writeAsBytes(audioBytes);

    return audioFile;
  }
}
