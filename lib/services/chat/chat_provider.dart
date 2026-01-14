import 'package:messaging_app/services/chat/chat_message.dart';

abstract class ChatProvider {
  
  Future<void> sendMessage({
    required String chatId,
    required String text,
  });

  Stream<List<ChatMessage>> chatStream(String chatId);

}