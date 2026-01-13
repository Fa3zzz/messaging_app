import 'package:messaging_app/services/chat/chat_message.dart';

abstract class ChatProvider {
  
  Future<void> sendMessage(ChatMessage message);

  Stream<List<ChatMessage>> chatStream(String chatId);

}