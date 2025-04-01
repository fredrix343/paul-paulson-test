import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/stt_controller.dart';
import '../controllers/tts_controller.dart';
import '../models/message.dart';

class TTSHomePage extends StatelessWidget {
  final TTSController c = Get.find<TTSController>();
  final STTController con = Get.find<STTController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 10),

                _buildMessageList(context, constraints),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMessageList(BuildContext context, BoxConstraints constraints) {
    return Obx(
      () => ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: con.messages.length,
        reverse: true,
        padding: const EdgeInsets.symmetric(vertical: 10),
        itemBuilder: (context, index) {
          final msg = con.messages[con.messages.length - 1 - index];
          final isUser = msg.isUser == true;
          final bgColor =
              isUser ? const Color(0xff1c2d40) : Colors.grey.shade300;
          final textColor = isUser ? Colors.white : Colors.black87;

          return Align(
            alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
              constraints: BoxConstraints(
                maxWidth: constraints.maxWidth * 0.75,
              ),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: msg.messageString ?? '',
                      style: TextStyle(color: textColor, fontSize: 16),
                    ),
                    if (!isUser)
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child:
                            msg.messageString == "Thinking..."
                                ? const SizedBox()
                                : Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder:
                                            (_) => AlertDialog(
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
                                                    await c.audioPlayer.stop();
                                                    c.isPlaying.value = false;
                                                    c.currentText.value = "";
                                                    await c.speak(
                                                      textInput:
                                                          msg.messageString,
                                                    );
                                                    c.isAudio.value = true;
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text("Speak"),
                                                ),
                                              ],
                                            ),
                                      );
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: const [
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
