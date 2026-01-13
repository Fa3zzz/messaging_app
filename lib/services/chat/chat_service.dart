import 'package:messaging_app/services/chat/chat_message.dart';
import 'package:messaging_app/services/chat/chat_provider.dart';
import 'package:messaging_app/services/chat/firestore_chat_provide.dart';

class ChatService implements ChatProvider {
  final ChatProvider provider;

  const ChatService(this.provider);

  factory ChatService.firestore() => 
    ChatService(FirestoreChatProvide());

  @override
  Stream<List<ChatMessage>> chatStream(String chatId) {
    return provider.chatStream(chatId);
  }

  @override
  Future<void> sendMessage(ChatMessage message) {
    return provider.sendMessage(message);
  }
}