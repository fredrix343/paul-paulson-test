import 'package:aiappmaster/controllers/stt_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import '../controllers/tts_controller.dart';
import '../controllers/tts_controller.dart';
import '../models/message.dart'; // your Message model

class TTSHomePage extends StatelessWidget {
  final TTSController c = Get.find<TTSController>();
  final STTController con = Get.find<STTController>();

  @override
  Widget build(BuildContext context) {
    return Column(children: [SizedBox(height: 10), _buildMessageList()]);
  }

  Widget _buildMessageList() {
    return Obx(
      () => ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: con.messages.length,
        reverse: true,
        padding: const EdgeInsets.symmetric(vertical: 10),
        itemBuilder: (context, index) {
          final msg = con.messages[con.messages.length - 1 - index];
          return Align(
            alignment:
                msg.isUser == true
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              decoration: BoxDecoration(
                color:
                    msg.isUser == true
                        ? const Color(0xff1c2d40)
                        : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(12),
              ),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: msg.messageString ?? '',
                      style: TextStyle(
                        color:
                            msg.isUser == true ? Colors.white : Colors.black87,
                        fontSize: 16,
                      ),
                    ),
                    if (msg.isUser == false)
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child:
                            msg.messageString == "Thinking..."
                                ? SizedBox()
                                : Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder:
                                            (context) => AlertDialog(
                                              title: const Text("Speak Text"),
                                              content: const Text(
                                                "Would you like to speak this message?",
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed:
                                                      () => Navigator.pop(
                                                        context,
                                                      ),
                                                  child: const Text("Cancel"),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    await c.audioPlayer
                                                        .stop(); // Stop any existing playback
                                                    c.isPlaying.value = false;
                                                    c.currentText.value =
                                                        ""; // Clear old text
                                                    await c.speak(
                                                      textInput:
                                                          msg.messageString,
                                                    ); // Speak new message
                                                    c.isAudio.value = true;
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text("Speak"),
                                                ),
                                              ],
                                            ),
                                      );
                                      // call your TTS logic here
                                      // e.g. flutterTts.speak(msg.messageString ?? '');
                                    },
                                    child: Row(
                                      children: [
                                        Text(
                                          "Convert to Audio",
                                          style: TextStyle(color: Colors.blue),
                                        ),
                                        SizedBox(width: 5),
                                        Icon(
                                          Icons.volume_up,
                                          size: 18,
                                          color: Colors.blue,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
