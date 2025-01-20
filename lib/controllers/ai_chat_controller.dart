import 'package:get/get.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
class AiChatController extends GetxController {
  var messages = <types.Message>[].obs;

  final types.User user;

  AiChatController({required this.user});

  void addMessage(types.Message message) {
    messages.insert(0, message);
  }

  Future<void> getAiResponseStream(String prompt) async {
    final aiUser = const types.User(
        id: 'ai-bot',
        firstName: 'AI',
        imageUrl:
        "https://storage.googleapis.com/gweb-uniblog-publish-prod/images/final_keyword_header.width-1200.format-webp.webp");

    final aiMessageId = DateTime.now().millisecondsSinceEpoch.toString();
    final aiMessage = types.TextMessage(
      author: aiUser,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: aiMessageId,
      text: '',
    );
    addMessage(aiMessage);

    try {
      final model = GenerativeModel(
        model: 'gemini-1.5-flash-latest',
        apiKey: dotenv.env['GEMINI_API_KEY'].toString(),
      );

      final content = [Content.text(prompt)];
      final responseStream = model.generateContentStream(content);

      await for (final chunk in responseStream) {
        if (chunk.text != null && chunk.text!.isNotEmpty) {
          final index = messages.indexWhere((msg) => msg.id == aiMessageId);

          if (index != -1) {
            final updatedMessage =
            (messages[index] as types.TextMessage).copyWith(
              text: (messages[index] as types.TextMessage).text + chunk.text!,
            );
            messages[index] = updatedMessage;
          }
        }
      }
    } catch (e) {
      final errorMessage = types.TextMessage(
        author: const types.User(
            id: 'ai-bot',
            firstName: 'AI',
            imageUrl:
            "https://storage.googleapis.com/gweb-uniblog-publish-prod/images/final_keyword_header.width-1200.format-webp.webp"),
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        text: 'Error: ${e.toString()}',
      );

      addMessage(errorMessage);
    }
  }
}
